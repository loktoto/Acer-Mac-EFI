#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#include <ffi.h>
#include <stdint.h>
#include <stdio.h>
#include <stdarg.h>

static void blog(const char *fmt, ...) {
    va_list ap; va_start(ap, fmt);
    char buf[2048]; vsnprintf(buf, sizeof(buf), fmt, ap); va_end(ap);
    FILE *f = fopen("/private/tmp/acerfp-live.log", "a");
    if (f) { fprintf(f, "%s\n", buf); fclose(f); }
}

#define DYLD_INTERPOSE(_replacement,_replacee) \
__attribute__((used)) static struct { const void* replacement; const void* replacee; } \
_interpose_##_replacee __attribute__ ((section ("__DATA,__interpose"))) = \
{ (const void*)(unsigned long)&_replacement, (const void*)(unsigned long)&_replacee };

extern bool isTouchIDPlatform(void);
static bool fake_isTouchIDPlatform(void) { blog("HOOK isTouchIDPlatform -> true"); return true; }
DYLD_INTERPOSE(fake_isTouchIDPlatform, isTouchIDPlatform)

static int fake_send(id self, SEL sel, id envelope, id *replyOut) {
    blog("MSG %s", [[envelope description] UTF8String]);
    NSArray *reply = ([envelope isKindOfClass:[NSArray class]] && [envelope count] == 1)
        ? @[@1, @1] : @[@0];
    if (replyOut) *replyOut = reply;
    return 0;
}
static void fake_setup(id self, SEL sel) { blog("HOOK setupConnection"); }

// Generic forwarder: capture up to 8 pointer-sized ObjC arguments and call the
// original IMP through libffi. Integer arguments live in those same registers.
typedef struct { IMP original; const char *name; } HookInfo;
static uintptr_t forwarder(uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3,
                           uintptr_t a4, uintptr_t a5, uintptr_t a6, uintptr_t a7) {
    HookInfo *info = (HookInfo *)a0; // stored in a global since we cannot add a hidden arg
    (void)info; (void)a1; (void)a2; (void)a3; (void)a4; (void)a5; (void)a6; (void)a7;
    return 0;
}

__attribute__((constructor)) static void boot(void) {
    blog("=== harness pid=%d ===", getpid());
    Class t = objc_getClass("BiometricKitBridgeTransport");
    if (t) {
        method_setImplementation(class_getInstanceMethod(t, NSSelectorFromString(@"sendMessage:andWaitForReply:")), (IMP)fake_send);
        method_setImplementation(class_getInstanceMethod(t, NSSelectorFromString(@"setupConnection")), (IMP)fake_setup);
    }
    blog("ready");
}
