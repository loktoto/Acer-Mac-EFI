# Touch ID「假到似真」實驗：完整發現與實行計劃

產生時間：2026-11-26 00:06 (HKT)
狀態：**尚未執行任何系統改動**。USB、內部磁碟、authorization DB 全部保持原狀。

---

## 0. 目標與一句話結論

**目標**：用 EgisTec 0570 指紋 reader，喺呢部 hackintosh 上得到「Touch ID 體驗」— 系統設定見到 Touch ID、鎖屏見到指紋、摸落去解鎖。

**結論**：真正 Apple Touch ID（SEP-backed、工廠配對密鑰、模板留喺 silicon）喺呢部機**物理上做唔到**。唯一可行嘅係「外觀 + 授權流程似 Touch ID，底層用 software forge」。呢份文檔紀錄全部證據同點樣用**隔離 USB** 安全地做。

---

## 1. 研究發現（150 sources，兩輪 agent-reach / Exa）

| 發現 | 證據 |
|---|---|
| 第三方 sensor 冇可能同 SEP 配對 | Apple 出廠寫共享密鑰入 silicon + Apple CA attestation（PKA block、ECDHE、AES-GCM），模板永遠留喺 SEP |
| 權威原文 | standalone-touchid：*"There is no way to have a non-Apple sensor talk to the Secure Enclave."* / *"Every other sensor is locked out of the Secure Enclave by design."* |
| EgisTec 0570 本質 | raw-image swipe sensor，host-side matching（libfprint / NBIS），**冇 on-chip matching** — 同 HTID 支援嗰啲 Synaptics Metallica `06cb:009a`、Prometheus `138a:0097` 唔同類 |
| 唯一 software「似 Touch ID」開源做法 | HTID（hackintosh-user/hack-touchid）：Accessibility 監聽 password prompt → 指紋 match → 自動入 password。唔改 authorizationdb、唔需要 SEP |
| HTID plugin 硬件實測教訓 | 第三方 plugin **唔可能 suppress Apple login UI**；安全設計係永遠 `SetResult(kAuthorizationResultAllow)`，實決策留畀 `builtin:authenticate` |

研究報告：
- `research/TOUCHID_SEP_118_sources.md`（118 sources）
- `research/TOUCHID_SEP_150_sources.md`（150 sources，含第二輪 on-chip / estimator 分析）

---

## 2. 本機 recon（實測）

| 項目 | 結果 |
|---|---|
| hostname / SMBIOS | `Too-Mac` / `MacBookPro15,2` |
| OS / arch | macOS **15.8.3** (24H241) / x86_64 |
| 本質 | **hackintosh** — 有 VoodooI2C / VoodooGPIO / ItlIwm / ApplePS2Controller kext |
| SEP | `AppleSEPManager.kext` loaded 但 **ioreg 無 node**；`LAContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics)` 返 **-6** |
| `system.login.screensaver` | 已被 `com.openai.sky.CUAService.AuthorizationPlugin.remote` + `use-login-window-ui` 佔用，`k-of-n=1`（OR）— 改佢有 lockout + 搞壞 automation 環境風險 |
| SIP / authenticated-root | **enabled / enabled** |
| 系統卷 | `/dev/disk1s4s1`，`sealed, local, read-only` |
| sudo / codesign | 冇 passwordless sudo；`security find-identity -v -p codesigning` → 0 valid identities（只能用 ad-hoc `-`） |
| USB fingerprint sensor | EgisTec `1c7a:0570` rev 10.41 — USB transport 正常（inspect/probe/frame pass） |

---

## 3. Binary recon（決定性，2026-11-26 新做）

呢部分決定「patch 係咪真係做得到」。

### 3.1 Sensor kext 已經喺系統入面，但缺 hardware

```
/System/Library/Extensions/AppleBiometricSensor.kext
/System/Library/Extensions/AppleBiometricServices.kext
/System/Library/Extensions/IOBiometricFamily.kext
/System/Library/Extensions/AppleMesaSEPDriver.kext
/System/Library/Extensions/AppleVirtIOBiometrics.kext
```

`AppleBiometricSensor.kext` 嘅 `IOKitPersonalities` 用 `IONameMatch = "biosensor,mesa"`、`IOProviderClass = AppleARMSPIDevice` — 即係要 **SPI bus 上嘅 Touch ID sensor** 先會 instantiate。呢部 x86 hackintosh 冇 SPI device，所以 node 永遠唔會出現。

Mesa / SandDollar 係 Apple Touch ID sensor 嘅 codename；`biometrickitd` 入面有 `isTouchIDPlatform()` 同 `Daemon-Mesa` log category。

### 3.2 `isTouchIDPlatform()` — 真正 call site 搵到咗

