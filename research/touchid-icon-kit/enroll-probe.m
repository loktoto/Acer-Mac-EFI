// Directly ask the DTODeviceInfoProvider methods that coreauthd uses to
// report whether biometry is enrolled. Runs in a copied-coreauthd process.
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <dlfcn.h>
static void ask(const char *clsName, const char *selName) {
    Class c = NSClassFromString([NSString stringWithUTF8String:clsName]);
    if (!c) { printf("%s.%s: NO CLASS\n", clsName, selName); return; }
    SEL s = NSSelectorFromString([NSString stringWithUTF8String:selName]);
    id obj = [[c alloc] init];
    if (![obj respondsToSelector:s]) { printf("%s.%s: NO SEL\n", clsName, selName); return; }
    @try {
        BOOL (*fn)(id,SEL) = (BOOL(*)(id,SEL))objc_msgSend;
        printf("%s.%s = %d\n", clsName, selName, fn(obj,s));
    } @catch (NSException *e) { printf("%s.%s EXC %s\n", clsName, selName, [[e reason] UTF8String]); }
}
__attribute__((constructor)) static void boot(void) {
    dlopen("/System/Library/Frameworks/LocalAuthentication.framework/Support/coreauthd", RTLD_NOW);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC), dispatch_get_global_queue(0,0), ^{
        printf("=== BASELINE (hook forced flags already applied) ===\n");
        ask("DTODeviceInfoProvider", "hasBiometricEnrollmentsForCurrentUser");
        printf("=== class list check ===\n");
        printf("DTODeviceInfoProvider=%p\n", (__bridge void*)NSClassFromString(@"DTODeviceInfoProvider"));
        exit(0);
    });
}
int main(void){ [[NSRunLoop currentRunLoop] run]; return 0; }
