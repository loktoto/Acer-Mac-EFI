// fake-bridge.m - injected dylib for the system-level Touch ID experiment.
//
// It runs INSIDE a copy of biometrickitd (or, after SIP is disabled, the real
// daemon) and pretends that a Touch ID platform and a BiometricKitBridge exist.
//
// Current state: the fake bridge answers with the correct reply LENGTH for
// each command, but the payload bytes are not a valid sensor. This gets the
// daemon past the platform check but NOT to an enrolled identity.
//
// Build: see build.sh. Never install this while SIP is enabled.
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#include <string.h>
#include <stdarg.h>

#define LOG_PATH "/private/tmp/acerfp-fake-bridge.log"

static void blog(const char *fmt, ...) {
    va_list ap; va_start(ap, fmt);
    char line[2048]; vsnprintf(line, sizeof(line), fmt, ap); va_end(ap);
    FILE *f = fopen(LOG_PATH, "a");
    if (f) { fprintf(f, "%s\n", line); fclose(f); }
}

#define DYLD_INTERPOSE(_replacement,_replacee) \
__attribute__((used)) static struct { const void* replacement; const void* replacee; } \
_interpose_##_replacee __attribute__ ((section ("__DATA,__interpose"))) = \
{ (const void*)(unsigned long)&_replacement, (const void*)(unsigned long)&_replacee };

extern bool isTouchIDPlatform(void);
static bool fake_isTouchIDPlatform(void) {
    blog("isTouchIDPlatform -> true (fake)");
    return true;
}
DYLD_INTERPOSE(fake_isTouchIDPlatform, isTouchIDPlatform)

static size_t expected_length(unsigned command) {
    switch (command) {
        case 0x01: case 0x0f: case 0x10: case 0x1f: case 0x27: case 0x41: return 4;
        case 0x1d: case 0x2a: case 0x30: case 0x32: case 0x4c: case 0x53: return 1;
        case 0x22: return 0x11;
        case 0x28: return 0x17;
        case 0x29: case 0x38: return 0x10;
        case 0x2e: return 0x20;
        case 0x3a: return 0x21;
        case 0x4e: return 0x1d;
        case 0x08: case 0x11: return 0xbf4;
        default: return 0;
    }
}

static int fake_send(id self, SEL cmd, id envelope, id *replyOut) {
    NSArray *reply;
    if ([envelope isKindOfClass:[NSArray class]] && [envelope count] == 1 &&
        [[envelope objectAtIndex:0] isKindOfClass:[NSNumber class]]) {
        reply = @[@1, @1];                   // getBridgeVersion
    } else {
        unsigned command = 0;
        if ([envelope isKindOfClass:[NSArray class]] && [envelope count] >= 3 &&
            [[envelope objectAtIndex:2] isKindOfClass:[NSData class]]) {
            NSData *request = [envelope objectAtIndex:2];
            const uint8_t *b = [request bytes];
            if ([request length] >= 4 && b[0] == 'B' && b[1] == 'M')
                command = (unsigned)b[2] | ((unsigned)b[3] << 8);
        }
        size_t length = expected_length(command);
        uint8_t buffer[0xbf4] = {0};
        if (command == 1) buffer[0] = 3;     // protocol version
        if (length == 1) buffer[0] = 1;      // enabled/ready flags
        reply = @[@0, [NSData dataWithBytes:buffer length:length]];
        blog("bridge cmd=0x%02x reply=%zu bytes", command, length);
    }
    if (replyOut) *replyOut = reply;
    return 0;
}

static void fake_setup(id self, SEL cmd) { blog("setupConnection -> fake (no device)"); }


static int64_t fake_enrollment_count(id self, SEL sel) { blog("getEnrollmentCount -> 1"); return 1; }
static bool fake_templates_exist(id self, SEL sel) { blog("templatesExistAtBoot -> true"); return true; }
static void install_state_hooks(void) {
    Class server = objc_getClass("BiometricKitXPCServerMesa");
    if (!server) return;
    SEL count = NSSelectorFromString(@"getEnrollmentCount");
    Method m = class_getInstanceMethod(server, count);
    if (m) method_setImplementation(m, (IMP)fake_enrollment_count);
    SEL exists = NSSelectorFromString(@"templatesExistAtBoot");
    Method e = class_getInstanceMethod(server, exists);
    if (e) method_setImplementation(e, (IMP)fake_templates_exist);
    blog("state hooks count=%d templates=%d", m != nil, e != nil);
}

__attribute__((constructor)) static void boot(void) {
    blog("=== fake bridge loaded pid=%d ===", getpid());
    Class transport = objc_getClass("BiometricKitBridgeTransport");
    if (!transport) { blog("transport class not found"); return; }
    Method send = class_getInstanceMethod(transport, NSSelectorFromString(@"sendMessage:andWaitForReply:"));
    Method setup = class_getInstanceMethod(transport, NSSelectorFromString(@"setupConnection"));
    if (send) method_setImplementation(send, (IMP)fake_send);
    if (setup) method_setImplementation(setup, (IMP)fake_setup);
    install_state_hooks();
    blog("ready send=%d setup=%d", send != nil, setup != nil);
}