`biometrickitd`（2,617,152 bytes，universal x86_64 + arm64e，Mach-O `cafebabe`）：

```
0000000100047e15  callq  0x1000d5ca4    ## symbol stub for: _isTouchIDPlatform
0000000100047e1a  testb  %al, %al
0000000100047e1c  je     0x100047ff6    ## 硬件唔存在 → skip 成個 Touch ID 初始化
0000000100047e22  leaq   ... "com.apple.BiometricKit"
0000000100047e29  leaq   ... "Daemon-Mesa"
0000000100047e30  callq  _os_log_create
```

string `isTouchIDPlatform()` 喺 file offset `0xdfbbd`。

**呢個 executable 係真 Mach-O，可以 patch** — flip 個 branch 就可以令佢 continue 落去。

### 3.3 但其實作喺 dyld shared cache（最大限制）

```
/System/Volumes/Preboot/Cryptexes/OS/System/Library/dyld/
  dyld_shared_cache_x86_64h      870,727,680 bytes
  dyld_shared_cache_x86_64h.01   804,945,920 bytes
  ... (.02 到 .06)              共 ~5.5 GB
```

- filesystem 上嘅 `BiometricKit`、`BiometricSupport` 等 system dylib **唔係真檔**（`ls` 報 no such file / placeholder）
- `nm -gU biometrickitd` 搵唔到 `_isTouchIDPlatform` — symbol stub 指向 dyld cache 入面嘅實作
- 改 shared cache = **全機級手術**，cache 損壞 = boot 唔起，reset 只能靠 Recovery

### 3.4 `coreauthd` — 可以 patch 但要再 reverse engineer

```
/System/Library/Frameworks/LocalAuthentication.framework/Support/coreauthd
```

- 1,059,856 bytes，universal x86_64 + arm64e，**真 Mach-O**
- 有 strings：`evaluatePolicy:options:uiDelegate:reply:`、`evaluatePolicy:options:uiDelegate:originator:reply:`、`evaluatePolicy:options:error:`
- 理论上 patch 得到，但 **「究竟 patch 邊個 byte 先係真正 success return」需要再 disassembly 確認**，唔可以估

### 3.5 可 patch 性總結

| 層 | 位置 | 可 patch? | Patch 後效果 |
|---|---|---|---|
| App + LAContext | app process | query point | 唔改 |
| `coreauthd` | 真 Mach-O | ✅ | `evaluatePolicy` → forge success（**真正呃到 app**，但係偽造安全憑證） |
| `biometrickitd` | 真 Mach-O call site | ✅ | `isTouchIDPlatform` branch flip → **只係 UI / cosmetic** |
| `AppleBiometricSensor.kext` | kext，要 SPI device | ❌ 硬件缺失 | 冇 SPI sensor 就唔會 load |
| Secure Enclave | silicon | ❌ 物理不存在 | 工廠密鑰 software 造唔到 |

---

## 4. USB 現況

SanDisk Ultra，**61.5 GB / disk2**，MBR partition table：

| Partition | 大小 | 格式 |
|---|---|---|
| `disk2s1` `1401` | 2.1 GB | FAT32 |
| `disk2s2` `NMINSTALL` | 37.7 GB | **NTFS** |
| `disk2s3` `TINY11` | 21.6 GB | FAT32 |

⚠️ 唔係空白 drive，似係 Windows 安裝盤。**Format 之後資料永久消失，救唔返。**

### 點解唔可以「淨係 update EFI」

EFI / bootloader 只負責載入 OS，Touch ID daemon 喺**系統卷**入面，唔喺 EFI 分區。改 EFI 改唔到 daemon。而且呢隻 USB 係 MBR，連合法 EFI System Partition 都冇。要喺 USB 上做 patched macOS，一定要：MBR→GPT → EFI 分區 → APFS container → 裝/clone macOS → patch 系統卷。

### Installer 來源現況

- `createinstallmedia`：搵唔到（`/Applications` 冇 Install macOS.app）
- `softwareupdate --list-full-installers`：被 kill（exit 137，需要再試其他方法）

---

## 5. 已經 build 好嘅嘢（全部 staged / 未 deploy）

| 項目 | 內容 | 狀態 |
|---|---|---|
| `estimator-fix/` | 17 rows bug 合成重現（舊 9/81 → fix 57/81），candidate patch + 測試 harness | built |
| `egis0570-calibrated-v2` | v2 verifier（零 dy penalty、dy search 0..12、median delta） | built，開到 reader |
| `AcerFingerprint-v2.bundle` | v2 signed bundle，ad-hoc codesign pass，plugin `BUNDLE_ROOT` compile-time 指向自己 | built |
| `touchid-daemon/` | AX watcher + Keychain + launchd plist，有 `--dry-run` | built + dry-run pass |
| `migration/` | 可還原 authorization DB branch + rollback | staged，未裝 |
| `capture-strips.c` / `analyze-strips.py` | 原始 strip dump + 離線 estimator 重放 | built + smoke test pass |
| handover ZIP | `Acer-EgisTec-Touch-ID-Handover.zip` 6.7 MB / 117 files，SHA256SUMS 95 項全 OK | ready |

