// Force the MobileGestalt "has Touch ID" answers to true inside a user-owned
// COPY of coreautha. SIP stays on: the copy is ad-hoc signed, so dyld
// interposing is allowed. No /System file is modified.
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <dlfcn.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>

#define LOG "/private/tmp/acerfp-icon-hook.log"
static void hlog(const char *fmt, ...) {
    va_list ap; va_start(ap, fmt);
    char buf[2048]; vsnprintf(buf, sizeof buf, fmt, ap); va_end(ap);
    FILE *f = fopen(LOG, "a");
    if (f) { fprintf(f, "%s\n", buf); fclose(f); }
}

#define DYLD_INTERPOSE(_new,_old) \
__attribute__((used)) static struct { const void *r; const void *o; } \
_interpose_##_old __attribute__((section("__DATA,__interpose"))) = \
{ (const void*)(unsigned long)&_new, (const void*)(unsigned long)&_old };

extern bool MGGetBoolAnswer(CFStringRef question);
extern bool MGIsQuestionValid(CFStringRef question);
extern CFDictionaryRef MGCopyMultipleAnswers(CFArrayRef questions);

static int is_bio_key(CFStringRef q) {
    if (!q) return 0;
    char buf[256] = {0};
    CFStringGetCString(q, buf, sizeof buf, kCFStringEncodingUTF8);
    return strstr(buf, "Touch") || strstr(buf, "touch") ||
           strstr(buf, "Biometr") || strstr(buf, "biometr") ||
           strstr(buf, "Finger") || strstr(buf, "finger") ||
           strstr(buf, "Enroll") || strstr(buf, "enroll");
}

static bool my_MGGetBoolAnswer(CFStringRef q) {
    char buf[256] = {0};
    if (q) CFStringGetCString(q, buf, sizeof buf, kCFStringEncodingUTF8);
    bool real = MGGetBoolAnswer(q);
    bool force = is_bio_key(q) && getenv("ACERFP_FORCE_GESTALT") != NULL;
    if (force) hlog("MGGetBoolAnswer '%s': %d -> 1", buf, real);
    return force ? true : real;
}
DYLD_INTERPOSE(my_MGGetBoolAnswer, MGGetBoolAnswer)

static bool my_MGIsQuestionValid(CFStringRef q) {
    bool real = MGIsQuestionValid(q);
    if (is_bio_key(q) && getenv("ACERFP_FORCE_GESTALT")) return true;
    return real;
}
DYLD_INTERPOSE(my_MGIsQuestionValid, MGIsQuestionValid)

static CFDictionaryRef my_MGCopyMultipleAnswers(CFArrayRef questions) {
    CFMutableDictionaryRef answers = CFDictionaryCreateMutable(NULL, 0,
        &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFIndex n = questions ? CFArrayGetCount(questions) : 0;
    hlog("MGCopyMultipleAnswers: %ld questions", n);
    BOOL force = getenv("ACERFP_FORCE_GESTALT") != NULL;
    for (CFIndex i = 0; i < n; i++) {
        CFStringRef q = (CFStringRef)CFArrayGetValueAtIndex(questions, i);
        char buf[256] = {0};
        if (q) CFStringGetCString(q, buf, sizeof buf, kCFStringEncodingUTF8);
        Boolean val = MGGetBoolAnswer(q);
        if (force && is_bio_key(q)) { hlog("  forced '%s'", buf); val = true; }
        else hlog("  '%s' = %d", buf, val);
        CFDictionarySetValue(answers, q, val ? kCFBooleanTrue : kCFBooleanFalse);
    }
    return answers;
}
DYLD_INTERPOSE(my_MGCopyMultipleAnswers, MGCopyMultipleAnswers)

static bool yes(id self, SEL sel) { hlog("forced +[LACMobileGestalt %s]", sel_getName(sel)); return true; }
static id yesObj(id self, SEL sel) { hlog("forced +[LACMobileGestalt %s]", sel_getName(sel)); return @YES; }

__attribute__((constructor)) static void boot(void) {
    hlog("=== icon hook loaded pid=%d force=%s ===", getpid(),
         getenv("ACERFP_FORCE_GESTALT") ? "yes" : "no");
    dlopen("/System/Library/PrivateFrameworks/LocalAuthenticationCore.framework/LocalAuthenticationCore", RTLD_NOW);
    Class cls = NSClassFromString(@"LACMobileGestalt");
    if (cls && getenv("ACERFP_FORCE_GESTALT")) {
        const char *names[] = {"deviceHasTouchID","deviceHasFaceID","deviceHasOpticID",NULL};
        for (int i=0; names[i]; i++) {
            SEL sel = NSSelectorFromString([NSString stringWithUTF8String:names[i]]);
            Method m = class_getClassMethod(cls, sel);
            if (m) method_setImplementation(m, (IMP)yes);
        }
    }
    // DaemonUtils is registered later; patch it after the run loop starts.
    if (getenv("ACERFP_FORCE_GESTALT")) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC),
                       dispatch_get_global_queue(0,0), ^{
            Class du = NSClassFromString(@"DaemonUtils");
            SEL s = NSSelectorFromString(@"deviceHasTouchIDAndSecureDoublePress");
            Method m = du ? class_getClassMethod(du, s) : NULL;
            if (m) method_setImplementation(m, (IMP)yes);
            hlog("DELAYED DaemonUtils patched=%d", m != NULL);
        });
    }
    // DTODeviceInfoProvider is the final gate LAContext consults: whether
    // the current user has any enrolled biometric identity. Patch the
    // enrollment query itself (registered late, so do it asynchronously).
    if (getenv("ACERFP_FORCE_GESTALT")) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1200*NSEC_PER_MSEC),
                       dispatch_get_global_queue(0,0), ^{
            Class e = NSClassFromString(@"DTODeviceInfoProvider");
            const char *names[] = {"hasBiometricEnrollmentsForCurrentUser",
                                   "hasBiometricEnrollmentsForUser:", NULL};
            if (e) for (int i=0; names[i]; i++) {
                SEL sel = NSSelectorFromString([NSString stringWithUTF8String:names[i]]);
                Method m = class_getInstanceMethod(e, sel);
                if (m) { method_setImplementation(m, (IMP)yes); hlog("patched %s", names[i]); }
            }
        });
    }
    hlog("ready");
}
