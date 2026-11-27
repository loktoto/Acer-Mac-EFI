// Layer-2 probe: where does coreauthd get its "enabled biometry users" from?
//
// coreauthd (see ../coreauthd-x86_64.asm around 0x100002CDD) does:
//     userInfo[ _LAEnabledBiometryUsers ] -> uids -> LACADMUser.namesFromUsersWithUIDs:
// right next to MKBGetDeviceLockState and "Failed to create MKB observer".
// So the set is carried in the MobileKeyBag lock-status notification, not
// computed by coreauthd. This probe prints the actual constants and the
// current availability answer. Read-only: no injection, no posting yet.
#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

extern id LAEnabledBiometryUsers;                 // exported data symbol
extern CFStringRef kMobileKeyBagLockStatusNotification;
extern int MKBGetDeviceLockState(CFDictionaryRef options);

static void describe(const char *label, id value)
{
    printf("%s = %s\n", label, value ? [[value description] UTF8String] : "(nil)");
}

int main(void)
{
    @autoreleasepool {
        // The symbol is a pointer variable, so dereference it.
        id key = *(id *)&LAEnabledBiometryUsers;
        describe("LAEnabledBiometryUsers", key);

        CFStringRef note = *(CFStringRef *)&kMobileKeyBagLockStatusNotification;
        printf("kMobileKeyBagLockStatusNotification = %s\n",
               note ? [(__bridge NSString *)note UTF8String] : "(nil)");

        printf("MKBGetDeviceLockState = %d\n", MKBGetDeviceLockState(NULL));

        LAContext *context = [LAContext new];
        NSError *error = nil;
        BOOL can = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                       error:&error];
        printf("canEvaluatePolicy(biometrics) = %d code=%ld type=%ld\n", can,
               (long)error.code, (long)context.biometryType);

        // The dictionary LA would consult, if the framework exposes it.
        Class environment = NSClassFromString(@"LAEnvironment");
        printf("LAEnvironment class = %s\n", environment ? "present" : "absent");
    }
    return 0;
}
