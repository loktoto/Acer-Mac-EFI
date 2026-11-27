# 假 SEP 三層計劃 — 第 2 層實驗結果（go / no-go）

日期：2026-11-27
狀態：**只做用戶空間實驗，冇改任何系統**。SIP 仍然 enabled、authdb 未郁。

---

## 1. 新證據（今次搵到）

| 發現 | 證據 |
|---|---|
| `_LAEnabledBiometryUsers` 係一個 **userInfo key**，值 = `"EnabledBiometryUsers"` | `LocalAuthentication.framework` export；probe 直接 deref 印出 |
| 個 key 用喺 **MobileKeyBag lock-status notification** | `kMobileKeyBagLockStatusNotification` = `com.apple.mobile.keybagd.lock_status` |
| `coreauthd` 有 `KeyBagLockStatusObserver` 專門聽呢個 notification | `coreauthd` strings：`startObservingKeyBagLockStatusChanges`、`KeyBagStatusObserver status changed:%d` |
| `coreauthd` 收 notification 之後：`userInfo[EnabledBiometryUsers]` → `LACADMUser namesFromUsersWithUIDs:` | disasm `0x100002CB1`–`0x100002D88` |
| `coreauthd` 另外 import `MKBGetDeviceLockState`、`LACBiometryHelper`、`LACDomainStateProviderBiometry` | `coreauthd.imports.txt` |

即係：biometry users 唔係 coreauthd 自己計，而係由 **keybagd**（`/usr/libexec/keybagd`，SEP/AKS 後端）透過 notification 交俾佢。

## 2. 實驗：外部可唔可以餵佢？

`research/sep-layer2-probe/feed.m`（無特權）：

```
baseline                     can=0 code=-6 type=0
distributed array            can=0 code=-6 type=0
distributed set              can=0 code=-6 type=0
distributed dict             can=0 code=-6 type=0
darwin post                  can=0 code=-6 type=0
LAEnvironment.state.biometry = (nil)
```

三種 userInfo 形狀（array / set / dict）＋ Darwin `notify_post` 全部**冇效**。
結論：個 observer 只接**同 process 內**嘅真 keybagd 事件，外部 post 被忽略；而且 `LAEnvironment.state.biometry` 由頭到尾都係 `nil`，即係 availability 根本冇 state 可以翻。

（工具：`probe.m` 印常數，`feed.m` 做注入實驗，兩者都係唯讀 + 一個 notification post。）

## 3. 三層現況總結

| 層 | 進度 | 卡位 |
|---|---|---|
| 1. Sensor | `isTouchIDPlatform` 可 force、假 bridge envelope 收得到 | 冇 enrolled identity；daemon 只信真 device |
| 2. Biometry identity | 已定位到 keybagd → `EnabledBiometryUsers` notification | **外部餵唔到**；要換/注入 keybagd（`/usr/libexec` 喺 sealed volume） |
| 3. 解鎖決策 | 已列出 `DTORatchetHandler` / `LACDTORatchetSEPInterface` / `LACDTORatchetSEPStateParser` | 冇 SEP 就冇 ratchet state，冇嘢可以 parse |

## 4. 仲可行嘅唯一路線（要你本人參與）

1. Reboot → Recovery → `csrutil disable` → reboot（session 會斷）
2. root 權限下：
   - 複製 `coreauthd`（同之前 biometrickitd 一樣，ad-hoc 簽名）＋ `DYLD_INSERT_LIBRARIES` 注入
   - 或者用 launchd override 換 `/usr/libexec/keybagd`
3. 喺 coreauthd 內部偽造 `EnabledBiometryUsers` / `LADomainStateBiometry`
4. 再處理第 3 層 ratchet（大概率仍然失敗，因為 ratchet state 由 SEP 產生）
5. 每次 macOS 更新重做

**風險**：coreauthd 係整個解鎖鏈嘅核心。注入版一 crash，鎖屏／授權可能完全失效；最壞情況要 Recovery 救。而且就算全部成功，`LAContext` 只會「以為」有 Touch ID，實際認證仍然係我哋 software 兜 —— 即係用最高風險換一個圖示。

## 5. 建議

- 想要**功能**（指紋解鎖）：A（真鎖屏 + capture-any + 5 次失敗規則）已經足夠，零風險。
- 想要**外觀**（真 Mac 咁樣）：B（自繪鎖屏，跟 `TOUCHID_MAC_UX_SPEC.md`），零系統改動。
- 想要**真 availability**：只剩上面第 4 節，成本極高、成功率低，而且我唔建議。
