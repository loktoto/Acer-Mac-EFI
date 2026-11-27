// Run a COPY of coreauthd in the user session with the icon hook injected,
// then call its own internal availability method. No root, no SIP change.
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <dlfcn.h>
int main(void) {
    const char *paths[] = {
      "/System/Library/Frameworks/LocalAuthentication.framework/Support/coreauthd",
      "/System/Library/PrivateFrameworks/LocalAuthenticationCore.framework/LocalAuthenticationCore",
      NULL };
    void *h = NULL;
    for (int i=0; paths[i]; i++) { h = dlopen(paths[i], RTLD_NOW); if (h) break; }
    printf("coreauthd dlopen=%p\n", h);
    Class c = NSClassFromString(@"LACMobileGestalt");
    printf("LACMobileGestalt=%p\n", (__bridge void *)c);
    if (c) {
      SEL s = NSSelectorFromString(@"deviceHasTouchID");
      BOOL (*fn)(id,SEL) = (BOOL(*)(id,SEL))objc_msgSend;
      printf("deviceHasTouchID=%d\n", fn(c,s));
    }
    Class d = NSClassFromString(@"DaemonUtils");
    printf("DaemonUtils=%p\n", (__bridge void *)d);
    if (d) {
      SEL s = NSSelectorFromString(@"deviceHasTouchIDAndSecureDoublePress");
      BOOL (*fn)(id,SEL) = (BOOL(*)(id,SEL))objc_msgSend;
      printf("deviceHasTouchIDAndSecureDoublePress=%d\n", fn(d,s));
    }
    return 0;
}
