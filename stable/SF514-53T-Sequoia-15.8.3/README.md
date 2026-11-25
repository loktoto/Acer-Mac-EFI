# Acer Swift 5 SF514-53T stable EFI profile

This daily OpenCore 1.0.9 profile is for the Acer Swift 5 SF514-53T with the i7-8565U, UHD 620 and Intel Wireless-AC 9560 (`8086:9DF0`, subsystem `8086:0034`). It was tested on macOS Sequoia 15.8.3 (`24H241`, Darwin `24.6.0`). The AirportItlwm entry is pinned to this Darwin version.

## Hardware verification

- Internal OpenCore booted, and the 27 enabled kext executables in the backup matched the running kernel's UUIDs.
- Native Wi-Fi passed an HTTPS connectivity check and AirPods connected over Bluetooth. The owner completed AirDrop file transfers in both directions with an iPhone.
- The built-in speakers played audio. The Acer TGLDmic driver reported `OK FW_READY` and captured 144,000 audio frames with a nonzero signal over three seconds. The tested macOS installation also has the TGLDmic 0.5.0 Core Audio plug-in.
- The Raydium touch driver and Metal acceleration were active. Bluetooth recovered from one `bluetoothd` relaunch during the verification window. The earlier display-off watchdog issue still needs longer observation.

## Restore the profile

1. Copy your existing SF514-53T OpenCore 1.0.9 EFI to a local backup. The published profile contains a configuration template and a checksum manifest. The EFI binaries come from your matching base EFI and the linked driver archives.
2. Take `MLB`, `ROM`, `SystemSerialNumber` and `SystemUUID` from your own working configuration and add them to `PlatformInfo > Generic` in the template before use. Keep the populated configuration private.
3. Use the AC 9560-only dwell `AirportItlwm.kext`, the matching BlueToolFixup 2.7.4 build, and the Acer TGLDmic 0.5.0 build. Install the BlueToolFixup bundle under `EFI/OC/Kexts/BlueToolFixup.kext`, as named in this profile. [AirDrop driver archives](../../experiments/2026-11-20/intel9560-airdrop/README.md) · [Acer TGLDmic archive](../../experiments/2026-11-20/intel-sst-mic/Swift5-TGLDmic-0.5.0-test.zip)
4. From the directory containing `EFI`, verify the boot files with `shasum -a 256 -c /path/to/SHA256SUMS`. Validate the populated `EFI/OC/config.plist` with `ocvalidate` from OpenCore 1.0.9 before installing. Keep the original EFI available for recovery.

The profile uses AppleALC 1.9.8 layout 71, IntelBluetoothFirmware and IntelBTPatcher 2.5.0, and the existing USB and Raydium touchscreen settings. It contains no 80% charge-limit ACPI tables or kext.
