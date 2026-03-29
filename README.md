# 午餐轉盤

午餐轉盤是一個用 SwiftUI 開發的 iOS App，想解決的問題很單純：每天中午到了，常常不是沒東西吃，而是不知道要吃什麼。

這個專案目前先聚焦在「快速做決定」這件事，讓使用者可以整理自己的常吃清單，再用預算、地點、類型和外送條件縮小範圍，最後抽出今天的午餐。

## 目前功能

- 隨機決定今天午餐吃什麼
- 支援台灣常見午餐類型與價格帶
- 可依地點、預算、類型與是否外送篩選
- 避免短時間內重複抽到最近吃過的選項
- 可新增、刪除與管理自己的午餐清單
- 支援收藏常吃選項
- 支援「不想吃這個」後立即重抽
- 使用 `UserDefaults` 儲存午餐選項、篩選條件與最近紀錄

## 專案結構

- `project.yml`：XcodeGen 專案設定
- `LunchRouletteApp/App`：App 入口與主要導覽
- `LunchRouletteApp/Models`：資料模型與本地儲存
- `LunchRouletteApp/Features/Home`：首頁與午餐抽選流程
- `LunchRouletteApp/Features/Manage`：午餐清單管理
- `LunchRouletteApp/Features/Settings`：設定、版本資訊與上架相關內容
- `LunchRouletteApp/Resources`：資產、Icon、Launch Screen
- `docs`：隱私權政策、支援頁與上架文案草稿
- `scripts`：圖資與 App Store 截圖生成腳本

## 開發環境

- Xcode 16 以上
- XcodeGen

## 如何執行

1. 安裝 `XcodeGen`
2. 在專案根目錄執行 `xcodegen generate`
3. 開啟 `LunchRoulette.xcodeproj`
4. 選擇模擬器或實機後執行

## 文件與上架相關頁面

- 隱私權政策：`docs/privacy.html`
- 支援頁：`docs/support.html`
- App Store 文案草稿：`docs/APP_STORE_COPY_DRAFT.md`

## 後續可以再做的方向

- 串接地圖或定位，提供附近餐點建議
- 支援更多情境篩選，例如雨天、想吃清淡、想喝湯
- 加入店家資訊、導航與收藏分類
- 改用 SwiftData 管理本地資料
