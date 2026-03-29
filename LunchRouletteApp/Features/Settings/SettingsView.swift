import SwiftUI

struct SettingsView: View {
    private let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    private let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    private let feedbackEmail = "hello@lunchroulette.app"

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            List {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 16) {
                            Image("LaunchBrand")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 68, height: 68)
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                            VStack(alignment: .leading, spacing: 4) {
                                Text("午餐轉盤")
                                    .font(.title2.bold())
                                Text("幫你在台灣中午快速做決定")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Text("把常吃清單、收藏和今天條件放在一起，降低每天中午的選擇疲勞。")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.muted)
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.white.opacity(0.82))

                Section("使用方式") {
                    settingsRow(
                        title: "1. 先設定今天條件",
                        body: "用地點、預算、類型和外送偏好快速縮小範圍。"
                    )
                    settingsRow(
                        title: "2. 按下幫我決定午餐",
                        body: "抽出推薦後，如果不想吃可以立刻重抽。"
                    )
                    settingsRow(
                        title: "3. 喜歡的先收藏",
                        body: "收藏過的餐點會集中顯示，之後更容易回頭選。"
                    )
                }
                .listRowBackground(Color.white.opacity(0.74))

                Section("隱私與資料") {
                    settingsRow(
                        title: "資料儲存位置",
                        body: "目前午餐清單、收藏、篩選與最近紀錄都只存在這台裝置的本地端。"
                    )
                    settingsRow(
                        title: "定位與外部服務",
                        body: "這個版本還沒有使用定位、地圖或第三方外送平台帳號。"
                    )
                    settingsRow(
                        title: "隱私權重點",
                        body: "目前版本不建立帳號、不上傳個人資料，也不會把你的午餐偏好分享給第三方。"
                    )
                }
                .listRowBackground(Color.white.opacity(0.74))

                Section("關於我們與回饋") {
                    settingsRow(
                        title: "產品定位",
                        body: "午餐轉盤是一個幫忙減少選擇疲勞的小工具，目標是在最短時間內幫你做出今天中午的決定。"
                    )
                    settingsRow(
                        title: "意見回饋",
                        body: "如果你想回報問題、提供新功能建議，現階段可以寄信到 \(feedbackEmail)。正式版也可以再接進 App 內回饋表單。"
                    )
                    settingsRow(
                        title: "後續規劃",
                        body: "未來版本會考慮加入附近店家、地圖導航、天氣情境與更多台灣在地午餐分類。"
                    )
                }
                .listRowBackground(Color.white.opacity(0.74))

                Section("版本資訊") {
                    LabeledContent("版本") {
                        Text("\(version) (\(build))")
                    }
                    LabeledContent("Bundle ID") {
                        Text(Bundle.main.bundleIdentifier ?? "com.gnauh.LunchRoulette")
                            .multilineTextAlignment(.trailing)
                    }
                }
                .listRowBackground(Color.white.opacity(0.74))
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("設定")
    }

    private func settingsRow(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            Text(body)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
