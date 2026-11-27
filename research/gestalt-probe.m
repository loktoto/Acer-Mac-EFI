// Calls the same LACMobileGestalt class methods that coreauthd uses to decide
// whether this machine has Touch ID. No injection, no root, no system changes.
#import <Foundation/Foundation.h>
#include <dlfcn.h>
#import <objc/message.h>

int main(void) {
    const char *paths[] = {
        "/System/Library/PrivateFrameworks/LocalAuthenticationCore.framework/LocalAuthenticationCore",
        "/System/Library/PrivateFrameworks/LocalAuthenticationCore.framework/Versions/A/LocalAuthenticationCore",
        NULL
    };
    void *handle = NULL;
    for (int i = 0; paths[i]; i++) {
        handle = dlopen(paths[i], RTLD_NOW);
        if (handle) break;
    }
    if (!handle) { printf("dlopen failed: %s\n", dlerror()); return 1; }
    Class cls = NSClassFromString(@"LACMobileGestalt");
    if (!cls) { puts("LACMobileGestalt class not found"); return 1; }
    const char *sels[] = {"deviceHasTouchID", "deviceHasFaceID", "deviceHasOpticID",
                          "isAppleSilicon", "isLidClosed", "_deviceClass", NULL};
    for (int i = 0; sels[i]; i++) {
        SEL sel = NSSelectorFromString([NSString stringWithUTF8String:sels[i]]);
        if (![cls respondsToSelector:sel]) { printf("%-22s (no method)\n", sels[i]); continue; }
        @try {
            id (*fn)(id, SEL) = (id (*)(id, SEL))objc_msgSend;
            id value = fn(cls, sel);
            printf("%-22s %s\n", sels[i], [[value description] UTF8String]);
        } @catch (NSException *e) {
            printf("%-22s EXCEPTION %s\n", sels[i], [[e reason] UTF8String]);
        }
    }
    return 0;
}
