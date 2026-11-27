// Read-only: call exported LocalAuthentication / CoreAuthentication C APIs
// that decide whether Touch ID is offered to the UI.
#import <Foundation/Foundation.h>
#include <dlfcn.h>
typedef id (*Fn0)(void);
int main(void) {
    void *h = dlopen("/System/Library/Frameworks/LocalAuthentication.framework/LocalAuthentication", RTLD_NOW);
    if (!h) { printf("dlopen LA failed %s\n", dlerror()); return 1; }
    NSArray *names = @[@"LAEnabledBiometryUsers", @"LACEnabledBiometryUsers", @"LABiometryType", @"LACBiometryType"];
    for (NSString *ns in names) {
        const char *name = [ns UTF8String];
        void *sym = dlsym(h, name);
        if (!sym) { printf("%-24s (absent)\n", name); continue; }
        @try {
            Fn0 fn = (Fn0)sym;
            id v = fn();
            printf("%-24s %s\n", name, [[v description] UTF8String]);
        } @catch (NSException *e) { printf("%-24s EXCEPTION %s\n", name, [[e reason] UTF8String]); }
    }
    return 0;
}
