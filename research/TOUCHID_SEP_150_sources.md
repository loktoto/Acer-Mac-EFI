# Deep research round 2: EgisTec matching failure & on-chip alternative

Generated: 2026-11-25 00:24:22
- Tool: agent-reach web search (Exa), 10 additional focused queries
- Round-1 sources: 118; Round-2 new raw: 50; Combined unique sources: 150

## New finding: the 17-row failure is reproducible and fixable

A synthetic reproduction of the patched `libfprint-calibration.patch` estimator
(`overlap_score` + `estimate_direction` + `estimate_swipe`) showed the current
parameters (dy penalty 0.008, dx penalty 0.018, dy search 0..8) collapse every
swipe faster than ~2 rows/strip to a 17-row (one-strip) image: correlation is
near-flat over the searched offsets due to ridge periodicity, so the penalty
always selects dy=0. Tested over 81 synthetic swipes (9 speeds x 3 noise x 3 seeds):

- Current patch: 9/81 pass (only the slowest speed).

- Candidate fix (dy penalty 0, dx penalty 0.001, dy search 0..12, median-agregate
  per-strip deltas): 57/81 pass, with all realistic speeds 4-8 rows/strip at
  8-9/9. The fix and its test harness are staged in the handover under
  `estimator-fix/` as a **candidate**; it must be validated against a real
  captured swipe before replacing the production patch.

## On-chip matching question answered

Searches for EgisTec 0570 on-chip matching found no template storage / pairing
endpoint: it is a raw-image swipe sensor matched on the host (libfprint NBIS).
HTID on-chip backends (Synaptics Metallica MIS `06cb:009a`, Prometheus `138a:0097`)
store prints on the sensor and pair a trusted host identity -- but these are
different chips and are not in this machine. Cannot be substituted for 0570.

## Top sources (round 2)

### 1. [score 38] Security - HTID
- URL: https://hackintosh-user.github.io/hack-touchid/security.html
- Excerpt: ## Overview HTID intercepts macOS authentication prompts (login screen, System Settings padlock and Keychain prompts) and satisfies them with a fingerprint swipe from a supported USB sensor, matched against locally stored templates. Different sensors have real architectural differences. Some match on the host, others match on the chip and never expose raw image data, so read the per-backend notes below. Not audited. It touches sensitive parts of 

### 2. [score 33] hackintosh-user/hack-touchid
- URL: https://github.com/hackintosh-user/hack-touchid
- Excerpt: ## Overview This project ports the USB capture protocol for supported fingerprint sensors to a standalone macOS C code, and pairs it with NIST's NBIS fingerprint matching suite (`mindtct` for minutiae extraction, `bozorth3` for matching) to provide working fingerprint authentication on Hackintosh hardware that shipped with this sensor but has no native macOS driver support. It is not a kernel extension or a libfprint port. It runs as a small back

### 3. [score 31] Hackintosh Touch ID - HTID
- URL: https://hackintosh-user.github.io/hack-touchid/
- Excerpt: # Touch ID for Hackintosh Fingerprint authentication for macOS on unsupported hardware. Unlock with a real fingerprint sensor instead of typing your password. ## What is it? HTID is a fingerprint authentication daemon for macOS on Hackintosh hardware. It ports the USB capture protocol of supported fingerprint sensors to native C, matches swipes with NIST's NBIS suite, and types your password into the macOS prompt when your finger matches. It is n

### 4. [score 29] docs/STATUS.md
- URL: https://github.com/dssoftx/Hackintosh-X1Carbon-G11-IrisXe-Tahoe/blob/main/docs/STATUS.md
- Excerpt: - Repository: dssoftx/Hackintosh-X1Carbon-G11-IrisXe-Tahoe ... # Status (October 2026, macOS Tahoe 26.7.1 25G241) ... - **Fingerprint for sudo** (since 2026-10-22): the Goodix 27C6:63BC sensor works through libfprint's goodixmoc driver (match-on-chip, built for macOS with a small patch) and a PAM module in `/etc/pam.d/sudo_local` (`tools/fingerprint`). Login, screen unlock, Touch ID settings, Apple Pay and LocalAuthentication prompts are **not** 

### 5. [score 29] I built a Touch ID-style fingerprint unlock for a fingerprint sensor on a 2012 laptop (VFS5011) — open source, works on Sequoia + Tahoe : r/hackintosh
- URL: https://www.reddit.com/r/hackintosh/comments/1vmvic1/i_built_a_touch_idstyle_fingerprint_unlock_for_a/
- Excerpt: # I built a Touch ID-style fingerprint unlock for a fingerprint sensor on a 2012 laptop (VFS5011) — open source, works on Sequoia + Tahoe Posted by **u/Sufficient_Bus_8302** in r/hackintosh · 47 points · 11 comments · August 13, 2026 at 12:26 AM UTC Been running a heavily customized HP Pavilion DV6-7070ex (i7-3610QM, Ivy Bridge) as a daily-driver Hackintosh, and one thing that always wanted was **biometric unlock** on Hackintosh, obviously no T2/

