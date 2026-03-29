# 午餐轉盤

一個用 SwiftUI 打造的 iOS 午餐決策 App MVP，目標是幫在台灣的使用者快速決定今天中午吃什麼。

## 這版已完成

- 隨機抽出今日午餐
- 台灣常見午餐類型與價格帶
- 依地點、預算、類型、外送條件篩選
- 避免最近幾天吃過的重複選項
- 可新增與刪除自己的午餐清單
- 支援收藏與「不想吃這個」快速重抽
- 使用 `UserDefaults` 保留午餐選項、篩選條件與最近紀錄
- 具備 App Icon、Launch Screen、設定頁與基本版本資訊

## 專案結構

- `project.yml`: XcodeGen 專案規格
- `LunchRouletteApp/App`: App 入口與 Tab 結構
- `LunchRouletteApp/Models`: 午餐資料模型、篩選條件、狀態儲存
- `LunchRouletteApp/Features/Home`: 今日午餐主畫面
- `LunchRouletteApp/Features/Manage`: 午餐清單管理畫面
- `LunchRouletteApp/Features/Settings`: 設定與上架前資訊骨架
- `docs/PRIVACY_POLICY_DRAFT.md`: 隱私權政策草稿
- `docs/APP_STORE_COPY_DRAFT.md`: App Store 文案草稿

## 如何開啟

這個環境目前沒有啟用完整 Xcode，所以我先用 XcodeGen 規格幫你把專案骨架建好。

1. 安裝 Xcode 與 XcodeGen
2. 在此資料夾執行 `xcodegen generate`
3. 開啟 `LunchRoulette.xcodeproj`
4. 選擇 iPhone 模擬器後執行

## 下一步建議

- 接上地圖或定位，依附近店家推薦
- 支援雨天模式與外送平台偏好
- 加入「今天不想吃這個」快速重抽
- 用 SwiftData 取代 `UserDefaults`
