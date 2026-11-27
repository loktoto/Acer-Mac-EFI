Native Touch ID icon experiment - user-space hook kit
=====================================================
WHAT THIS DOES
  Copies the LocalAuthentication UI agent (coreautha) into a user-owned path,
  ad-hoc signs it, and injects libicon-hook.dylib. The hook forces
  MobileGestalt's Touch ID / biometry capability answers to true.
  Goal: make the lock screen draw the Apple Touch ID fingerprint icon.

BACKUP (already taken 2026-11-27 19:35)
  ../../backups/20261127-193554/
  Includes research + touchid archives, launchd states, authdb dumps,
  original UI agent plist, SIP state, verifier hashes.

PREREQUISITE - SIP MUST BE OFF
  This macOS refuses launchctl bootout of an Apple-signed user agent while
  SIP is enabled (error 150). You must do this yourself:
    1. Reboot, hold Cmd-R into Recovery.
    2. Utilities -> Terminal:  csrutil disable
    3. Reboot normally.
  To restore afterwards: same steps with  csrutil enable

INSTALL (after SIP is off, in your own Terminal - no sudo)
  bash "/Users/lokacermac/Documents/AI_Platform/Acer-Mac-EFI/research/touchid-icon-kit/install-icon-agent.sh"

THEN
  Ctrl-Cmd-Q to lock the screen. Look for the fingerprint icon.
  Unlock with your password as usual, then:
  bash "/Users/lokacermac/Documents/AI_Platform/Acer-Mac-EFI/research/touchid-icon-kit/check-icon.sh"

UNDO UI AGENT
  bash "/Users/lokacermac/Documents/AI_Platform/Acer-Mac-EFI/research/touchid-icon-kit/undo-icon-agent.sh"

OPTIONAL ADVANCED STEP (only after the UI agent step is understood)
  sudo bash ".../install-coreauthd-hook.sh"
  sudo bash ".../undo-coreauthd-hook.sh"
  Same hook, applied to the system authentication daemon as well. Requires
  root. If authentication misbehaves, run the undo, or reboot to Recovery
  and delete /Library/LaunchDaemons/com.apple.CoreAuthentication.daemon.plist
  (the original is in /System/Library/LaunchDaemons/).

HONEST LIMITS
  - This only forces the capability ANSWER. It does not create a Secure Enclave
    or enroll a fingerprint. If the icon requires an enrolled SEP identity,
    it still will not appear.
  - coreauthd and AppleKeyStore remain untouched. NO-MATCH / password fallback
    behaviour is unaffected.
  - If the hooked agent fails to start, the undo script restores the Apple job.
    If you cannot log in at all, boot to Recovery and remove:
      ~/Library/LaunchAgents/com.apple.LocalAuthentication.UIAgent.plist

=====================================================================
FINAL VERDICT (2026-11-27 19:50) - DO NOT DISABLE SIP FOR THIS
=====================================================================
Further read-only/user-space research proved this hook kit will not
produce the native Touch ID icon. Evidence:

1. LoginUIKit's MGCopyMultipleAnswers call is in WallpaperAccess
   (desktopPictureSystemPath), NOT biometry. Chasing it was a red herring.
2. LAContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics)
   is answered by coreauthd over XPC. Forcing MobileGestalt in the CLIENT
   process changed nothing:
     baseline          can=false code=-6 type=0
     with full force   can=false code=-6 type=0
3. coreauthd's hardware gate is +[DaemonUtils
   deviceHasTouchIDAndSecureDoublePress], which is an AND of two checks.
   It is registered late; a constructor-time patch misses it. Even when
   patched in a probe (before=0, after=1), availability still depends on
   LAEnabledBiometryUsers, which is fed by the MobileKeyBag/SEP observer.
   No env var or debug override exists (only __OSINSTALL_GUEST_MODE).
4. There is no SEP and no enrolled identity on this machine, so
   LAEnabledBiometryUsers stays empty. Forcing the hardware flag alone
   cannot make LAContext answer true.
5. The hook kit was injected into coreautha, a client-side UI agent that
   asks coreauthd via LAContext. It is the wrong process to patch.

Conclusion: rebooting into Recovery and disabling SIP for this kit is
POINTLESS and would leave the machine less protected. Do not do it.
The kit is kept only as a research record of the dead end.