### 6. [score 28] Guide - HTID
- URL: https://hackintosh-user.github.io/hack-touchid/guide.html
- Excerpt: ## Requirements - macOS 14 Sonoma or later (macOS 15 Sequoia or later recommended). Older versions get zero support. - OpenCore v1.0.6 or later. v1.0.5 and older are not supported. - Xcode Command Line Tools: `xcode-select --install` - Homebrew, then `brew install libusb openssl@3 innoextract` - Accessibility permission for the daemon. The deploy step handles this for you. - Your sensor must be enabled in your USBMap so it is powered. Check Syste

### 7. [score 27] Magic Keyboard with Touch ID - Apple Support
- URL: https://support.apple.com/guide/security/magic-keyboard-with-touch-id-secf60513daa/web
- Excerpt: # Magic Keyboard with Touch ID The Magic Keyboard with Touch ID (and the Magic Keyboard with Touch ID and Numeric Keypad) provides a Touch ID sensor in an external keyboard that can be used with any Mac with Apple silicon. The Magic Keyboard with Touch ID performs the role of the biometric sensor; it doesn’t store biometric templates, perform biometric matching, or enforce security policies (for example, having to enter the password after 48 hour

### 8. [score 25] docs/01-protocol.md
- URL: https://github.com/jerzy99jerzy/standalone-touchid/blob/main/docs/01-protocol.md
- Excerpt: Everything in this section is sourced from Apple's Platform Security guide. Where this document draws a conclusion Apple does not state directly, it is labeled as inference. ... Apple's biometric architecture rests on a strict division of labor between the sensor and the Secure Enclave, connected by a secured channel. The sensor captures the biometric image and transmits it. The Secure Enclave does everything else: during enrollment it processes,

### 9. [score 24] docs/INSTALL.md
- URL: https://github.com/JulioNectar/Hackintosh-XPS13Plus-IrisXe-Tahoe/blob/main/docs/INSTALL.md
- Excerpt: Target: Dell XPS 13 Plus 9320, i7-1360P, Iris Xe 8086:A7A0, **macOS Tahoe 26.7.1 ... ## Fingerprint for sudo (optional) The Goodix sensor in the power button (27C6:63BC, match-on-chip) works through libfprint's `goodixmoc` driver. Only `sudo` (and other PAM services you add it to) can use it: login, screen unlock, Touch ID settings and LocalAuthentication need the Secure Enclave and are **not** supported. The sensor stores the prints itself. ```s

### 10. [score 23] Biometric security - Apple Support
- URL: https://support.apple.com/guide/security/biometric-security-sec067eb0c9e/web
- Excerpt: Passcodes and passwords are essential to the security of Apple devices. At the same time, users require convenient access to their devices, often more than a hundred times a day. Biometric authentication provides a way to retain the security of a strong passcode—or even strengthen the passcode or password because it doesn’t need to be entered manually—while providing the convenience of swiftly unlocking with a finger press or glance. Optic ID, Fa

### 11. [score 23] indev29/egis0570
- URL: https://github.com/indev29/egis0570
- Excerpt: # indev29/egis0570 EgisTec fingerprint sensor driver - Stars: 47 - Forks: 11 - Watchers: 47 - Open issues: 0 - Default branch: master - Created: 2018-02-03T13:45:37Z - Status: ARCHIVED ## Top Contributors - indev29 (16 contributions) - saeedark (1 contributions) --- ## README # egis0570 This is the project aiming to provide Linux support for Egis Technology Inc. ID 1c7a:0570 fingerprint scanner (also known as LighTuning Technology Inc.) Driver is

### 12. [score 23] hwdb.d/60-autosuspend-fingerprint-reader.hwdb
- URL: https://github.com/systemd/systemd/blob/main/hwdb.d/60-autosuspend-fingerprint-reader.hwdb
- Excerpt: # hwdb.d/60-autosuspend-fingerprint-reader.hwdb - Branch: main - Repository: systemd/systemd --- # This file is part of systemd. # # Rules to autosuspend known fingerprint readers (pulled from libfprint). # # SPDX-License-Identifier: LGPL-2.1-or-later # This file has been generated using fprint-list-udev-hwdb with all drivers enabled ... # Supported by libfprint driver egis0570 usb:v1C7Ap0570* usb:v1C7Ap0571* ID_AUTOSUSPEND=1 ID_PERSIST=0 # Suppo

