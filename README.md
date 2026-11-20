# Acer-Mac-EFI

# Acer Swift 5 SF514-53T Hackintosh — Diagnostics & Execution Plan

> Machine: Acer Swift 5 SF514-53T (Whiskey Lake, i7-8565U, UHD 620)
> Dual boot: macOS (OpenCore) + Windows 11
> Compiled: 2026-11-18
> Status as of 2026-11-20: internal OpenCore boots and speakers work with AppleALC layout 71. The USB test confirmed a DSP power-up failure with stock TGLDmic 0.5.0.

---

## Current testing

The [November 20 USB test runbook](experiments/2026-11-20/README.md) covers the Acer SST microphone fix and Wi-Fi wake findings. The [Intel AC 9560 AirDrop downloads](experiments/2026-11-20/intel9560-airdrop/README.md) include a bidirectional AirDrop build tested on Sequoia 15.8.3, its rollback build, and a newer experimental build.

## 1. Machine profile

| Component | Detail | Source |
|---|---|---|
| Model | Acer Swift 5 SF514-53T | driver package in workspace |
| CPU | Intel Core i7-8565U (Whiskey Lake, 8th gen) | macOS `sysctl` |
| iGPU | Intel UHD 620 | DeviceSnapshot |
| Audio codec | Realtek ALC255 (`VEN_10EC&DEV_0255`, subsystem Acer `10251312`) | DeviceSnapshot |
| Audio bus/controller | Intel HD Audio `VEN_8086&DEV_AE20` | DeviceSnapshot |
| **SST DSP** | **Intel Smart Sound `VEN_8086&DEV_9DC8`** | DeviceSnapshot |
| HDMI audio | Intel Display Audio `VEN_8086&DEV_280B` | DeviceSnapshot |
| Secure Boot | OFF (`UEFISecureBootEnabled = 0`) | earlier diagnostic |
| Windows BCD backups | `bcd_backup_2026-11-17.bcd`, `bcd_backup_before_cleanup.bcd`, `bcd_backup_before_setdefault.bcd` | workspace |

---

## 2. Boot menu cleanup — COMPLETED

### Diagnosis
- Windows showed "which Windows to select": BCD had **two** Windows 11 loaders:
  - `{current}` → `partition=C:` (real) ✅
  - `{d5d76532-dea4-11f1-a94a-fc40e36e5210}` → `device unknown` (stale) ❌
- F12 had 4 options: extra stale USB firmware entries
  - `{4dbe0064-e238-11f1-86c7-806e6f6e6963}` "OpenCore" → USB
  - `{4dbe0065-e238-11f1-86c7-806e6f6e6963}` "OpenCore2" → USB
  - Good entry: `{d5d7653a-dea4-11f1-a94a-fc40e36e5210}` "OpenCore Internal" → `\EFI\OC\OpenCore.efi` on internal disk

### Actions executed (via admin .cmd/.ps1 scripts, full logs in workspace)
- Deleted stale `{d5d76532}` + orphans `{d5d76533}`, `{d5d76534}`
- Deleted stale USB entries `{4dbe0064}`, `{4dbe0065}`
- Set firmware display order to exactly 2: `{d5d7653a}` + `{bootmgr}`
- Verified: F12 = 2 options; Windows no longer asks which Windows.

### Rollback (if ever needed, admin cmd)
```
bcdedit /import "C:\...\bcd_backup_before_cleanup.bcd"
```

---

## 3. F2 vs F12 — why OpenCore is not in F2 (research, 396 sources)

**F12** = UEFI Boot Manager: reads raw `BootOrder` NVRAM variables → sees all entries.
**F2** = Acer Insyde OEM Setup page: filtered list, does **not** mirror `BootOrder`.

Root cause (cross-verified):
- Acer Insyde firmware **does not honor** normal EFI boot variables written by `bcdedit`/`efibootmgr`.
  - `github.com/rhboot/efibootmgr/issues/150` (Acer Swift SF314-43): "The regular EFI variables are not honored."
  - `unix.stackexchange.com/questions/609715`, `askubuntu.com/questions/1285967`, TeraByte KB.
- Renaming an entry's description via bcdedit does **not** help (EDK2 uses Description as display label, not a filter key).
- To register a custom bootloader in F2, Acer requires **firmware Setup trust registration**.

### Acer official method — A315-53G service manual p.55
> "Select an UEFI File as Trusted for Executing" → browse to `*.efi` → **"Enter Boot Description of this file"** → added to end of Boot device order (max 5).

