// Verify that a delayed patch (after classes register) can flip both flags.
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <dlfcn.h>
static bool yes(id self, SEL sel) { return true; }
__attribute__((constructor)) static void boot(void) {
  dlopen("/System/Library/Frameworks/LocalAuthentication.framework/Support/coreauthd", RTLD_NOW);
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC), dispatch_get_global_queue(0,0), ^{
    Class d = NSClassFromString(@"DaemonUtils");
    SEL s = NSSelectorFromString(@"deviceHasTouchIDAndSecureDoublePress");
    Method m = d ? class_getClassMethod(d, s) : NULL;
    printf("DELAY DaemonUtils=%p method=%p before=%d\n", (__bridge void*)d, m,
           m ? ((BOOL(*)(id,SEL))objc_msgSend)(d,s) : -1);
    if (m) method_setImplementation(m, (IMP)yes);
    printf("DELAY after=%d\n", ((BOOL(*)(id,SEL))objc_msgSend)(d,s));
    exit(0);
  });
}
int main(void){ [[NSRunLoop currentRunLoop] run]; return 0; }