### 13. [score 23] jedbillyb/linux-fingerprint-drivers
- URL: https://github.com/jedbillyb/linux-fingerprint-drivers
- Excerpt: ## In progress (unmerged upstream MRs) Drivers that have been submitted to the **official libfprint project** but are **not merged yet**, so they are not in any released libfprint. Each has an entry under `devices/` with the merge-request link and build notes. Status changes to Working here once someone confirms it, and the row moves once the MR lands upstream. MR states were last verified against GitLab on **2026-11-17**; the merge request itsel

### 14. [score 23] Apple Platform Security
- URL: https://help.apple.com/pdf/security/en_US/apple-platform-security-guide.pdf
- Excerpt: Touch ID security Touch ID is the fingerprint sensing system that makes secure access to supported Apple devices faster and easier. This technology reads fingerprint data from any angle and learns more about a user’s fingerprint over time, with the sensor continuing to expand the fingerprint map as additional overlapping nodes are identified with each use. Apple devices with a Touch ID sensor can be unlocked using a fingerprint. Touch ID doesn’t 

### 15. [score 22] jerzy99jerzy/standalone-touchid
- URL: https://github.com/jerzy99jerzy/standalone-touchid
- Excerpt: Standalone Touch ID for Apple Silicon Macs: 3D-printed enclosure build guide ... > **A biometric authentication puck for Apple Silicon Macs, built by cannibalizing a Magic Keyboard with Touch ID (A2449) and rehousing its electronics in a 3D-printed enclosure. The interesting part is not the enclosure. It is the claim that rehousing changes nothing the Secure Enclave depends on, and this repository exists to justify that claim rather than assert i

