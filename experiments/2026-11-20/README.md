# Acer Swift 5 SF514-53T USB experiments

Test machine and OS were an Intel Core i7-8565U and macOS Sequoia 15.8.3 (`24H241`). The SanDisk USB test boot used the internal configuration's AppleALC 1.9.8 layout 71. Speaker playback was verified after the DSP test.

## Start with the internal microphone

Stock TGLDmic 0.5.0 finds the Intel `8086:9DC8` controller, then reports `FAIL core0 power up (CPA) (0x001c003c)` before firmware starts. The Acer test build enables the DSP processing block and clears stale power requests. It is opt-in on `8086:9DC8` with Acer subsystem `1025:1312`. The build has passed compilation and a local signature check. DSP boot and microphone capture with this patch still require hardware verification.

1. Save your work and back up the working SanDisk `EFI/OC` folder. On the **SanDisk** OpenCore test configuration, replace `Kexts/TGLDmic.kext` with the [Acer test build](intel-sst-mic/Swift5-TGLDmic-0.5.0-test.zip). Keep its existing enabled `Kernel > Add` entry after AppleALC.
2. On that USB configuration, append `tgldmicacerfix=1` to `boot-args`. Keep `-tgldmic`, `tgldmicdelay=90`, and AppleALC layout 71. Validate the configuration with the `ocvalidate` version matching the USB's OpenCore build.
3. Boot the SanDisk from F12 and choose macOS. Check speaker playback before and after the 90-second DSP self-test. Run the check below and look for `OK FW_READY` in `BootResult`.
4. If the DSP boots, use the [upstream probe instructions](https://github.com/labrouss/TGLDmic/blob/v0.5.0/docs/TESTING.md) to verify actual speech, then verify speaker playback again. The Core Audio plug-in comes after a successful raw recording.

```sh
ioreg -l -w0 -r -c TGLDmic -d 1 | grep -E 'BootResult|TGLDmicPhase|Streaming|Acer DSP'
```

If speaker playback or boot fails, shut down, remove the SanDisk, and use the internal OpenCore entry. The stock USB kext and configuration can be restored from the local backup.

[Microphone patch](intel-sst-mic/Swift5-DSP.patch) · [Complete source and build dependencies](intel-sst-mic/Swift5-TGLDmic-0.5.0-source.tar.gz) · [Checksums](intel-sst-mic/SHA256SUMS) · [Related DSP power-up report](https://lategege.com/p/hackintosh-dsp-dmic/)

To rebuild the microphone test kext, extract the source archive and run `make -C kext SDK="$PWD/MacKernelSDK"` from its root on an Intel Mac with Xcode command-line tools.

## Intel AC 9560 AirDrop receive prototype

The Sequoia build targets Intel AC 9560 `8086:9DF0` with subsystem `8086:0034`. On a separate test configuration, it attempts same-channel AWDL reception on channel 44 or 149 when the card's firmware permits it. Compilation, signing, and offline parser and bridge checks passed. Radio reception and ordinary Wi-Fi stability have not been verified on hardware. Finder transfers still need a transmit path and an end-to-end test.

For a later USB test, use the [AirDrop receive build](intel9560-awdl/Intel9560-AWDL-Sequoia-probe.zip) and [test notes](intel9560-awdl/README.md). Enable only one Intel Wi-Fi driver in that configuration. Test ordinary connectivity and peer reception before considering any change to the daily boot configuration.

[AWDL source changes](intel9560-awdl/intel9560-sequoia.patch) · [Complete source and build dependencies](intel9560-awdl/Intel9560-AWDL-Sequoia-source.tar.gz) · [Checksums](intel9560-awdl/SHA256SUMS)

## Wi-Fi reconnect investigation

The daily `itlwm` 2.3.0 connection was active and passed router, DNS, and Internet checks after the reboot. In the recorded incident, macOS logged `en0` becoming inactive at the November 19 sleep wake at 18:50 HKT, then becoming active at 00:07 HKT on November 20. DHCP succeeded about six seconds later. This supports investigating association or resume recovery. A fixed 12-hour interval and the root cause are still unverified.

When it happens again, note the time, hold Option while opening HeliPort, and create a diagnostic report before reconnecting. [HeliPort diagnostics](https://openintelwireless.github.io/HeliPort/Troubleshooting.html)
