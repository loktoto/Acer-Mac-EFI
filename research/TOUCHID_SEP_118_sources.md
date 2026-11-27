# Deep research: Hackintosh Touch ID / Secure Enclave pairing / EgisTec 0570

Generated: 2026-11-25 00:17:17
- Tool: agent-reach web search (Exa semantic search), 37 query calls
- Raw items: 185
- Unique sources: 118
- Errors: 0 (github jina 403 worked around with exa/agent-reach web read)

## Executive conclusion

**Creating a Secure Enclave factory pairing key for a third-party sensor is impossible on this hardware, and by design on all hardware.** Multiple independent sources converge:

- Apple Platform Security / Magic Keyboard docs: the sensor-to-SEP channel uses a factory-provisioned shared key, PKA attestation rooted in an Apple CA, and ECDHE. Templates are processed and stored only inside the Secure Enclave. Pairing is done in the factory or by the user only with genuine Apple hardware (Magic Keyboard with Touch ID).
- standalone-touchid docs: "There is no way to have a non-Apple sensor talk to the Secure Enclave." / "Every other sensor is locked out of the Secure Enclave by design." The only module that achieves real Touch ID is a cannibalized Apple Magic Keyboard with its original sensor + PKA block.
- Apple StackExchange (accepted, score 51): external fingerprint readers cannot work like the built-in Touch ID on Intel Macs; the sensor talks to a separate ARM core (T2 SEP), and third parties cannot attach to it.
- Local measurement on this host (`Too-Mac`, SMBIOS MacBookPro15,2): `ioreg` has no `AppleSEPManager` / `AppleBiometricSensor` node; `AppleSEPManager.kext` is loaded but has no hardware; `LAContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics)` returns false, code -6. No SEP hardware exists to pair with.

**Therefore step 2 of the request cannot be performed.** The honest fallback (back to step 0/1) is to reproduce the *effect* of Touch ID without touching the SEP trust chain. The research found three real implementations, ranked:

