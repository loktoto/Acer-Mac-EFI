#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <stdio.h>
#include <string.h>

#define DYLD_INTERPOSE(_replacement,_replacee) \
__attribute__((used)) static struct { const void* replacement; const void* replacee; } \
_interpose_##_replacee __attribute__ ((section ("__DATA,__interpose"))) = \
{ (const void*)(unsigned long)&_replacement, (const void*)(unsigned long)&_replacee };

static void logmsg(const char *fmt, ...) {
    va_list ap; va_start(ap, fmt);
    char buf[1024]; vsnprintf(buf, sizeof(buf), fmt, ap); va_end(ap);
    FILE *f = fopen("/private/tmp/acerfp-fake-bridge.log", "a");
    if (f) { fprintf(f, "%s\n", buf); fclose(f); }
}

extern bool isTouchIDPlatform(void);
static bool fake_isTouchIDPlatform(void) { logmsg("HOOK isTouchIDPlatform -> true"); return true; }
DYLD_INTERPOSE(fake_isTouchIDPlatform, isTouchIDPlatform)

static int fake_send(id self, SEL cmd, id envelope, id *replyOut) {
    logmsg("HOOK sendMessage envelope=%s", [[envelope description] UTF8String]);
    // Different bridge methods expect different reply shapes.
    NSArray *reply;
    if ([envelope isKindOfClass:[NSArray class]] && [envelope count] == 1 &&
        [[envelope objectAtIndex:0] isKindOfClass:[NSNumber class]]) {
        // getBridgeVersion-style: two NSNumbers (version major/minor).
        reply = @[@1, @1];
    } else {
        // performCommand expects reply[0] = status, reply[1] = NSData.
        // Parse the bridge header: "BM" + uint16 command + uint32 version,
        // optionally followed by a uint32 input value.
        unsigned command = 0;
        if ([envelope isKindOfClass:[NSArray class]] && [envelope count] >= 3 &&
            [[envelope objectAtIndex:2] isKindOfClass:[NSData class]]) {
            NSData *request = [envelope objectAtIndex:2];
            const uint8_t *b = [request bytes];
            if ([request length] >= 4 && b[0] == 'B' && b[1] == 'M') {
                command = (unsigned)b[2] | ((unsigned)b[3] << 8);
            }
        }
        // Expected reply lengths extracted from the daemon's disassembly.
        size_t expected = 0;
        switch (command) {
            case 0x01: case 0x0f: case 0x10: case 0x1f: case 0x27: case 0x41: expected = 4; break;
            case 0x1d: case 0x2a: case 0x30: case 0x32: case 0x4c: case 0x53: expected = 1; break;
            case 0x22: expected = 0x11; break;
            case 0x28: expected = 0x17; break;
            case 0x29: case 0x38: expected = 0x10; break;
            case 0x2e: expected = 0x20; break;
            case 0x3a: expected = 0x21; break;
            case 0x4e: expected = 0x1d; break;
            case 0x08: case 0x11: expected = 0xbf4; break;
            default: expected = 0; break;
        }
        uint8_t buffer[0xbf4];
        memset(buffer, 0, sizeof(buffer));
        if (command == 1) { buffer[0] = 3; }  // protocol version
        if (expected == 1) { buffer[0] = 1; } // "enabled"/"ready" style flags
        NSData *payload = [NSData dataWithBytes:buffer length:expected];
        logmsg("   -> CMD=%u reply length=%lu", command, (unsigned long)[payload length]);
        reply = @[@0, payload];
    }
    logmsg("   -> fabricated reply=%s", [[reply description] UTF8String]);
    if (replyOut) *replyOut = reply;
    return 0;
}

static void fake_setup(id self, SEL cmd) { logmsg("HOOK setupConnection (no-op)"); }