Steps:
1. F2 → Security → Set Supervisor Password
2. Secure Boot = Enabled (else option is greyed out)
3. "Select an UEFI File as Trusted for Executing" → `HDD0/<EFI>/<OC>/OpenCore.efi`
4. Enter Boot Description (free text, e.g. `OpenCore`) → appears in F2
5. Optionally disable Secure Boot / clear password → Save & Exit

**Note:** BIOS updates can re-enable Secure Boot and wipe entries. Keep this procedure handy.

---

## 4. Internal microphone — diagnosis (research, 548 sources)

### Symptom
- Speakers work in macOS ✅
- Headset mic works in Windows ✅; both mics work in Windows ✅ (hardware OK)
- Internal mic in macOS: "sha sha sha" white noise, no voice picked up
- Tried layout-id 3 and 71 → no effect

### Root cause — CONFIRMED
Acer Community post for the **exact model** (community.acer.com/discussion/587646):
> Input device is named **"Microphone Array (Intel Smart Sound Technology / Intel SST)"**.

So the internal mic is wired to the **Intel SST / cAVS DSP (`8086:9DC8`)**, **NOT** to the ALC255 HDA codec.

- AppleALC / layout-id only drives the ALC255 analog path → can never fix the internal mic.
- Acidanthera dev vit9696 (bugtracker #2084): "AppleHDA will not be able to use this, and a separate driver will be needed."
- The white noise is a phantom/analog input from ALC255; real voice is on the DSP side, which macOS has no driver for.
- Many modern Intel laptops (Tiger/Comet/Whiskey Lake) have this: mic goes to DSP, hackintoshes lose internal mic.

### Why layout 3 / 71 failed
Both are ALC255 HDA layouts; they do not touch the SST DSP path. Expected failure.

---

## 5. Solution: TGLDmic (recommended)

`github.com/labrouss/TGLDmic` — unofficial community DMIC driver.

Compatibility (from official INSTALL.md):
- Supported DSP: `8086:9DC8` = **Cannon Lake / Whiskey Lake LP** ← matches this machine
- Supported CPUs explicitly include **Whiskey Lake i7-8565U / i5-8265U** ← i7-8565U matches
- Runs alongside AppleALC/AppleHDA — speakers + headset unaffected; adds a new input
- Upstream lists Ventura and Tahoe tests. On Sequoia 15.8.3, the Acer USB test loaded the driver and stopped at DSP power-up.
- Latest release: **v0.5.0** (2026-10-30, added Comet Lake support)

Risk: not tested on Acer SF514-53T specifically; experimental. Fully removable.

### Files (v0.5.0)
- `TGLDmic-0.5.0-kext.zip` → https://github.com/labrouss/TGLDmic/releases/download/v0.5.0/TGLDmic-0.5.0-kext.zip
- `TGLDmic-0.5.0.pkg` → https://github.com/labrouss/TGLDmic/releases/download/v0.5.0/TGLDmic-0.5.0.pkg
- SHA256 kext zip: `25c3f8dbc2881dca9fbdd3ef38fd477bb17c32d55044e8d370b906b726d0bff5`
- SHA256 pkg: `81dd4550eda13bf18013cb052999238dde75693dee41eec02906f047e2199f89`

---

## 6. Original execution plan

Use the [current USB test runbook](experiments/2026-11-20/README.md) for this Acer. The steps below record the original stock-driver plan.

### Phase 0 — Prepare
1. Boot into macOS via F12 → OpenCore Internal.
2. Download both v0.5.0 files.
3. **Back up the whole EFI** to Desktop (OpenCore Configurator → Mount EFI → copy, or `diskutil`).

### Phase 1 — Mount EFI
- OpenCore Configurator → "Mount EFI" → mount each, find the one containing `OC/` (not the Windows one with only `BOOT/` + `Microsoft/`).
- Or terminal: `diskutil list` → find `TYPE: EFI` → `sudo diskutil mount diskXs1` → check for `OC/`.
- Target paths: `EFI/OC/config.plist`, `EFI/OC/Kexts/`.

### Phase 2 — Install kext
1. Copy `TGLDmic.kext` → `EFI/OC/Kexts/`.
2. config.plist → `Kernel` → `Add` → new entry:
   - BundlePath: `TGLDmic.kext`
   - ExecutablePath: `Contents/MacOS/TGLDmic`
   - PlistPath: `Contents/Info.plist`
   - Enabled: `true`
   - **Place AFTER AppleALC.kext**
3. config.plist → `NVRAM` → `Add` → `7C436110-AB2A-4BBB-A880-FE41995C9F82` → `boot-args` → append `-tgldmic`.
4. Save config.plist. Reboot.

### Phase 3 — Verify kernel path (before installing pkg)
```bash
ioreg -l -w0 -c TGLDmic | grep -E '"BootResult"|"TGLDmicPhase"|"Streaming"|"Platform"'
```
Expected: `BootResult = "OK FW_READY"`, `TGLDmicPhase = 4`.

Optional deeper test (from kext zip):
```bash
./tgldmic-probe 3 probe.wav
```
Expect ~48000 frames/s, −60 dBFS quiet / −50..−30 dBFS talking.

If this fails → **stop, do not install pkg**, report output.

### Phase 4 — Install Core Audio plug-in
- Double-click `TGLDmic-0.5.0.pkg`. Not notarized → right-click → Open, or allow in Privacy & Security.
- CLI: `sudo installer -pkg TGLDmic-0.5.0.pkg -target /`
- Core Audio restarts automatically.

### Phase 5 — Select input & test
- System Settings → Sound → Input → **Internal Microphone (TGLDmic)** → talk, meter should move.
- QuickTime → File → New Audio Recording to verify.
- Input volume slider = software gain 0–36 dB (default 24).

### Diagnostics if it fails
```bash
python3 list-audio-devices.py
log show --last boot --predicate 'eventMessage CONTAINS "TGLDmic:"' --info
ioreg -l -w0 -c TGLDmic
```
If mic silent: boot Ubuntu live USB, run `sudo bash linux/capture-sof-dmic.sh`, open an issue with tarball + `ioreg -l -w0 -c TGLDmic`.

### Rollback / uninstall
```bash
./uninstall-hal.sh
sudo pkgutil --forget com.labrouss.TGLDmic.driver.pkg
```
Then remove `TGLDmic.kext` from `Kernel > Add` and `-tgldmic` from boot-args.
Boot-loop recovery: boot from backup EFI (or USB EFI), remove kext + boot-arg.

---

## 7. Research sources

### Boot / F2-F12 (396 sources; key ones)
- github.com/rhboot/efibootmgr/issues/150
- manualslib.com/manual/1780777/Acer-A315-53g.html?page=55 (Acer official service manual)
- unix.stackexchange.com/questions/609715
- unix.stackexchange.com/questions/645983
- askubuntu.com/questions/1285967
- community.acer.com/discussion/668985
- community.acer.com/discussion/587646 (exact model SF514-53T, Intel SST mic)
- thejackshih.com/posts/how-to-boot-into-linux-on-acer-v3-372/
- terabyteunlimited.com/kb/kb-articles/bootit-uefi-wont-boot-after-installing-on-acer-computer/
- tianocore EDK2 source (BmLoadOption.c, UefiSpec.h)

### Mic / DMIC (548 sources; key ones)
- github.com/labrouss/TGLDmic (+ docs/INSTALL.md)
- github.com/acidanthera/bugtracker/issues/2084
- github.com/macintelk/LatSOFAudio, github.com/pokipoi/LatSOF-Audio, github.com/shubhambanekar/LatSOFAudio
- github.com/WingLim/MicFix (ALC255 headset mic)
- github.com/cjtim/SF314-55G-hackintosh (same-gen Acer, ALC256 mic via ComboJack — different path)
- tonymacx86.com/threads/guide-acer-swift-5-sf514-53t-whiskey-lake-macos10-14-5.277618/ (exact model, layout 3)
- dev.to/archerallstars/...sf514-52t-alc255 (sister model audio fix, Linux)
- reddit.com/r/hackintosh (multiple DMIC / static-noise threads)
- github.com/MYunFeiYang/zbookpowerg7/blob/main/docs/macos-mic-troubleshooting.md

Full ranked lists: `agent_reach_mass_search.json/.md`, `mic_deep_research.json/.md` (in local workspace).

---

## 8. Open items
- [ ] Execute Phase 0–5 inside macOS
- [ ] Confirm `BootResult = OK FW_READY` in Phase 3
- [ ] Confirm internal mic input works in Phase 5
- [ ] If TGLDmic pipeline mismatches on this Acer → capture SOF dump via Ubuntu and open upstream issue