### 16. [score 21] go-macos/localauthentication
- URL: https://github.com/go-macos/localauthentication
- Excerpt: Ask macOS to authenticate the person at the keyboard — **Touch ID**, or the login password — from pure Go with `CGO_ENABLED=0`. It binds `LAContext` through `go-macos/objc` (Objective-C message sends over `ebitengine/purego`), so it links with **no cgo** and shells out to nothing. ```go import "github.com/go-macos/localauthentication" // Is there a sensor, and of what kind? (No prompt.) kind, err := localauthentication.Biometry() // "Touch ID" / 

### 17. [score 21] 1c7a:0570 fingerprint reader on Linux: EgisTec EgisTec0570 - calibration fix
- URL: https://fprint.jedbillyb.com/devices/1c7a-0570/
- Excerpt: 1c7a:0570 fingerprint reader on Linux: EgisTec EgisTec0570 - calibration fix # EgisTec EgisTec0570 - calibration fix (USB 1c7a:0570, 1c7a:0571) Status: Claimed upstream by the `egis0570` driver, but unreliable. Fix MR open. The in-tree `egis0570` driver covers `1c7a:0570` and `1c7a:0571`, but calibration is not implemented properly, which shows up as erratic captures and unreliable verification (libfprint issue #418). ## What the fix does libfpri

### 18. [score 21] EgisTec 0570 Fingerprint Sensor - fprintd-enroll not working
- URL: https://unix.stackexchange.com/questions/664879/egistec-0570-fingerprint-sensor-fprintd-enroll-not-working
- Excerpt: # EgisTec 0570 Fingerprint Sensor - fprintd-enroll not working Tags: arch-linux, uefi, hardware, fingerprint - Score: 3 - Views: 1063 - Answers: 0 - Asked by: mipy (31 rep) - Asked: 2021-08-16 - Edited: 2025-03-01 - Site: unix ## Question I have an Acer Swift 3 (SF314-57) running arch, which has an 0570 LighTuning Technology Inc. EgisTec Touch Fingerprint Sensor. Support for this device was just made available in the latest libfprint release (v1.

### 19. [score 21] libfprint — Supported Devices
- URL: https://fprint.freedesktop.org/supported-devices
- Excerpt: libfprint — Supported Devices # Supported Devices This is a list of supported devices in libfprint’s development version. Those drivers might not all be available in the stable, released version. If in doubt, contact your distribution or systems integrator for details. ## USB devices | USB ID | Driver | | --- | --- | ... | 1c7a:0570 | Egis Technology Inc. (aka. LighTuning) 0570 | | 1c7a:0571 | Egis Technology Inc. (aka. LighTuning) 0570 | | 1c7a:

### 20. [score 21] 
- URL: https://lists.freedesktop.org/archives/fprint/attachments/20180211/f6be3cfe/attachment.html
- Excerpt: Hi, 1. You need to find out the correct format of returned data. By correct I mean the one that allows to decode an image of a fingerprint. This is necessary for the matching algorithm to work. The .pgm files in your repo don't look like fingerprints, right? They look like noise because the dimensions are incorrect. 2. Raw data is not fine. I've tried a few variant and it looks like your device returns 8bit 114x57 images. And it returns 5 of them

## All 150 sources
1. [38] Security - HTID — https://hackintosh-user.github.io/hack-touchid/security.html
2. [33] hackintosh-user/hack-touchid — https://github.com/hackintosh-user/hack-touchid
3. [31] Hackintosh Touch ID - HTID — https://hackintosh-user.github.io/hack-touchid/
4. [29] docs/STATUS.md — https://github.com/dssoftx/Hackintosh-X1Carbon-G11-IrisXe-Tahoe/blob/main/docs/STATUS.md
5. [29] I built a Touch ID-style fingerprint unlock for a fingerprint sensor on a 2012 laptop (VFS5011) — open source, — https://www.reddit.com/r/hackintosh/comments/1vmvic1/i_built_a_touch_idstyle_fingerprint_unlock_for_a/
6. [28] Guide - HTID — https://hackintosh-user.github.io/hack-touchid/guide.html
7. [27] Magic Keyboard with Touch ID - Apple Support — https://support.apple.com/guide/security/magic-keyboard-with-touch-id-secf60513daa/web
8. [25] docs/01-protocol.md — https://github.com/jerzy99jerzy/standalone-touchid/blob/main/docs/01-protocol.md
9. [24] docs/INSTALL.md — https://github.com/JulioNectar/Hackintosh-XPS13Plus-IrisXe-Tahoe/blob/main/docs/INSTALL.md
10. [23] Biometric security - Apple Support — https://support.apple.com/guide/security/biometric-security-sec067eb0c9e/web
11. [23] indev29/egis0570 — https://github.com/indev29/egis0570
12. [23] hwdb.d/60-autosuspend-fingerprint-reader.hwdb — https://github.com/systemd/systemd/blob/main/hwdb.d/60-autosuspend-fingerprint-reader.hwdb
13. [23] jedbillyb/linux-fingerprint-drivers — https://github.com/jedbillyb/linux-fingerprint-drivers
14. [23] Apple Platform Security — https://help.apple.com/pdf/security/en_US/apple-platform-security-guide.pdf
15. [22] jerzy99jerzy/standalone-touchid — https://github.com/jerzy99jerzy/standalone-touchid
16. [21] go-macos/localauthentication — https://github.com/go-macos/localauthentication
17. [21] 1c7a:0570 fingerprint reader on Linux: EgisTec EgisTec0570 - calibration fix — https://fprint.jedbillyb.com/devices/1c7a-0570/
18. [21] EgisTec 0570 Fingerprint Sensor - fprintd-enroll not working — https://unix.stackexchange.com/questions/664879/egistec-0570-fingerprint-sensor-fprintd-enroll-not-working
19. [21] libfprint — Supported Devices — https://fprint.freedesktop.org/supported-devices
20. [21]  — https://lists.freedesktop.org/archives/fprint/attachments/20180211/f6be3cfe/attachment.html
21. [21] Re: [fprint] Verification help request (Egis Technology 1c7a:0570) — https://www.mail-archive.com/fprint@lists.freedesktop.org/msg00962.html
22. [20] Issues · hackintosh-user/hack-touchid · GitHub — https://github.com/hackintosh-user/hack-touchid/issues
23. [20] drphilth/honor-fmbp-libfprint-sdcp — https://github.com/drphilth/honor-fmbp-libfprint-sdcp
24. [20] README.md — https://github.com/hackintosh-user/VFS5011-hackintosh/blob/main/README.md
25. [20] Secure intent and connections to the Secure Enclave - Apple Support — https://support.apple.com/guide/security/secure-intent-connections-enclave-sec7a94f7d1e/web
26. [20] PHILIPPDEV5396/libfprint-egis0576 — https://github.com/PHILIPPDEV5396/libfprint-egis0576
27. [19] libfprint/fpi-assembling.c — https://github.com/TheWeirdDev/libfprint/blob/55b4-experimental/libfprint/fpi-assembling.c
28. [18] Apple updates Platform Security guide with details on iPhone Apple Watch unlock, Touch ID Magic Keyboard - 9to — https://9to5mac.com/2021/05/17/apple-updates-platform-security-guide/
29. [18] Linux fingerprint reader drivers: sensors libfprint does not support — https://fprint.jedbillyb.com/
30. [18] Demystifying Apple’s Touch ID — https://hackernoon.com/demystifying-apples-touch-id-4883d5121b77
31. [18] GitHub - saeedark/newEgis0570: updating the old driver · GitHub — https://github.com/saeedark/newEgis0570
32. [17] kotakbiasa/ThinkPad-X380-Yoga-Hackintosh — https://github.com/kotakbiasa/ThinkPad-X380-Yoga-Hackintosh
33. [16] Local Authentication — https://developer.apple.com/documentation/localauthentication.md
34. [16] github.com/go-macos/localauthentication — https://pkg.go.dev/github.com/go-macos/localauthentication
35. [16] About Touch ID advanced security technology - Apple Support — https://support.apple.com/en-us/105095
36. [16] Has anyone unlocked hackintosh with touchID from magic keyboard? : r/hackintosh — https://www.reddit.com/r/hackintosh/comments/1rrlwqe/has_anyone_unlocked_hackintosh_with_touchid_from/
37. [15] Turning an Apple Wireless Keyboard Into a Dedicated Touch ID Box — https://jimjordan.design/posts/turning-an-apple-wireless-keyboard-into-a-dedicated-touch-id-box
38. [15] Logging a User into Your App with Face ID or Touch ID — https://developer.apple.com/documentation/localauthentication/logging-a-user-into-your-app-with-face-id-or-touch-id.md
39. [15] Protecting keys with the Secure Enclave — https://developer.apple.com/documentation/security/protecting-keys-with-the-secure-enclave.md
40. [15] 06cb:009a fingerprint reader on Linux: Synaptics "Prometheus" via python-validity — https://fprint.jedbillyb.com/devices/06cb-009a/
41. [15] tmullender/egis-eh570 — https://github.com/tmullender/egis-eh570
42. [15] libfprint/fpi-assembling.h — https://github.com/TheWeirdDev/libfprint/blob/55b4-experimental/libfprint/fpi-assembling.h
43. [15] a07011b tests: Add test for egistec0570 — https://github.com/TheWeirdDev/libfprint/commit/a07011bac2be9810894d53dc0741dbf2fd6d6c86
44. [14] On-Device Face & Touch ID Secure Enclave Architecture Diagram: FIDO Passkey Template Isolation — https://bytediagram.com/blog/on-device-face-touch-id-secure-enclave-fido-passkey-architecture-diagram.html
45. [14] docs/02-alternatives.md — https://github.com/jerzy99jerzy/standalone-touchid/blob/main/docs/02-alternatives.md
46. [14] CHANGELOG.md — https://github.com/hackintosh-user/VFS5011-hackintosh/blob/main/CHANGELOG.md
47. [14] Discover Managed Device Attestation - WWDC22 - Videos - Apple Developer — https://developer.apple.com/videos/play/wwdc2022/10143/
48. [13] Help grow this! - HTID — https://hackintosh-user.github.io/hack-touchid/contribute.html
49. [13] Locked use overwrites the Platform SSO screensaver rule and prevents password unlock — https://github.com/openai/codex/issues/47470
50. [13] EgisTec 0570 Fingerprint Sensor - fprintd-enroll not working / Kernel & Hardware / Arch Linux Forums — https://bbs.archlinux.org/viewtopic.php?id=268637
51. [13] Re: [fprint] Verification help request (Egis Technology 1c7a:0570) — https://www.mail-archive.com/fprint@lists.freedesktop.org/msg00963.html
52. [13] Image Processing Pipeline | 3v1n0/libfprint | DeepWiki — https://deepwiki.com/3v1n0/libfprint/2.6-image-processing-pipeline
53. [13] Broken Fingers: A Deep Dive into Open Source Fingerprint Authentication and its Security Issues — https://static.sched.com/hosted_files/ossna19/4a/BrokenFingers_OSSNA2019.pdf
54. [13] Re: [fprint] Writing driver for Egistec reader (1c7a:0801) — http://www.mail-archive.com/fprint@reactivated.net/msg01684.html
55. [12] Apple Details Touch ID And The A7's Secure Enclave In Updated iOS Security Document | TechCrunch — https://techcrunch.com/2014/02/26/how-touch-id-and-secure-enclave-work/
56. [12] Image frame assembly: libfprint Reference Manual — https://fprint.freedesktop.org/libfprint-stable/libfprint-Image-frame-assembly.html
57. [12] Secure Enclave on Mac with CryptoKit: keys, Touch ID and limits | Swift Applications — https://swiftapplications.com/guides/secure-enclave-cryptokit-mac/
58. [12] Is using Touch ID with FileVault full disk encryption secure? — https://security.stackexchange.com/questions/147101/is-using-touch-id-with-filevault-full-disk-encryption-secure
59. [12] anildash/dashtouch — https://github.com/anildash/dashtouch
60. [12] Legal - Touch ID & Privacy- Apple — https://www.apple.com/legal/privacy/data/en/touch-id/
61. [12] 3v1n0/libfprint-tod-vfs0090 — https://github.com/3v1n0/libfprint-tod-vfs0090
62. [12] Ajaneeshwar/x571gt-fingerprint — https://github.com/Ajaneeshwar/x571gt-fingerprint
63. [11] Any way to fake touch id? : r/hackintosh — https://www.reddit.com/r/hackintosh/comments/1fth576/any_way_to_fake_touch_id/
64. [11] iOS Security — https://www.apple.com/lae/privacy/docs/iOS_Security_Guide_Oct_2014.pdf
65. [11] Fingerprint reader on Linux: the fprintd / libfprint status matrix - Big Iron — https://www.bigiron.cc/guides/fingerprint-reader-on-linux-the-fprintd-libfprint-status-matrix
66. [10] The Secure Enclave - Apple Support — https://support.apple.com/guide/security/the-secure-enclave-sec59b0b31ff/web
67. [10] Use Touch ID on Mac - Apple Support — https://support.apple.com/guide/mac-help/use-touch-id-mchl16fbf90a/mac
68. [10] MeisApps/pcbu-desktop — https://github.com/MeisApps/pcbu-desktop
69. [10] usnistgov/nbisminexiii — https://github.com/usnistgov/nbisminexiii
70. [10] wdes/Synaptics-Metallica-MIS-rs — https://github.com/wdes/Synaptics-Metallica-MIS-rs
71. [10] libfprint/fpi-image.c — https://github.com/TheWeirdDev/libfprint/blob/55b4-experimental/libfprint/fpi-image.c
72. [10] Driver Image operations: libfprint Reference Manual — https://fprint.freedesktop.org/libfprint-stable/libfprint-Driver-Image-operations.html
73. [9] Devices operations: libfprint Reference Manual — https://fprint.freedesktop.org/libfprint-stable/libfprint-Devices-operations.html
74. [9] Internal FpImage: libfprint Reference Manual — https://fprint.freedesktop.org/libfprint-dev/libfprint-2-Internal-FpImage.html
75. [8] Multisketches — https://doi.org/10.1145/3319535.3363208
76. [8] docs/README.md — https://github.com/macintog/t2-platform-research/blob/main/docs/README.md
77. [8] MacBookPro 15,1/2? — https://github.com/Dunedan/mbp-2016-linux/issues/71
78. [8] A Study on Accuracy and Problems in using ISO/IEC 19794-2 Finger Minutiae Formats for Automated Fingerprint Ve — https://www.nist.gov/system/files/documents/2022/02/17/yoshida2_takahiro_paper.pdf
79. [8] User's guide to NIST biometric image software (NBIS) — https://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir7392.pdf
80. [7] cfc56a2 [local_auth_darwin] Handle when FaceID hardware is available but permissions have been denied for the  — https://github.com/flutter/packages/commit/cfc56a2103c469bc6fd3ddf12056147bb24dd1cd
81. [7] Is it possible to emulate T2 chip? — https://github.com/acidanthera/bugtracker/issues/2004
82. [7] HMAKT99/UnTouchID — https://github.com/HMAKT99/UnTouchID
83. [7] immurok/app-macos — https://github.com/immurok/app-macos
84. [7] ZimengXiong/tinyTouch — https://github.com/zimengxiong/tinytouch
85. [6] Can you add an external fingerprint reader to a MacBook that will work like the built-in reader? — https://apple.stackexchange.com/questions/350833/can-you-add-an-external-fingerprint-reader-to-a-macbook-that-will-work-like-the
86. [6] Standalone Touch ID Review: The Missing Link for Mac Mechanical Keyboard Users - MacSources — https://macsources.com/standalone-touch-id-review-the-missing-link-for-mac-mechanical-keyboard-users/
87. [6] Able to see fingerprint sensor as usb device on hackintosh : r/hackintosh — https://www.reddit.com/r/hackintosh/comments/13phoqk/able_to_see_fingerprint_sensor_as_usb_device_on/
88. [6] macOS: Password Utility unlocks FileVault and makes sudo biometric-capable | heise online — https://www.heise.de/en/news/macOS-Password-Utility-unlocks-FileVault-and-makes-sudo-biometric-capable-11147367.html
89. [6] What external hardware allows a fingerprint to login/unlock a Mac? — https://apple.stackexchange.com/questions/134477/what-external-hardware-allows-a-fingerprint-to-login-unlock-a-mac
90. [6] Check this out: Fingerprint authentication on Hackintoshes? 👆 : r/hackintosh — https://www.reddit.com/r/hackintosh/comments/1xdeufs/check_this_out_fingerprint_authentication_on/
91. [6] Airportitlwm Working on sequoia! : r/hackintosh — https://www.reddit.com/r/hackintosh/comments/1liwy2n/airportitlwm_working_on_sequoia/
92. [6] [138a:0097] Validity sensor driver request — https://bugs.launchpad.net/ubuntu/+source/libfprint/+bug/1743479
93. [6] Secure Enclave Processor (SEP) - Asahi Linux Documentation — https://asahilinux.org/docs/hw/soc/sep/
94. [6] Apple T2 Secure Enclave Processor — https://linux-hardware.org/?id=pci%3A106b-1802-106b-1802
95. [6] os_secure_enclave Protected Storage for Cryptographic Keys · BaselineWatch — https://baselinewatch.org/standards/nist-mscp/42/os_secure_enclave
96. [6] eFSA80SC support — https://github.com/mincrmatt12/libfprint/issues/1
97. [5] External Keyboard with Touch ID... How I can configure Touch ID? - Hardware - MPU Talk — https://talk.macpowerusers.com/t/external-keyboard-with-touch-id-how-i-can-configure-touch-id/26656
98. [5] Keyboard for Mac Mini With Touch ID: Only Apple's Can Pair — https://picklog.cc/blog/keyboard-for-mac-mini-with-touch-id
99. [5] why hackintosh doesn't support Apple Pay : r/hackintosh — https://www.reddit.com/r/hackintosh/comments/1cn78cg/why_hackintosh_doesnt_support_apple_pay/
100. [5] One touch, three paths: how immurok authenticates on macOS — immurok Blog — https://immurok.com/blog/macos-authentication-modes/
101. [5] Why doesn't Apple make a standalone Touch ID? - Jeff Geerling — https://www.jeffgeerling.com/blog/2025/why-doesnt-apple-make-standalone-touch-id/
102. [5] New for PSSO in macOS Sequoia – Twocanoes Software — https://twocanoes.com/new-for-psso-in-macos-sequoia/
103. [5] Touch ID for Mac : r/macbook — https://www.reddit.com/r/macbook/comments/1s2wlv1/touch_id_for_mac/
104. [5] Verification: A Case Study using Minutiae and Ridge-Based Matchers — https://biometrics.eps.uam.es/fierrez/files/2006_ICARCV_FingerInter_Alonso.pdf
105. [5] Journal of Medical Internet Research - Implementation of Fingerprint Technology for Unique Patient Matching an — https://www.jmir.org/2021/12/e28958
106. [5] Touch bar fixed for macos sequoia after dual install macos ventura : r/OpenCoreLegacyPatcher — https://www.reddit.com/r/OpenCoreLegacyPatcher/comments/1kmavj3/touch_bar_fixed_for_macos_sequoia_after_dual/
107. [5] Touch ID not working for login Sequoia : r/k12sysadmin — https://www.reddit.com/r/k12sysadmin/comments/1pe8n22/touch_id_not_working_for_login_sequoia/
108. [5] A sweeping fingerprint verification system using the template matching method — http://wseas.us/e-library/transactions/computers/2010/89-570.pdf
109. [5] Fingerprint image reconstruction based on motion estimate across a narrow fringerprint sensor - Sony Corporati — https://www.freepatentsonline.com/y2011/0038513.html
110. [5] Fingerprint Matching using Small Sensors — http://lup.lub.lu.se/student-papers/record/8918315
111. [5] accuracy).T — http://biometrics.cse.msu.edu/Publications/Fingerprint/JainFpMatching_IEEEComp10.pdf
112. [5] Comparison of fingerprint authentication algorithms for small imaging sensors — https://arxiv.org/abs/1712.06882
113. [5] Minutiae-based template synthesis and matching for fingerprint authentication — https://www.cse.unr.edu/~bebis/TamerCVIU09.pdf
114. [5] Fingerprint matching using minutiae and texture features — https://doi.org/10.1109/icip.2001.958106
115. [4] Extending authorization services with plug-ins | Apple Developer Documentation — https://developer.apple.com/documentation/security/extending-authorization-services-with-plug-ins
116. [4] Security Interface | Apple Developer Forums — https://developer.apple.com/forums/tags/securityinterface
117. [4] Security Server and Security Agent — https://developer.apple.com/library/archive/documentation/Security/Conceptual/Security_Overview/Architecture/Architecture.html
118. [3] uunicorn/python-validity — https://github.com/uunicorn/python-validity
119. [3] Other/Disassembled%20ACPI/SSDT-XHC.dsl — https://github.com/EETagent/T480-OpenCore-Hackintosh/blob/master/Other/Disassembled%20ACPI/SSDT-XHC.dsl
120. [3] immurok/immurok — https://github.com/immurok/immurok
121. [3] docs/index.md — https://github.com/shoon/fv-ssh-unlock/blob/main/docs/index.md
122. [3] docs/use-cases.md — https://github.com/shoon/fv-ssh-unlock/blob/main/docs/use-cases.md
123. [3] jessfraz/ha-filevault — https://github.com/jessfraz/ha-filevault
124. [3] Support for 06cb:00a2 Synaptics, Inc. Metallica MOH Touch Fingerprint Reader — https://github.com/uunicorn/python-validity/issues/170
125. [2] Locked Use authorization plugin leaves the login keychain permanently locked for the rest of the session — https://github.com/openai/codex/issues/40226
126. [2] GitHub - jamf/authchanger: Utility for making changes to the macOS authorization database to easily allow for  — https://github.com/jamf/authchanger
127. [2] corpnewt/USBMap — https://github.com/corpnewt/USBMap/
128. [2] Read%20Me%20About%20NullAuthPlugin.txt — https://github.com/OCForks/NullAuthPlugin/blob/master/Read%20Me%20About%20NullAuthPlugin.txt
129. [2] tburgin/FV2AuthPlugin — https://github.com/tburgin/fv2authplugin/
130. [1] Technical Note TN2228: Running At Login — http://leopard-adc.pepas.com/technotes/tn2008/tn2228.html
131. [1] Sensor Operations | uunicorn/python-validity | DeepWiki — https://deepwiki.com/uunicorn/python-validity/7-sensor-operations
132. [1] Operational Measures and Accuracies of ROC Curve on Large Fingerprint Data Sets — https://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir7495.pdf
133. [1] Got touchbar / fingerprint working again on macbook pro 2017 14,2 using OPLC 2.4.1 and Sequoia : r/OpenCoreLeg — https://www.reddit.com/r/OpenCoreLegacyPatcher/comments/1odn75g/got_touchbar_fingerprint_working_again_on_macbook/
134. [1] Replacing mac's login window — https://stackoverflow.com/questions/38666103/replacing-macs-login-window
135. [1] Fingerprint sensor and sensing method thereof (US Patent 10210372) — https://exa.ai/library/legal/patent/yjy6w5fxv2z
136. [1] Swiped aperture capacitive fingerprint sensing systems and methods - Validity, Inc. — https://www.freepatentsonline.com/y2003/0035570.html
137. [1] System for fingerprint image reconstruction based on motion estimate across a narrow fingerprint sensor - Sony — https://www.freepatentsonline.com/y2005/0238212.html
138. [1] A Swipe-Type Fingerprint Sensor Using Fixed-Displacement Shuttering Scheme — https://doi.org/10.1109/jsen.2020.3012038
139. [0] wrangling macs: Writing loginwindow plugins — https://wranglingmacs.blogspot.com/2009/07/writing-loginwindow-plugins.html
140. [0] Beyond the good ol' LaunchAgents - 28 - Authorization Plugins · theevilbit — https://theevilbit.github.io/beyond/beyond_0028/
141. [0] Persistent Credential Theft with Authorization Plugins — » Xor'd — https://www.xorrior.com/persistent-credential-theft/
142. [0] system.login.screensaver - Overview of the macOS Authorization Right — https://www.dssw.co.uk/reference/authorization-rights/system-login-screensaver/
143. [0] { javier.ortega} — https://biometrics.eps.uam.es/fierrez/files/2006_ICCST_HillClimbingAttackMoC_Martinez.pdf
144. [0] Elliot Jordan - Managing login mechanisms in the macOS authorization database — https://www.elliotjordan.com/posts/macos-authdb-mechs/
145. [0] AppleScript cannot access elements of SecurityAgent — https://stackoverflow.com/questions/52064226/applescript-cannot-access-elements-of-securityagent
146. [0] SecurityAgent on Mac: Admin Password Prompts Explained — https://trythrum.app/processes/securityagent/
147. [0] kherrboldt/SAPlugin: macOS Authorization Plug-in written in 100% Swift. - Codeberg.org — https://codeberg.org/kherrboldt/SAPlugin
148. [0] How to customize the Mac OSX login? — https://stackoverflow.com/questions/45719864/how-to-customize-the-mac-osx-login
149. [0] Creating an OS X authentication plugin — https://stackoverflow.com/questions/21737444/creating-an-os-x-authentication-plugin/22050896
150. [0] Unlock FileVault Automatically – Twocanoes Software — https://twocanoes.com/knowledge-base/unlock-filevault-automatically/