# 「似真 Mac」Touch ID 體驗規格（研究結果）

日期：2026-11-27
狀態：**純研究，冇改系統**。目的係先定義「Mac 嘅樣」到底係咩，再決定點實作。

---

## 1. 研究方法

1. **本機 Apple 資源**（最硬證據）：
   - `/System/Library/CoreServices/loginwindow.app/Contents/Resources/loginwindow.loctable`
   - `/System/Library/PrivateFrameworks/LoginUIKit.framework/.../LoginUICore.framework/.../Localizable.loctable`
   - `/System/Library/PrivateFrameworks/LocalAuthenticationCoreUI.framework/.../Resources/`
   - `/System/Library/PrivateFrameworks/LocalAuthenticationUI.framework/.../Resources/Assets.car`
2. **Apple 官方文件**：Use Touch ID on Mac、If Touch ID isn't working、Platform Security（biometric security）、LocalAuthentication / LAAuthenticationView。
3. **實機用戶報告**（Apple Community / Ask Different / Macworld）用嚟補官方冇寫嘅視覺細節。

---

## 2. 真 Mac 鎖屏 Touch ID 流程（狀態機）

### State 0 — 鎖屏，Touch ID 可用
- 壁紙 + 頂部大鐘（時:分）+ 日期；macOS 14+ 帳戶頭像喺**底部中間**，圓形頭像 + 名。
- 密碼位置**唔係即刻出輸入框**，而係一行提示文字：
  - 英文原文（loginwindow.loctable `TOUCH_ID_OR_PASSWORD`）：**`Touch ID or Enter Password`**
  - 一打字或者 click 落去，先變成真正嘅 secure text field。
- 指紋圖示：Apple 嘅認證 UI（LocalAuthenticationUI）用嘅資產叫 `touchID` / `touchID-gray`，另外有 `sf-unlock-TouchID`（Apple Watch / Touch ID 解鎖提示用）。
  - 鎖屏上，指紋 glyph 係跟住密碼欄／提示位出現，唔係獨立一張大圖。

### State 1 — 放手指上去
- Apple 官方講法：**輕觸**感應器即可，唔需要按落去（Magic Keyboard 除外，某啲版本要按）。
- Mac **冇公開**「掃描中」嘅動畫規格。iOS 有明顯嘅圓環／震動，macOS 鎖屏係「摸完即解鎖」，中間幾乎冇可見進度。
- 我哋搵到嘅系統動畫資產：
  - `LocalAuthenticationCoreUI/Resources/lock.ca`（鎖頭 CoreAnimation，有 `Sleep` state）
  - `LocalAuthenticationCoreUI/Resources/face-id-spinner.ca`（Face ID 用）
  - `LocalAuthenticationUI/Resources/checkmark.caml`（成功剔）

### State 2 — 成功
- 直接返 desktop，session 一直存在（唔係重新 login）。
- Apple 認證 UI 嘅成功回饋係一個**藍色剔**：`checkmark.caml` 嘅 stroke = `0 0.4784 1`，即 **#007AFF**（Apple 系統藍）。
- 冇系統音效、冇 haptic（Mac 上冇 Taptic 回饋；「啪」聲係實體按鈕）。

### State 3 — 唔中（no-match）
- 可以即刻再掃，唔會即刻彈密碼。
- **連續 5 次唔中 → 強制用密碼**（Apple 官方規則）。
- 其他一定要密碼嘅情況：
  - 重啟 / logout 之後
  - 超過 48 小時冇解鎖
  - 改 Touch ID 設定、加減手指
  - 解鎖部分敏感設定 pane（Users & Groups / FileVault 等）
- 呢個時候鎖屏會出密碼框，配文（`TOUCH_ID_PASSWORD_REQUIRED`）：
  **`Your password is required to enable Touch ID.`**
- 重試按鈕字（`TRY_AGAIN_BUTTON`）：**`Try Again`**

### 密碼框本身
- `LoginUICore` 有兩條字：`SECURE_TEXTFIELD_ENTER_PASSWORD`（"Enter Password"）、`SECURE_TEXTFIELD_PASSWORD`（"Password"）。
- 即係：平時 hint 用 `Touch ID or Enter Password`；一入密碼模式就變 `Enter Password`。

---

## 3. 其他 Touch ID 情境

| 情境 | 出現嘅 UI | 可否喺我哋部機複製 |
|---|---|---|
| App 內 `LAContext`（1Password、System Settings padlock） | 系統 sheet：app 名 + 原因 + 指紋 glyph，可 Cancel / Use Password | ❌ 要真 biometry（-6） |
| `sudo`（Sonoma+ `pam_tid`） | Terminal 內文字 prompt，指紋喺感應器完成 | 🟡 可以用 PAM module 自己做，但唔係 Apple UI |
| System Settings | pane 名叫 **Touch ID & Password**，列表 + 「Add Fingerprint…」 | ❌ pane 由 biometry 存在與否決定 |
| Apple Pay | payment sheet，指紋授權 | ❌ 要 SEP |
| 開機登入畫面（未 login） | 要先揀用戶，再 Touch ID；FileVault 之前唔得 | ❌ pre-boot 冇 USB driver |