Root path：`/Users/lokacermac/Documents/AI_Platform/Acer-Mac-EFI/tools/egis0570/`

---

## 6. 詳細實行計劃

### Phase 0 — 用戶先決定兩件事（我唔會代決定）

1. **抹唔抹 disk2**
   - 抹 = 三個 partition 資料永久消失
   - 唔抹 = 要插另一隻空白 USB，或者先將 `NMINSTALL` / `TINY11` 抄走
2. **點攞 macOS installer**
   - (a) 我試其他方法 download full installer（~12 GB，要時間 + 網絡）
   - (b) 用戶自己提供 `Install macOS.app` 放 `/Applications`
   - (c) 用 ASR / clone 現有 running system 去 USB（快，但要完整克隆）

### Phase 1 — 整 bootable trial USB

```
diskutil eraseDisk GPT <name> disk2        # MBR → GPT
# 建立 EFI 分區 + APFS container
createinstallmedia / ASR clone             # 裝 macOS 落 USB
```

- 確認 USB 可以 boot（OpenCore 加 USB entry，或者用現有 OpenCore boot menu 揀）

### Phase 2 — 喺 USB copy 上面開手術環境

- USB 系統卷 remount RW
- 關 SIP / authenticated-root
  - ⚠️ **SIP/AR 係 NVRAM 設定，全機性，唔係 per-volume** — 但可還原
  - 設定喺 `csr-active-config`（目前 `%00%00%00%00` = SIP default on）
- 完整 backup 所有將要改嘅 binary 去另一個 partition

### Phase 3 — Patch（byte-level，要有證據先落手）

1. `biometrickitd`：由 disassembly 確認 `0x100047e15` 嘅 branch encode，flip `je` → continue → System Settings 出 Touch ID 面板
2. `coreauthd`：再 disassembly 搵真實 `evaluatePolicy` success return point，接去 EgisVerify（**真指紋 match 先 return allow**）
3. 每步先 dry-run + 對照原 byte，先寫入
4. Re-seal snapshot + bless

### Phase 4 — 用戶測試

1. 插 USB boot
2. System Settings → 睇有冇 Touch ID 面板
3. enrol 指紋
4. 鎖屏 → 用 EgisTec swipe → 解鎖

### Phase 5 — Rollback

- 拔 USB 開機 = 原系統完全不變（internal disk 一個 byte 都冇改過）
- USB 上面一鍵 restore backup + re-seal
- 如果 SIP/AR 改過 NVRAM，用 Recovery `csrutil enable` + `csrutil authenticated-root enable` 還原

---

## 7. 風險（必需知清楚）

1. **關 SIP + authenticated-root** 要 reboot 入 Recovery 先做到 — 要用戶本人動手，reboot 會 cut 咗 AI session
2. **Patch sealed system volume** 要 remount RW → 改 binary → re-seal → bless。任何一步錯可能 boot 唔起，要 Recovery 重建
3. **改 dyld shared cache** 係全機手術，cache 損壞 = boot 唔起
4. **Forge `evaluatePolicy`** = 偽造安全憑證。App 以為自己用緊 SEP 保護，實際上係假 — FileVault / Keychain / App Store 唔會真係受 Touch ID 保護，**保安水平跌咗**
5. **USB 資料損失**：format disk2 = 永久刪除

---

## 8. 最終期望（老實講）

### 會得到
- ✅ System Settings 出 Touch ID 面板
- ✅ 鎖屏見到指紋、用 EgisTec reader swipe 解鎖
- ✅ App 問 LAContext 會以為有 Touch ID

### 唔會得到
- ❌ 真正 SEP-backed Touch ID
- ❌ FileVault / iCloud Keychain / App Store 受 Touch ID 保護
- ❌ 任何需要 Apple CA attestation 嘅服務（App Store 購買、iCloud 等高安全操作）

**定位**：外觀 + 授權流程似 Touch ID，底層係 software forge。唔係 Apple 原生 Touch ID。

---

## 9. 而家嘅狀態 / 下一步

**而家：零改動。** 所有 recon 都係唯讀。

**下一步**：用戶決定 Phase 0 兩件事（抹 USB + installer 來源），我先落手 Phase 1。

喺用戶決定之前，我唔會：
- format disk2
- download installer
- 改任何系統 binary / NVRAM / authorization DB
