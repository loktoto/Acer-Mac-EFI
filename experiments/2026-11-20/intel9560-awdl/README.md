# Intel AC 9560 AirDrop 接收測試版

適用測試目標係 Acer Swift 5 SF514-53T 嘅 Intel AC 9560（PCI `8086:9DF0`，子系統 `8086:0034`）同 macOS Sequoia 15.8.3（`24H241`）。

呢個版本將 9560 實驗傳輸程式移植到 Sequoia 驅動。以 `-itl9560awdl` 啟用後，喺已連接嘅 44 或 149 頻道、韌體容許使用該頻道時，會試開一個共用現有 PHY 嘅接收介面。`ITL9560AWDLState`、`ITL9560AWDLSetupError` 同 `ITL9560AWDLActionFrames` 係 IORegistry 嘅測試結果。接收計數只記錄有效 AWDL 管理封包數量。

實機首個驗收項目係原有 Wi‑Fi 可以照常連線，而且附近裝置開 AirDrop 時接收計數上升。Finder 雙向傳檔仲未接通。實機測試應用獨立 OpenCore USB 設定，同一設定只載入一個 Intel Wi‑Fi 驅動。

## 重建

```sh
git clone https://github.com/retropineaple/ForbiddenItlwm.git
cd ForbiddenItlwm
git checkout 6e151958dd1b5348c586e0efc22a2f9ed5158591
git apply /path/to/intel9560-sequoia.patch
git clone https://github.com/acidanthera/MacKernelSDK.git
git -C MacKernelSDK checkout 3f750085caa17ec3a7880f11c11bf4f48cd6a164
python3 tools/build.py --target sequoia --out build/ac9560
codesign --force --sign - build/ac9560/ForbiddenItlwm.kext
```

基底採用 [ForbiddenItlwm 0.6.0-beta.2](https://github.com/retropineaple/ForbiddenItlwm/commit/6e151958dd1b5348c586e0efc22a2f9ed5158591)。9560 韌體傳輸程式來自 [Bananz0 嘅 IWM AWDL 實驗](https://github.com/Bananz0/AirportItlwm-Tahoe-AWDL/commit/400019bacbc6025806597664acb8bcfc77eb71cc)。原始碼沿用上游授權同檔案版權聲明。

已編譯 x86_64 kext 同離線驗證壓縮檔內簽章。壓縮檔 SHA‑256 為 `95c1122c5adf3e9d417c8125c3f25a396012a2f30075940343c42364f883a47e`。
