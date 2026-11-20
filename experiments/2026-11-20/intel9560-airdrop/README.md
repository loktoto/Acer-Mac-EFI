# Intel AC 9560 native Wi-Fi and AirDrop on Sequoia

The USB test machine is the Acer Swift 5 SF514-53T, running macOS Sequoia 15.8.3 (`24H241`, Darwin `24.6.0`). Its Intel AC 9560 has PCI ID `8086:9DF0` and subsystem `8086:0034`. Finder AirDrop worked in both directions with an iPhone, and the owner reported faster transfers after the transmit queue change. The tests used the existing router configuration. Performance and compatibility across other networks have yet to be measured.

| Build | Status | Downloads |
| --- | --- | --- |
| Queue | Booted on the Acer with native Wi-Fi. The larger AWDL transmit queue and retry handling reduced queue drops in the observed test. Use this build to reproduce the verified setup. | [Kext](Intel9560-AirDrop-Sequoia-queue.zip) · [Source patch](acer-ac9560-awdl-queue.patch) |
| Dwell | Experimental follow-up. Sends eligible pending unicast frames during an already scheduled shared radio window. Build, signature and OpenCore validation passed before boot testing. | [Kext](Intel9560-AirDrop-Sequoia-dwell.zip) · [Source patch](acer-ac9560-awdl-dwell.patch) |
| Station order | Earlier working AirDrop build. Sets up Intel 9000-series firmware queues before adding the AWDL station and bounds retries after an AWDL firmware fault. | [Kext](Intel9560-AirDrop-Sequoia-station-order.zip) · [Source patch](acer-ac9560-awdl-station-order.patch) |

[Complete AirportItlwm dwell source and SDK](Intel9560-AirDrop-Sequoia-source.tar.gz) · [BlueToolFixup 2.7.4 kext](BlueToolFixup-AirDrop-2.7.4.zip) · [BlueToolFixup source](BlueToolFixup-AirDrop-2.7.4-source.tar.gz) · [SHA-256 checksums](SHA256SUMS)

## USB OpenCore settings

1. Back up the working USB EFI. Install the selected `AirportItlwm.kext` and the packaged `BlueToolFixup-AirDrop.kext` under `EFI/OC/Kexts`. Add or update their matching entries in `Kernel > Add`. The AirDrop BlueToolFixup replaces the existing enabled BlueToolFixup entry. Keep Lilu, IntelBluetoothFirmware and IntelBTPatcher enabled in dependency order.
2. Enable just one Intel Wi-Fi kext. For these packages, enable `AirportItlwm.kext` and disable the `itlwm.kext` and `ForbiddenItlwm.kext` entries. Set `MinKernel` and `MaxKernel` to `24.6.0` for the two replacement entries. Add `-itlawdl` to the existing `boot-args`. This USB profile runs with SIP enabled and uses the built-in macOS Wi-Fi controls.
3. Preserve the [verified microphone patch and layout 71 settings](../README.md#start-with-the-internal-microphone). Validate the USB config with the `ocvalidate` version matching the USB's OpenCore. Boot the USB from the Acer's F12 menu and verify Wi-Fi, Bluetooth, speaker playback and microphone capture before testing AirDrop in both directions. To roll back, restore the saved USB EFI.

## Build AirportItlwm on an Intel Mac

The [Ersiter AirportItlwm repository](https://github.com/Ersiter/Eric-AirportItlwm/tree/cf0c5263eae5981e78fdb2ffb0b9406702bc7fc6) is the base for all three patches. Apply one patch to a clean checkout. The complete dwell source archive already includes the applied patch and prepared SDK.

```sh
git clone https://github.com/Ersiter/Eric-AirportItlwm.git
cd Eric-AirportItlwm
git checkout cf0c5263eae5981e78fdb2ffb0b9406702bc7fc6
git apply /path/to/acer-ac9560-awdl-dwell.patch
git clone https://github.com/acidanthera/MacKernelSDK.git MacKernelSDK
git -C MacKernelSDK checkout 3f750085caa17ec3a7880f11c11bf4f48cd6a164
python3 scripts/prepare_tahoe_sdk.py
xcodebuild -project itlwm.xcodeproj -target AirportItlwm-Sequoia -configuration Debug \
  ARCHS=x86_64 ONLY_ACTIVE_ARCH=NO SYMROOT="$PWD/build/products" OBJROOT="$PWD/build/obj" \
  CODE_SIGNING_ALLOWED=NO build
codesign --force --sign - build/products/Debug/Sequoia/AirportItlwm.kext
```

The packaged Bluetooth binary comes from the [Eric-BlueToolFixup 2.7.4 Debug release](https://github.com/Ersiter/Eric-BlueToolFixup/releases/tag/2.7.4), with a local ad hoc signature. Its [upstream source](https://github.com/Ersiter/Eric-BlueToolFixup/tree/f77153515c3a46fa10bff1056847a7c6c336e4d3) is also archived above.