static id g_serverInstance = nil;
static void probeCommands(void) {
    Class server = objc_getClass("BiometricKitXPCServerMesa");
    logmsg("server class=%p", (__bridge void *)server);
    if (!server) return;
    id instance = [[server alloc] init];
    logmsg("server instance=%s", [[instance description] UTF8String]);
    g_serverInstance = instance;
    SEL sel = NSSelectorFromString(@"performCommand:inValue:inData:inSize:outData:outSize:");
    if (![instance respondsToSelector:sel]) { logmsg("no performCommand selector"); return; }
    for (unsigned cmd = 1; cmd <= 0x60; cmd++) {
        uint8_t outBytes[128] = {0};
        size_t outSize = sizeof(outBytes);          // capacity in, actual size out
        uint32_t inData = 0; size_t inSize = 0; uint64_t inValue = 0;
        int (*fn)(id, SEL, unsigned, uint64_t, void *, size_t, void *, size_t *) =
            (int (*)(id, SEL, unsigned, uint64_t, void *, size_t, void *, size_t *))objc_msgSend;
        int rc = fn(instance, sel, cmd, inValue, &inData, inSize, outBytes, &outSize);
        logmsg("CMD %u -> rc=%d outSize=%zu first4=%02x%02x%02x%02x", cmd, rc, outSize,
               outBytes[0], outBytes[1], outBytes[2], outBytes[3]);
    }
}


static void probeStateMethods(id instance) {
    unsigned count = 0;
    Method *methods = class_copyMethodList([instance class], &count);
    logmsg("--- state methods (%u) ---", count);
    for (unsigned i = 0; i < count; i++) {
        SEL sel = method_getName(methods[i]);
        const char *name = sel_getName(sel);
        if (strchr(name, ':')) continue;
        if (!strstr(name, "nroll") && !strstr(name, "dentity") && !strstr(name, "vailab") &&
            !strstr(name, "iometr") && !strstr(name, "ser") && !strstr(name, "tat")) continue;
        @try {
            id result = ((id(*)(id, SEL))objc_msgSend)(instance, sel);
            logmsg("STATE %s -> %s", name, [[result description] UTF8String]);
        } @catch (NSException *e) {
            logmsg("STATE %s EXCEPTION %s", name, [[e reason] UTF8String]);
        }
    }
    free(methods);
}


static void dumpIvars(id instance) {
    unsigned count = 0;
    Ivar *ivars = class_copyIvarList([instance class], &count);
    logmsg("--- ivars of %s: %u ---", class_getName([instance class]), count);
    for (unsigned i = 0; i < count; i++) {
        const char *name = ivar_getName(ivars[i]);
        const char *type = ivar_getTypeEncoding(ivars[i]);
        ptrdiff_t offset = ivar_getOffset(ivars[i]);
        if (strstr(name, "nroll") || strstr(name, "ount") || strstr(name, "dentit") ||
            strstr(name, "emplat") || strstr(name, "ser"))
            logmsg("IVAR %s %s offset=%ld", name, type, (long)offset);
    }
    free(ivars);
}

__attribute__((constructor)) static void boot(void) {
    logmsg("=== dylib loaded pid=%d ===", getpid());
    Class transport = objc_getClass("BiometricKitBridgeTransport");
    if (transport) {
        Method m = class_getInstanceMethod(transport, NSSelectorFromString(@"sendMessage:andWaitForReply:"));
        if (m) { method_setImplementation(m, (IMP)fake_send); logmsg("swizzled sendMessage"); }
        Method s = class_getInstanceMethod(transport, NSSelectorFromString(@"setupConnection"));
        if (s) { method_setImplementation(s, (IMP)fake_setup); logmsg("swizzled setupConnection"); }
    }
    probeCommands();
    dumpIvars(g_serverInstance);
    Class server = objc_getClass("BiometricKitXPCServerMesa");
    Ivar ivar = class_getInstanceVariable(server, "_enrollmentCount");
    ptrdiff_t offset = ivar ? ivar_getOffset(ivar) : 0;
    logmsg("ivar=%p offset=%ld", ivar, (long)offset);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_global_queue(0,0), ^{
        if (g_serverInstance && ivar) {
            *(int64_t *)((uint8_t *)(__bridge void *)g_serverInstance + offset) = 1;
            logmsg("DELAYED SET enrollmentCount=1");
            probeStateMethods(g_serverInstance);
        }
    });
}
