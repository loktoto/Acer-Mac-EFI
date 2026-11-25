# Stable EFI · Acer Swift 5 SF514-53T

Use this profile with an existing EFI for the SF514-53T, Core i7-8565U, UHD 620 and Intel Wireless-AC 9560 (`8086:9DF0`, subsystem `8086:0034`). The tested macOS build is Sequoia 15.8.3 (`24H241`, Darwin `24.6.0`). The Wi-Fi driver is pinned to that Darwin version. [Stable v1 tag](https://github.com/loktoto/Acer-Mac-EFI/tree/sf514-53t-sequoia-15.8.3-efi-v1)

## Files and dependencies

| File or dependency | Where to get it |
| --- | --- |
| `config.plist` | [Public template](config.plist) |
| `SHA256SUMS` | [Boot-file manifest](SHA256SUMS), relative to the directory containing `EFI` |
| Matching EFI | Your working SF514-53T EFI backup. It supplies the machine-specific ACPI tables, USB settings and other files listed in the manifest. |
| OpenCore and `ocvalidate` | OpenCore 1.0.9 DEBUG at `ebea824`. [Dortania build](https://github.com/dortania/build-repo/releases/tag/OpenCorePkg-ebea824) |
| `AirportItlwm.kext` | `2.4.0`, AC 9560-only dwell build. [ZIP](../../experiments/2026-11-20/intel9560-airdrop/Intel9560-AirDrop-Sequoia-dwell-ac9560.zip) |
| `BlueToolFixup.kext` | `2.7.4` AirDrop build. Rename the extracted `BlueToolFixup-AirDrop.kext` bundle to `BlueToolFixup.kext`. [ZIP](../../experiments/2026-11-20/intel9560-airdrop/BlueToolFixup-AirDrop-2.7.4.zip) |
| `TGLDmic.kext` | Acer build of `0.5.0`. The tested system also uses the TGLDmic `0.5.0` Core Audio plug-in for the built-in input. [Kext ZIP](../../experiments/2026-11-20/intel-sst-mic/Swift5-TGLDmic-0.5.0-test.zip) · [Core Audio package](https://github.com/labrouss/TGLDmic/releases/tag/v0.5.0) |

The profile uses AppleALC `1.9.8` with layout `71`, IntelBluetoothFirmware and IntelBTPatcher `2.5.0`, and the existing Raydium touchscreen configuration. The 80% charge-limit experiment is outside this profile.

## Install

1. Back up the existing EFI to a private folder and make sure you can access the EFI partition from a known-good boot environment. Work on a copy of the backup.
2. Copy the template into the working copy as `EFI/OC/config.plist`. In `PlatformInfo > Generic`, restore `MLB`, `ROM`, `SystemSerialNumber` and `SystemUUID` from your own working configuration. Keep the populated plist private.
3. Place the three driver bundles from the table in `EFI/OC/Kexts`. From the directory containing `EFI`, run the checks below. Resolve any missing files or checksum differences before installing. The manifest covers boot files and leaves the populated `config.plist` to `ocvalidate`.

   ```sh
   shasum -a 256 -c /path/to/SHA256SUMS
   /path/to/ocvalidate EFI/OC/config.plist
   ```

4. Replace `EFI/BOOT` and `EFI/OC` on the target EFI partition with the validated copies. Preserve adjacent folders such as `EFI/Microsoft`. Restart into macOS from OpenCore and run the hardware checks below.

## Verify after boot

- Connect through the native Wi-Fi menu and open an HTTPS page.
- Connect a Bluetooth audio device and play audio. Send a small AirDrop file to a nearby Apple device and receive one back. Open both received files.
- Select the built-in speakers and play audio. Select the built-in microphone and check the input meter or make a short recording.
- Test touch input and check the display after it turns off and comes back on.

## Roll back

Boot from your known-good environment. Restore `EFI/BOOT` and `EFI/OC` from your private backup and preserve the adjacent EFI folders. Restart with the previous OpenCore entry.

## Hardware verification

| Area | Observed on the test Acer |
| --- | --- |
| Boot | Internal OpenCore booted. All 27 enabled kext executables in the backup matched the running kernel's UUIDs. |
| Wi-Fi and AirDrop | Native Wi-Fi passed an HTTPS check. The owner completed iPhone transfers in both directions. |
| Bluetooth | AirPods connected. `bluetoothd` relaunched once during verification and was running at the final check. |
| Audio | Built-in speakers played audio. TGLDmic reported `OK FW_READY` and captured 144,000 frames with a nonzero signal over three seconds. |
| Display and touch | Metal acceleration and the Raydium driver were active. The earlier display-off watchdog issue still needs longer observation. |