1. **HTID / hack-touchid** (best fit): a macOS daemon that watches authentication prompts, captures a swipe from a supported USB sensor, matches locally with NIST NBIS, and types the stored password into the prompt. Lock screen, System Settings padlock, Keychain prompts. Does not modify authorizationdb, does not claim to be Apple Touch ID, and is designed for hackintoshes. Limitation: supported sensors are VFS5011 `138a:0018`, Synaptics Metallica `06cb:009a`, Prometheus `138a:0097`; EgisTec `1c7a:0570` is **not** supported (`1c7a:05a1` is only "planned", issue #15). Reusing its prompt-watch + password handoff layer with our existing egis0570 capture/matcher is the concrete path.
2. **Custom Authorization plug-in** (already staged in this workspace, `migration/`): add a branch to `system.login.screensaver` OR rule; keeps password fallback. Covers lock screen only, not Keychain/app prompts, and needs careful install to avoid lockout.
3. **Cannibalized Apple Magic Keyboard with Touch ID**: the only way to get real macOS Touch ID, but needs Apple hardware with PKA block and an Apple-silicon Mac; not applicable to this Acer/egis0570 sensor.

A fourth idea, spoofing `AppleBiometricSensor` in IORegistry or patching `biometrd`/`localauthenticationd` to report availability, was considered and rejected: it forges security state rather than emulating hardware, would require disabling SIP and patching signed system daemons, and provides no real SEP-backed authentication. It is not implemented.

## HTID technical notes (most relevant implementation evidence)

- Architecture: libusb capture (native C, no libfprint at runtime) + NIST NBIS `mindtct` (minutiae) + `bozorth3` (match). Default match threshold 20; enroll 5 good swipes. Templates + stored password on an encrypted APFS volume, password in System keychain.
- Prompt handling: a background daemon watches for auth prompts via Accessibility APIs and types the stored password on match. A menu-bar app shows Waiting for fingerprint / Authenticated / Not recognized. A System Settings pane manages fingerprints and threshold.
- The `Fpbootd-AuthPlugin-Spike` in the repo is an authorization-plugin experiment. Its real-hardware finding is important: a third-party plugin **cannot** suppress Apple's login password UI. Injecting username/password into the context succeeded but `loginwindow:login` still drew its prompt. The safe design it converged on: always call `SetResult(kAuthorizationResultAllow)` on every path, so the mechanism can never deny login or remove the password option; the real decision stays with `builtin:authenticate,privileged`. It is placed after `builtin:auto-login,privileged`, with capture timeout 25s and daemon swipe deadline ~6s.
- Our staged plug-in already uses the same allow/deny mechanism; before migrating, align with this finding: never return Deny from a fingerprint branch on the login chain, or you risk lockout.

## Top-relevant sources

### 1. [score 37] Hackintosh Touch ID - HTID
- URL: https://hackintosh-user.github.io/hack-touchid/
- Excerpt: # Touch ID for Hackintosh Fingerprint authentication for macOS on unsupported hardware. Unlock with a real fingerprint sensor instead of typing your password. ## What is it? HTID is a fingerprint authentication daemon for macOS on Hackintosh hardware. It ports the USB capture protocol of supported fingerprint sensors to native C, matches swipes with NIST's NBIS suite, and types your password into the macOS prompt when your finger matches. It is not a kernel extension and not a libfprint port. Bu

### 2. [score 35] Guide - HTID
- URL: https://hackintosh-user.github.io/hack-touchid/guide.html
- Excerpt: ## Requirements - macOS 14 Sonoma or later (macOS 15 Sequoia or later recommended). Older versions get zero support. - OpenCore v1.0.6 or later. v1.0.5 and older are not supported. - Xcode Command Line Tools: `xcode-select --install` - Homebrew, then `brew install libusb openssl@3 innoextract` - Accessibility permission for the daemon. The deploy step handles this for you. - Your sensor must be enabled in your USBMap so it is powered. Check System Information, USB, for your sensor's VID:PID. Hea

### 3. [score 34] Security - HTID
- URL: https://hackintosh-user.github.io/hack-touchid/security.html
- Excerpt: ## Overview HTID intercepts macOS authentication prompts (login screen, System Settings padlock and Keychain prompts) and satisfies them with a fingerprint swipe from a supported USB sensor, matched against locally stored templates. Different sensors have real architectural differences. Some match on the host, others match on the chip and never expose raw image data, so read the per-backend notes below. Not audited. It touches sensitive parts of macOS (authentication, sudoers, LaunchAgents, Keyc

### 4. [score 32] hackintosh-user/hack-touchid
- URL: https://github.com/hackintosh-user/hack-touchid
- Excerpt: ## Overview This project ports the USB capture protocol for supported fingerprint sensors to a standalone macOS C code, and pairs it with NIST's NBIS fingerprint matching suite (`mindtct` for minutiae extraction, `bozorth3` for matching) to provide working fingerprint authentication on Hackintosh hardware that shipped with this sensor but has no native macOS driver support. It is not a kernel extension or a libfprint port. It runs as a small background daemon that watches for authentication prom

### 5. [score 32] jerzy99jerzy/standalone-touchid
- URL: https://github.com/jerzy99jerzy/standalone-touchid
- Excerpt: Standalone Touch ID for Apple Silicon Macs: 3D-printed enclosure build guide ... > **A biometric authentication puck for Apple Silicon Macs, built by cannibalizing a Magic Keyboard with Touch ID (A2449) and rehousing its electronics in a 3D-printed enclosure. The interesting part is not the enclosure. It is the claim that rehousing changes nothing the Secure Enclave depends on, and this repository exists to justify that claim rather than assert it.** **Status:** documentation and analysis, with 

### 6. [score 28] Magic Keyboard with Touch ID - Apple Support
- URL: https://support.apple.com/guide/security/magic-keyboard-with-touch-id-secf60513daa/web
- Excerpt: # Magic Keyboard with Touch ID The Magic Keyboard with Touch ID (and the Magic Keyboard with Touch ID and Numeric Keypad) provides a Touch ID sensor in an external keyboard that can be used with any Mac with Apple silicon. The Magic Keyboard with Touch ID performs the role of the biometric sensor; it doesn’t store biometric templates, perform biometric matching, or enforce security policies (for example, having to enter the password after 48 hours without an unlock). The Touch ID sensor in the M

### 7. [score 28] Locked use overwrites the Platform SSO screensaver rule and prevents password unlock
- URL: https://github.com/openai/codex/issues/47470
- Excerpt: # Locked use overwrites the Platform SSO screensaver rule and prevents password unlock - State: open - Author: liby - Created: 2026-09-23T06:40:59Z - Updated: 2026-09-30T09:53:10Z - Repository: openai/codex - Number: #47470 ## Labels - bug - app - computer-use --- ## Summary On a Mac where Platform SSO (Microsoft Entra) handles the lock screen, enabling **Locked use** replaces the `system.login.screensaver` authorization rule with one that cannot verify a Platform SSO password. Entering the corr

### 8. [score 28] I built a Touch ID-style fingerprint unlock for a fingerprint sensor on a 2012 laptop (VFS5011) — open source, works on Sequoia + Tahoe : r/hackintosh
- URL: https://www.reddit.com/r/hackintosh/comments/1vmvic1/i_built_a_touch_idstyle_fingerprint_unlock_for_a/
- Excerpt: # I built a Touch ID-style fingerprint unlock for a fingerprint sensor on a 2012 laptop (VFS5011) — open source, works on Sequoia + Tahoe Posted by **u/Sufficient_Bus_8302** in r/hackintosh · 47 points · 11 comments · August 13, 2026 at 12:26 AM UTC Been running a heavily customized HP Pavilion DV6-7070ex (i7-3610QM, Ivy Bridge) as a daily-driver Hackintosh, and one thing that always wanted was **biometric unlock** on Hackintosh, obviously no T2/Secure Enclave on this hardware. Turns out a lot o

### 9. [score 26] docs/01-protocol.md
- URL: https://github.com/jerzy99jerzy/standalone-touchid/blob/main/docs/01-protocol.md
- Excerpt: Everything in this section is sourced from Apple's Platform Security guide. Where this document draws a conclusion Apple does not state directly, it is labeled as inference. ... Apple's biometric architecture rests on a strict division of labor between the sensor and the Secure Enclave, connected by a secured channel. The sensor captures the biometric image and transmits it. The Secure Enclave does everything else: during enrollment it processes, ... Magic Keyboard with Touch ID does not store b

### 10. [score 24] docs/STATUS.md
- URL: https://github.com/dssoftx/Hackintosh-X1Carbon-G11-IrisXe-Tahoe/blob/main/docs/STATUS.md
- Excerpt: # Status (October 2026, macOS Tahoe 26.7.1 25G241) ... - **Fingerprint for sudo** (since 2026-10-22): the Goodix 27C6:63BC sensor works through libfprint's goodixmoc driver (match-on-chip, built for macOS with a small patch) and a PAM module in `/etc/pam.d/sudo_local` (`tools/fingerprint`). Login, screen unlock, Touch ID settings, Apple Pay and LocalAuthentication prompts are **not** supported: they need the Secure Enclave, which a hackintosh does not have. - **Power button locks the screen**: a

### 11. [score 24] Secure intent and connections to the Secure Enclave - Apple Support
- URL: https://support.apple.com/guide/security/secure-intent-connections-enclave-sec7a94f7d1e/web
- Excerpt: Secure intent provides a way to confirm a user’s intent without any interaction with the operating system or Application Processor. The connection is a physical link—from a physical button to the Secure Enclave—that’s available in the following: - All iPhone models starting with iPhone X or later - All iPad models starting with iPad Air (4th generation) or later - All Mac computers with Apple silicon - All Apple Watch models starting with Apple Watch Series 1 or later - Apple Vision Pro With thi

### 12. [score 22] Locked Use authorization plugin leaves the login keychain permanently locked for the rest of the session
- URL: https://github.com/openai/codex/issues/40226
- Excerpt: - State: open - Author: Fonsi479 - Created: 2026-08-23T11:29:00Z - Updated: 2026-11-09T02:46:29Z - Repository: openai/codex - Number: #40226 ... ## Environment | | | |---|---| | macOS | 26.5.2 (25F84), Apple Silicon | | FileVault | On | | ChatGPT.app | 26.818.41509 (6962) | | Installed authorization plugin | **799** (`CFBundleShortVersionString` 0.1.0) | | Plugin bundled in ChatGPT.app installer | **1000816** (26.819.1000816) | | `~/.codex/computer-use/Codex Computer Use.app` | **1000816** | | P

### 13. [score 21] 1c7a:0570 fingerprint reader on Linux: EgisTec EgisTec0570 - calibration fix
- URL: https://fprint.jedbillyb.com/devices/1c7a-0570/
- Excerpt: 1c7a:0570 fingerprint reader on Linux: EgisTec EgisTec0570 - calibration fix # EgisTec EgisTec0570 - calibration fix (USB 1c7a:0570, 1c7a:0571) Status: Claimed upstream by the `egis0570` driver, but unreliable. Fix MR open. The in-tree `egis0570` driver covers `1c7a:0570` and `1c7a:0571`, but calibration is not implemented properly, which shows up as erratic captures and unreliable verification (libfprint issue #418). ## What the fix does libfprint MR !548 ("fix: calibration for egis0570", Saeed

### 14. [score 20] Apple updates Platform Security guide with details on iPhone Apple Watch unlock, Touch ID Magic Keyboard - 9to5Mac
- URL: https://9to5mac.com/2021/05/17/apple-updates-platform-security-guide/
- Excerpt: Michael Potuck | May 17 2021 - 7:56 am PT Apple released its 2021 Platform Security guide back in February with new details on M1 Macs, iOS 14, macOS Big Sur, watchOS 7, and more. ... The revised Platform Security Guide goes in-depth describing how the new Magic Keyboard with Touch ID that comes with the new M1 iMacs works, and more. > The Magic Keyboard with Touch ID performs the role of the biometric sensor; it doesn’t store biometric templates, perform biometric matching, or enforce security 

### 15. [score 20] indev29/egis0570
- URL: https://github.com/indev29/egis0570
- Excerpt: # indev29/egis0570 EgisTec fingerprint sensor driver - Stars: 47 - Forks: 11 - Watchers: 47 - Open issues: 0 - Default branch: master - Created: 2018-02-03T13:45:37Z - Status: ARCHIVED ## Top Contributors - indev29 (16 contributions) - saeedark (1 contributions) --- ## README # egis0570 This is the project aiming to provide Linux support for Egis Technology Inc. ID 1c7a:0570 fingerprint scanner (also known as LighTuning Technology Inc.) Driver is merged to libfprint since v1.92.1 (implemented as

### 16. [score 20] hwdb.d/60-autosuspend-fingerprint-reader.hwdb
- URL: https://github.com/systemd/systemd/blob/main/hwdb.d/60-autosuspend-fingerprint-reader.hwdb
- Excerpt: # hwdb.d/60-autosuspend-fingerprint-reader.hwdb - Branch: main - Repository: systemd/systemd --- # This file is part of systemd. # # Rules to autosuspend known fingerprint readers (pulled from libfprint). # # SPDX-License-Identifier: LGPL-2.1-or-later # This file has been generated using fprint-list-udev-hwdb with all drivers enabled ... # Supported by libfprint driver egis0570 usb:v1C7Ap0570* usb:v1C7Ap0571* ID_AUTOSUSPEND=1 ID_PERSIST=0 # Supported by libfprint driver egis_etu905 usb:v1C7Ap05A

### 17. [score 20] jedbillyb/linux-fingerprint-drivers
- URL: https://github.com/jedbillyb/linux-fingerprint-drivers
- Excerpt: ## In progress (unmerged upstream MRs) Drivers that have been submitted to the **official libfprint project** but are **not merged yet**, so they are not in any released libfprint. Each has an entry under `devices/` with the merge-request link and build notes. Status changes to Working here once someone confirms it, and the row moves once the MR lands upstream. MR states were last verified against GitLab on **2026-11-17**; the merge request itself is always the authority. | Device ID | Chip / se

### 18. [score 20] Apple Platform Security
- URL: https://help.apple.com/pdf/security/en_US/apple-platform-security-guide.pdf
- Excerpt: Touch ID security Touch ID is the fingerprint sensing system that makes secure access to supported Apple devices faster and easier. This technology reads fingerprint data from any angle and learns more about a user’s fingerprint over time, with the sensor continuing to expand the fingerprint map as additional overlapping nodes are identified with each use. Apple devices with a Touch ID sensor can be unlocked using a fingerprint. Touch ID doesn’t replace the need for a device passcode or user pas

### 19. [score 20] README.md
- URL: https://github.com/hackintosh-user/VFS5011-hackintosh/blob/main/README.md
- Excerpt: ## Overview This project ports the USB capture protocol for supported fingerprint sensors to a standalone macOS C code, and pairs it with NIST's NBIS fingerprint matching suite (`mindtct` for minutiae extraction, `bozorth3` for matching) to provide working fingerprint authentication on Hackintosh hardware that shipped with this sensor but has no native macOS driver support. It is not a kernel extension or a libfprint port. It runs as a small background daemon that watches for authentication prom

### 20. [score 19] Issues · hackintosh-user/hack-touchid · GitHub
- URL: https://github.com/hackintosh-user/hack-touchid/issues
- Excerpt: - [New sensor] ELAN 04f3:0c6e works — separate macOS unlock implementation, happy to help port it #11 · s17765152890-gif opened on Nov 8, 2026 ... - ### Sensor request: ELAN WBF – HP Envy x360 15, 2020 documentation enhancement ... - ### Sensor request: EGIS ETU905A80-E (1c7a:05a1) – Samsung Galaxy Book3 Ultra documentation enhancement hackintosh-user/hack-touchid#15 · Filter by author vikenzo196 opened on Nov 10, 2026 ... - ### Support Request: Synaptics VFS7552 on HP Elitebook 1030 x360 G3 ---

### 21. [score 19] go-macos/localauthentication
- URL: https://github.com/go-macos/localauthentication
- Excerpt: Ask macOS to authenticate the person at the keyboard — **Touch ID**, or the login password — from pure Go with `CGO_ENABLED=0`. It binds `LAContext` through `go-macos/objc` (Objective-C message sends over `ebitengine/purego`), so it links with **no cgo** and shells out to nothing. ```go import "github.com/go-macos/localauthentication" // Is there a sensor, and of what kind? (No prompt.) kind, err := localauthentication.Biometry() // "Touch ID" / "none" // Could this be evaluated right now? (No p

### 22. [score 19] Has anyone unlocked hackintosh with touchID from magic keyboard? : r/hackintosh
- URL: https://www.reddit.com/r/hackintosh/comments/1rrlwqe/has_anyone_unlocked_hackintosh_with_touchid_from/
- Excerpt: # Has anyone unlocked hackintosh with touchID from magic keyboard? Posted by **u/Conscious_Invite_529** in r/hackintosh · 107 points · 28 comments · March 12, 2026 at 9:18 AM UTC It would be so fucking funny if it could be work on hackintosh... https://i.redd.it/4ba8kz2h0log1.png ## Top comments (6 shown of 28 reported) **u/ronjns** · 86 points · March 12, 2026 at 10:07 AM UTC > I think you need T2 security chip on Intel platform to use TouchID. **u/topiga** · 37 points · March 12, 2026 at 1:27 

### 23. [score 18] docs/02-alternatives.md
- URL: https://github.com/jerzy99jerzy/standalone-touchid/blob/main/docs/02-alternatives.md
- Excerpt: Three paths considered and rejected, and one that is not rejected at all. ## 2.1 Apple Watch SE The obvious first thought: instead of cannibalizing a keyboard for around $100, use hardware whose macOS authorization function is already officially supported. Apple Watch (Auto Unlock and Approve with Apple Watch) covers a significant portion of Touch ID's desktop function - `sudo`, unlock Keychain, `pkg` installations, System Settings authorizations - through a double-press of the side button. ### 

### 24. [score 18] Turning an Apple Wireless Keyboard Into a Dedicated Touch ID Box
- URL: https://jimjordan.design/posts/turning-an-apple-wireless-keyboard-into-a-dedicated-touch-id-box
- Excerpt: The only catch: on desktops and non-Apple keyboards, Touch ID is tied to the Magic Keyboard with Touch ID. Apple doesn’t sell a standalone Touch ID puck, and the sensor won’t work without Apple’s keyboard controller because of Secure Enclave pairing. So instead of waiting for Apple to make the product I want, I made it myself: I hacked a wireless Apple keyboard into a small, desk-friendly Touch ID box. ---

### 25. [score 18] EgisTec 0570 Fingerprint Sensor - fprintd-enroll not working
- URL: https://unix.stackexchange.com/questions/664879/egistec-0570-fingerprint-sensor-fprintd-enroll-not-working
- Excerpt: # EgisTec 0570 Fingerprint Sensor - fprintd-enroll not working Tags: arch-linux, uefi, hardware, fingerprint - Score: 3 - Views: 1063 - Answers: 0 - Asked by: mipy (31 rep) - Asked: 2021-08-16 - Edited: 2025-03-01 - Site: unix ## Question I have an Acer Swift 3 (SF314-57) running arch, which has an 0570 LighTuning Technology Inc. EgisTec Touch Fingerprint Sensor. Support for this device was just made available in the latest libfprint release (v1.92.1), so naturally I have been trying to get it w

## All sources (score ordered)

1. [37] Hackintosh Touch ID - HTID — https://hackintosh-user.github.io/hack-touchid/
2. [35] Guide - HTID — https://hackintosh-user.github.io/hack-touchid/guide.html
3. [34] Security - HTID — https://hackintosh-user.github.io/hack-touchid/security.html
4. [32] hackintosh-user/hack-touchid — https://github.com/hackintosh-user/hack-touchid
5. [32] jerzy99jerzy/standalone-touchid — https://github.com/jerzy99jerzy/standalone-touchid
6. [28] Magic Keyboard with Touch ID - Apple Support — https://support.apple.com/guide/security/magic-keyboard-with-touch-id-secf60513daa/web
7. [28] Locked use overwrites the Platform SSO screensaver rule and prevents password unlock — https://github.com/openai/codex/issues/47470
8. [28] I built a Touch ID-style fingerprint unlock for a fingerprint sensor on a 2012 laptop (VFS5011) — open source, works on  — https://www.reddit.com/r/hackintosh/comments/1vmvic1/i_built_a_touch_idstyle_fingerprint_unlock_for_a/
9. [26] docs/01-protocol.md — https://github.com/jerzy99jerzy/standalone-touchid/blob/main/docs/01-protocol.md
10. [24] docs/STATUS.md — https://github.com/dssoftx/Hackintosh-X1Carbon-G11-IrisXe-Tahoe/blob/main/docs/STATUS.md
11. [24] Secure intent and connections to the Secure Enclave - Apple Support — https://support.apple.com/guide/security/secure-intent-connections-enclave-sec7a94f7d1e/web
12. [22] Locked Use authorization plugin leaves the login keychain permanently locked for the rest of the session — https://github.com/openai/codex/issues/40226
13. [21] 1c7a:0570 fingerprint reader on Linux: EgisTec EgisTec0570 - calibration fix — https://fprint.jedbillyb.com/devices/1c7a-0570/
14. [20] Apple updates Platform Security guide with details on iPhone Apple Watch unlock, Touch ID Magic Keyboard - 9to5Mac — https://9to5mac.com/2021/05/17/apple-updates-platform-security-guide/
15. [20] indev29/egis0570 — https://github.com/indev29/egis0570
16. [20] hwdb.d/60-autosuspend-fingerprint-reader.hwdb — https://github.com/systemd/systemd/blob/main/hwdb.d/60-autosuspend-fingerprint-reader.hwdb
17. [20] jedbillyb/linux-fingerprint-drivers — https://github.com/jedbillyb/linux-fingerprint-drivers
18. [20] Apple Platform Security — https://help.apple.com/pdf/security/en_US/apple-platform-security-guide.pdf
19. [20] README.md — https://github.com/hackintosh-user/VFS5011-hackintosh/blob/main/README.md
20. [19] Issues · hackintosh-user/hack-touchid · GitHub — https://github.com/hackintosh-user/hack-touchid/issues
21. [19] go-macos/localauthentication — https://github.com/go-macos/localauthentication
22. [19] Has anyone unlocked hackintosh with touchID from magic keyboard? : r/hackintosh — https://www.reddit.com/r/hackintosh/comments/1rrlwqe/has_anyone_unlocked_hackintosh_with_touchid_from/
23. [18] docs/02-alternatives.md — https://github.com/jerzy99jerzy/standalone-touchid/blob/main/docs/02-alternatives.md
24. [18] Turning an Apple Wireless Keyboard Into a Dedicated Touch ID Box — https://jimjordan.design/posts/turning-an-apple-wireless-keyboard-into-a-dedicated-touch-id-box
25. [18] EgisTec 0570 Fingerprint Sensor - fprintd-enroll not working — https://unix.stackexchange.com/questions/664879/egistec-0570-fingerprint-sensor-fprintd-enroll-not-working
26. [18]  — https://lists.freedesktop.org/archives/fprint/attachments/20180211/f6be3cfe/attachment.html
27. [18] Re: [fprint] Verification help request (Egis Technology 1c7a:0570) — https://www.mail-archive.com/fprint@lists.freedesktop.org/msg00962.html
28. [17] Biometric security - Apple Support — https://support.apple.com/guide/security/biometric-security-sec067eb0c9e/web
29. [17] Local Authentication — https://developer.apple.com/documentation/localauthentication.md
30. [17] github.com/go-macos/localauthentication — https://pkg.go.dev/github.com/go-macos/localauthentication
31. [17] About Touch ID advanced security technology - Apple Support — https://support.apple.com/en-us/105095
32. [16] GitHub - saeedark/newEgis0570: updating the old driver · GitHub — https://github.com/saeedark/newEgis0570
33. [15] Logging a User into Your App with Face ID or Touch ID — https://developer.apple.com/documentation/localauthentication/logging-a-user-into-your-app-with-face-id-or-touch-id.md
34. [15] Linux fingerprint reader drivers: sensors libfprint does not support — https://fprint.jedbillyb.com/
35. [15] drphilth/honor-fmbp-libfprint-sdcp — https://github.com/drphilth/honor-fmbp-libfprint-sdcp
36. [15] Demystifying Apple’s Touch ID — https://hackernoon.com/demystifying-apples-touch-id-4883d5121b77
37. [15] Protecting keys with the Secure Enclave — https://developer.apple.com/documentation/security/protecting-keys-with-the-secure-enclave.md
38. [15] kotakbiasa/ThinkPad-X380-Yoga-Hackintosh — https://github.com/kotakbiasa/ThinkPad-X380-Yoga-Hackintosh
39. [14] Help grow this! - HTID — https://hackintosh-user.github.io/hack-touchid/contribute.html
40. [14] tmullender/egis-eh570 — https://github.com/tmullender/egis-eh570
41. [14] Use Touch ID on Mac - Apple Support — https://support.apple.com/guide/mac-help/use-touch-id-mchl16fbf90a/mac
42. [14] anildash/dashtouch — https://github.com/anildash/dashtouch
43. [14] Discover Managed Device Attestation - WWDC22 - Videos - Apple Developer — https://developer.apple.com/videos/play/wwdc2022/10143/
44. [13] Apple Details Touch ID And The A7's Secure Enclave In Updated iOS Security Document | TechCrunch — https://techcrunch.com/2014/02/26/how-touch-id-and-secure-enclave-work/
45. [13] Can you add an external fingerprint reader to a MacBook that will work like the built-in reader? — https://apple.stackexchange.com/questions/350833/can-you-add-an-external-fingerprint-reader-to-a-macbook-that-will-work-like-the
46. [13] libfprint — Supported Devices — https://fprint.freedesktop.org/supported-devices
47. [13] Secure Enclave on Mac with CryptoKit: keys, Touch ID and limits | Swift Applications — https://swiftapplications.com/guides/secure-enclave-cryptokit-mac/
48. [13] Is using Touch ID with FileVault full disk encryption secure? — https://security.stackexchange.com/questions/147101/is-using-touch-id-with-filevault-full-disk-encryption-secure
49. [13] What external hardware allows a fingerprint to login/unlock a Mac? — https://apple.stackexchange.com/questions/134477/what-external-hardware-allows-a-fingerprint-to-login-unlock-a-mac
50. [13] Legal - Touch ID & Privacy- Apple — https://www.apple.com/legal/privacy/data/en/touch-id/
51. [12] CHANGELOG.md — https://github.com/hackintosh-user/VFS5011-hackintosh/blob/main/CHANGELOG.md
52. [12] Any way to fake touch id? : r/hackintosh — https://www.reddit.com/r/hackintosh/comments/1fth576/any_way_to_fake_touch_id/
53. [12] 3v1n0/libfprint-tod-vfs0090 — https://github.com/3v1n0/libfprint-tod-vfs0090
54. [11] On-Device Face & Touch ID Secure Enclave Architecture Diagram: FIDO Passkey Template Isolation — https://bytediagram.com/blog/on-device-face-touch-id-secure-enclave-fido-passkey-architecture-diagram.html
55. [11] iOS Security — https://www.apple.com/lae/privacy/docs/iOS_Security_Guide_Oct_2014.pdf
56. [10] Security Interface | Apple Developer Forums — https://developer.apple.com/forums/tags/securityinterface
57. [10] The Secure Enclave - Apple Support — https://support.apple.com/guide/security/the-secure-enclave-sec59b0b31ff/web
58. [10] Is it possible to emulate T2 chip? — https://github.com/acidanthera/bugtracker/issues/2004
59. [10] Standalone Touch ID Review: The Missing Link for Mac Mechanical Keyboard Users - MacSources — https://macsources.com/standalone-touch-id-review-the-missing-link-for-mac-mechanical-keyboard-users/
60. [10] Elliot Jordan - Managing login mechanisms in the macOS authorization database — https://www.elliotjordan.com/posts/macos-authdb-mechs/
61. [9] Image frame assembly: libfprint Reference Manual — https://fprint.freedesktop.org/libfprint-stable/libfprint-Image-frame-assembly.html
62. [9] 06cb:009a fingerprint reader on Linux: Synaptics "Prometheus" via python-validity — https://fprint.jedbillyb.com/devices/06cb-009a/
63. [9] MeisApps/pcbu-desktop — https://github.com/MeisApps/pcbu-desktop
64. [9] Replacing mac's login window — https://stackoverflow.com/questions/38666103/replacing-macs-login-window
65. [8] Why doesn't Apple make a standalone Touch ID? - Jeff Geerling — https://www.jeffgeerling.com/blog/2025/why-doesnt-apple-make-standalone-touch-id/
66. [8] Touch ID for Mac : r/macbook — https://www.reddit.com/r/macbook/comments/1s2wlv1/touch_id_for_mac/
67. [8] Multisketches — https://doi.org/10.1145/3319535.3363208
68. [8] immurok/app-macos — https://github.com/immurok/app-macos
69. [8] ZimengXiong/tinyTouch — https://github.com/zimengxiong/tinytouch
70. [8] Read%20Me%20About%20NullAuthPlugin.txt — https://github.com/OCForks/NullAuthPlugin/blob/master/Read%20Me%20About%20NullAuthPlugin.txt
71. [8] docs/README.md — https://github.com/macintog/t2-platform-research/blob/main/docs/README.md
72. [8] MacBookPro 15,1/2? — https://github.com/Dunedan/mbp-2016-linux/issues/71
73. [7] cfc56a2 [local_auth_darwin] Handle when FaceID hardware is available but permissions have been denied for the app (#8348 — https://github.com/flutter/packages/commit/cfc56a2103c469bc6fd3ddf12056147bb24dd1cd
74. [7] GitHub - jamf/authchanger: Utility for making changes to the macOS authorization database to easily allow for changing l — https://github.com/jamf/authchanger
75. [7] Able to see fingerprint sensor as usb device on hackintosh : r/hackintosh — https://www.reddit.com/r/hackintosh/comments/13phoqk/able_to_see_fingerprint_sensor_as_usb_device_on/
76. [7] macOS: Password Utility unlocks FileVault and makes sudo biometric-capable | heise online — https://www.heise.de/en/news/macOS-Password-Utility-unlocks-FileVault-and-makes-sudo-biometric-capable-11147367.html
77. [7] HMAKT99/UnTouchID — https://github.com/HMAKT99/UnTouchID
78. [7] Check this out: Fingerprint authentication on Hackintoshes? 👆 : r/hackintosh — https://www.reddit.com/r/hackintosh/comments/1xdeufs/check_this_out_fingerprint_authentication_on/
79. [7] Airportitlwm Working on sequoia! : r/hackintosh — https://www.reddit.com/r/hackintosh/comments/1liwy2n/airportitlwm_working_on_sequoia/
80. [7] How to customize the Mac OSX login? — https://stackoverflow.com/questions/45719864/how-to-customize-the-mac-osx-login
81. [6] system.login.screensaver - Overview of the macOS Authorization Right — https://www.dssw.co.uk/reference/authorization-rights/system-login-screensaver/
82. [6] One touch, three paths: how immurok authenticates on macOS — immurok Blog — https://immurok.com/blog/macos-authentication-modes/
83. [6] [138a:0097] Validity sensor driver request — https://bugs.launchpad.net/ubuntu/+source/libfprint/+bug/1743479
84. [6] Fingerprint reader on Linux: the fprintd / libfprint status matrix - Big Iron — https://www.bigiron.cc/guides/fingerprint-reader-on-linux-the-fprintd-libfprint-status-matrix
85. [6] Secure Enclave Processor (SEP) - Asahi Linux Documentation — https://asahilinux.org/docs/hw/soc/sep/
86. [6] Apple T2 Secure Enclave Processor — https://linux-hardware.org/?id=pci%3A106b-1802-106b-1802
87. [6] os_secure_enclave Protected Storage for Cryptographic Keys · BaselineWatch — https://baselinewatch.org/standards/nist-mscp/42/os_secure_enclave
88. [5] External Keyboard with Touch ID... How I can configure Touch ID? - Hardware - MPU Talk — https://talk.macpowerusers.com/t/external-keyboard-with-touch-id-how-i-can-configure-touch-id/26656
89. [5] Keyboard for Mac Mini With Touch ID: Only Apple's Can Pair — https://picklog.cc/blog/keyboard-for-mac-mini-with-touch-id
90. [5] Beyond the good ol' LaunchAgents - 28 - Authorization Plugins · theevilbit — https://theevilbit.github.io/beyond/beyond_0028/
91. [5] Persistent Credential Theft with Authorization Plugins — » Xor'd — https://www.xorrior.com/persistent-credential-theft/
92. [5] why hackintosh doesn't support Apple Pay : r/hackintosh — https://www.reddit.com/r/hackintosh/comments/1cn78cg/why_hackintosh_doesnt_support_apple_pay/
93. [5] New for PSSO in macOS Sequoia – Twocanoes Software — https://twocanoes.com/new-for-psso-in-macos-sequoia/
94. [5] Verification: A Case Study using Minutiae and Ridge-Based Matchers — https://biometrics.eps.uam.es/fierrez/files/2006_ICARCV_FingerInter_Alonso.pdf
95. [5] Journal of Medical Internet Research - Implementation of Fingerprint Technology for Unique Patient Matching and Identifi — https://www.jmir.org/2021/12/e28958
96. [5] immurok/immurok — https://github.com/immurok/immurok
97. [5] Touch bar fixed for macos sequoia after dual install macos ventura : r/OpenCoreLegacyPatcher — https://www.reddit.com/r/OpenCoreLegacyPatcher/comments/1kmavj3/touch_bar_fixed_for_macos_sequoia_after_dual/
98. [5] Touch ID not working for login Sequoia : r/k12sysadmin — https://www.reddit.com/r/k12sysadmin/comments/1pe8n22/touch_id_not_working_for_login_sequoia/
99. [5] kherrboldt/SAPlugin: macOS Authorization Plug-in written in 100% Swift. - Codeberg.org — https://codeberg.org/kherrboldt/SAPlugin
100. [4] Extending authorization services with plug-ins | Apple Developer Documentation — https://developer.apple.com/documentation/security/extending-authorization-services-with-plug-ins
101. [4] uunicorn/python-validity — https://github.com/uunicorn/python-validity
102. [4] Other/Disassembled%20ACPI/SSDT-XHC.dsl — https://github.com/EETagent/T480-OpenCore-Hackintosh/blob/master/Other/Disassembled%20ACPI/SSDT-XHC.dsl
103. [4] Security Server and Security Agent — https://developer.apple.com/library/archive/documentation/Security/Conceptual/Security_Overview/Architecture/Architecture.html
104. [4] docs/index.md — https://github.com/shoon/fv-ssh-unlock/blob/main/docs/index.md
105. [4] docs/use-cases.md — https://github.com/shoon/fv-ssh-unlock/blob/main/docs/use-cases.md
106. [4] jessfraz/ha-filevault — https://github.com/jessfraz/ha-filevault
107. [2] Technical Note TN2228: Running At Login — http://leopard-adc.pepas.com/technotes/tn2008/tn2228.html
108. [2] Sensor Operations | uunicorn/python-validity | DeepWiki — https://deepwiki.com/uunicorn/python-validity/7-sensor-operations
109. [2] corpnewt/USBMap — https://github.com/corpnewt/USBMap/
110. [2] Operational Measures and Accuracies of ROC Curve on Large Fingerprint Data Sets — https://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir7495.pdf
111. [2] AppleScript cannot access elements of SecurityAgent — https://stackoverflow.com/questions/52064226/applescript-cannot-access-elements-of-securityagent
112. [2] Got touchbar / fingerprint working again on macbook pro 2017 14,2 using OPLC 2.4.1 and Sequoia : r/OpenCoreLegacyPatcher — https://www.reddit.com/r/OpenCoreLegacyPatcher/comments/1odn75g/got_touchbar_fingerprint_working_again_on_macbook/
113. [2] Creating an OS X authentication plugin — https://stackoverflow.com/questions/21737444/creating-an-os-x-authentication-plugin/22050896
114. [2] tburgin/FV2AuthPlugin — https://github.com/tburgin/fv2authplugin/
115. [1] Unlock FileVault Automatically – Twocanoes Software — https://twocanoes.com/knowledge-base/unlock-filevault-automatically/
116. [0] wrangling macs: Writing loginwindow plugins — https://wranglingmacs.blogspot.com/2009/07/writing-loginwindow-plugins.html
117. [0] { javier.ortega} — https://biometrics.eps.uam.es/fierrez/files/2006_ICCST_HillClimbingAttackMoC_Martinez.pdf
118. [0] SecurityAgent on Mac: Admin Password Prompts Explained — https://trythrum.app/processes/securityagent/