---

## 4. 我哋部機（Acer SF514-53T / EgisTec 0570）可行性對照

| 元素 | 真鎖屏做唔做到 | 原因 / 證據 |
|---|---|---|
| 鎖屏掃手指解鎖 | ✅ 可以（auth plug-in 已掛 `system.login.screensaver`） | 已經實測過 invoke + Deny handoff |
| 鎖屏出 `Touch ID or Enter Password` | ❌ | loginwindow 用 `TOUCH_ID_*` 字串，前提係 biometry 可用 |
| 鎖屏出指紋 glyph | ❌ | `LAEnabledBiometryUsers` 由 MobileKeyBag/SEP 餵；冇 SEP 永遠空（19:41 決定性實驗） |
| System Settings Touch ID pane | ❌ | 同上 |
| App 內 LAContext sheet | ❌ | `canEvaluatePolicy` = false, code -6 |
| 自己畫一個 1:1 似 Mac 嘅鎖屏 | ✅ | 完全自己控制，可用返 Apple 字串 / 顏色 / glyph |

> 補充：現有真鎖屏 plug-in 嘅實測 log 顯示，佢喺 0.8–10.7 秒就因為 `user-activity` 收手，而且要有 enrolled profile（`Profiles/` 而家係空），所以「真鎖屏解鎖」實際上仲未 work。

---

## 5. 「似 Mac」實作規格（如果要自繪）

### 版面（1440×900 基準，全部按比例）
| 元素 | 規格 |
|---|---|
| 背景 | 當前桌面壁紙，heavy blur（radius ≈ 60px）+ 黑色 25% overlay |
| 大鐘 | SF Pro Display Ultralight，~96pt，白色 92%，位置：頂部 18% 高度 |
| 日期 | SF Pro Text Regular 22pt，白色 75%，大鐘上面 8pt |
| 頭像 | 88pt 圓形，底部中間上方（距底 ~22%） |
| 用戶名 | SF Pro Text Medium 17pt，白色 90%，頭像下 10pt |
| Hint | `Touch ID or Enter Password`，15pt，白色 65% |
| 密碼框 | 236×34，圓角 8，白 12% 填充 + 白 18% 1px 邊；focus 時邊變 #007AFF |
| 指紋 glyph | SF Symbol `touchid`，18pt，白色 85%，密碼框右側內嵌 10pt |

### 狀態機 / 動畫
| 狀態 | 視覺 | 時長 |
|---|---|---|
| idle | glyph 靜止，hint 正常 | — |
| waiting（reader 開緊／等手指） | glyph alpha 1.0 ↔ 0.55 | 1.2s ease-in-out 無限循環 |
| success | glyph → 藍剔（#007AFF），window fade out | 剔 0.2s，fade 0.25s |
| no-match | 密碼框水平 shake ±8pt（3 個來回）+ hint 變 `Try Again` | 0.35s |
| 5 次失敗 | 轉純密碼模式：hint `Enter Password`，glyph 變灰（`touchID-gray`） | 即時 |
| 解鎖完成 | 內容 scale 1.00 → 1.02 + fade | 0.25s |

### 行為
- 任何手指掃一下 = 成功（體驗模式，用 `fp-verify capture-only`，唔需要 enrolment）。
- 密碼永遠可用（真 `AuthorizationCreate` 驗證），Enter 提交。
- 5 次指紋失敗 / reader 開唔到 → 直接轉密碼，唔好卡住用戶。
- 冇聲、冇震（同 Mac 一致）。

---

## 6. 未證實 / 誠實限制

1. Apple **冇公開**鎖屏指紋動畫嘅 pixel 規格；上面 waiting/success 嘅 timing 係按 Apple 認證 UI 資產（`checkmark.caml`、`lock.ca`）同 iOS 觀感推定，唔係官方數字。
2. 鎖屏 hint 係「文字」定「框內 placeholder」會跟 macOS 版本同狀態變（Ask Different 有用戶描述「只有文字、冇輸入框」）。自繪版建議：預設文字，一打字即出框，兩邊都似。
3. 指紋 glyph 用 SF Symbol `touchid`（同 Apple `touchID` 資產同一個設計），唔直接抄 Assets.car 出嚟用。
4. 真鎖屏（loginwindow）**永遠唔會**出呢啲元素，除非有真 SEP / 改 sealed system volume（已證唔值）。
