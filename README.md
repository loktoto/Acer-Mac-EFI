# Acer Swift 5 SF514-53T OpenCore EFI

Stable OpenCore configuration for the Acer Swift 5 SF514-53T running macOS Sequoia 15.8.3. Start with the guide if you have an existing EFI for this machine. The public download includes a configuration template and boot-file checksums. [Install, verify and roll back](stable/SF514-53T-Sequoia-15.8.3/README.md)

| Tested component | Version |
| --- | --- |
| Laptop | Acer Swift 5 SF514-53T, Core i7-8565U, Intel UHD 620 |
| Wireless card | Intel Wireless-AC 9560 (`8086:9DF0`, subsystem `8086:0034`) |
| macOS | Sequoia 15.8.3 (`24H241`, Darwin `24.6.0`) |
| Bootloader | OpenCore 1.0.9 DEBUG (`ebea824`) |

The internal boot, native Wi-Fi, AirPods, two-way AirDrop, speakers and internal microphone passed hardware checks. The Raydium touchscreen driver and Metal acceleration were active. See the guide for the Bluetooth recovery and display-off watchdog observations. [Hardware verification](stable/SF514-53T-Sequoia-15.8.3/README.md#hardware-verification)

## Project files

- [Stable v1 tag](https://github.com/loktoto/Acer-Mac-EFI/tree/sf514-53t-sequoia-15.8.3-efi-v1/stable/SF514-53T-Sequoia-15.8.3) records the tested `config.plist` and checksums.
- [Driver builds and USB experiments](experiments/2026-11-20/README.md) cover the Acer microphone fix and Intel 9560 AirDrop development.
- [Diagnostics and research](research/SF514-53T-diagnostics-and-plan.md) preserve the boot menu investigation, internal microphone notes and original test plan.
- [EFI validator](scripts/validate-efi.py) checks the public template, boot-file manifest and pinned archives.
