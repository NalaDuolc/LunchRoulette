import SwiftUI

enum AppStoreScreenshotScene: String, CaseIterable {
    case hero
    case filters
    case reroll
    case favorites
    case manage

    init?(environment: [String: String] = ProcessInfo.processInfo.environment) {
        guard let rawValue = environment["SCREENSHOT_SCENE"] else { return nil }
        self.init(rawValue: rawValue)
    }

    var fileName: String {
        switch self {
        case .hero: "01-hero"
        case .filters: "02-filters"
        case .reroll: "03-reroll"
        case .favorites: "04-favorites"
        case .manage: "05-manage"
        }
    }
}

struct AppStoreScreenshotView: View {
    let scene: AppStoreScreenshotScene

    private let store = LunchStore(preview: true)

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                header

                sceneCard
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .padding(.horizontal, 44)
            .padding(.top, 36)
            .padding(.bottom, 28)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 54, weight: .heavy, design: .rounded))
                .foregroundStyle(AppTheme.ink)
                .lineSpacing(2)

            Text(subtitle)
                .font(.system(size: 24, weight: .medium, design: .rounded))
                .foregroundStyle(AppTheme.muted)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var sceneCard: some View {
        switch scene {
        case .hero:
            screenshotShell {
                screenshotHeroContent
            }
        case .filters:
            screenshotShell {
                screenshotFiltersContent
            }
        case .reroll:
            screenshotShell {
                screenshotRerollContent
            }
        case .favorites:
            screenshotShell {
                screenshotFavoritesContent
            }
        case .manage:
            screenshotShell {
                screenshotManageContent
            }
        }
    }

    private func screenshotShell<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("9:41")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.black)
                    .frame(width: 126, height: 38)
                Spacer()
                HStack(spacing: 8) {
                    Image(systemName: "wifi")
                    Image(systemName: "battery.100")
                }
                .font(.system(size: 17, weight: .semibold))
            }
            .padding(.horizontal, 28)
            .padding(.top, 18)
            .padding(.bottom, 18)
            .background(Color.white.opacity(0.18))

            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .background(
            RoundedRectangle(cornerRadius: 44, style: .continuous)
                .fill(Color.white.opacity(0.55))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 44, style: .continuous)
                .stroke(.white.opacity(0.55), lineWidth: 1.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 44, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 26, x: 0, y: 18)
    }

    private var screenshotHeroContent: some View {
        VStack(alignment: .leading, spacing: 22) {
            topBar(title: "今天吃什麼")
            statsRow(values: [("18", "符合條件"), ("6", "已收藏"), ("12", "已決定")])
            heroCard(
                name: "韓式拌飯",
                chips: ["異國料理", "100-150", "商圈"],
                note: "想吃重口味時很適合，抽到就不用再猶豫。"
            )
            primaryButton("幫我決定午餐")
            secondaryButtons(left: "不想吃這個", right: "今天就吃這個")
            Spacer()
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 28)
        .padding(.top, 8)
    }

    private var screenshotFiltersContent: some View {
        VStack(alignment: .leading, spacing: 22) {
            topBar(title: "今天條件")
            heroCard(
                name: "先設定條件",
                chips: ["公司附近", "100-150", "便當"],
                note: "根據今天預算、地點和午餐類型，快速縮小範圍。"
            )
            filterGroup(title: "地點", items: ["公司附近", "住家附近", "商圈"], selected: 0)
            filterGroup(title: "預算", items: ["不限", "100 內", "100-150", "150+"], selected: 2)
            filterGroup(title: "類型", items: ["隨便都行", "便當", "麵類", "飯類"], selected: 1)
            infoRow("只看可外送", value: "開啟")
            infoRow("避免重複天數", value: "2 天")
            Spacer()
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 28)
        .padding(.top, 8)
    }

    private var screenshotRerollContent: some View {
        VStack(alignment: .leading, spacing: 22) {
            topBar(title: "重抽也很快")
            heroCard(
                name: "雞腿便當",
                chips: ["便當", "100-150", "公司附近"],
                note: "如果今天不想吃便當，也可以立刻換一個結果。"
            )
            HStack(spacing: 16) {
                actionCard(icon: "arrow.triangle.2.circlepath", title: "不想吃這個", body: "一鍵重抽，不用重新設定。")
                actionCard(icon: "checkmark.seal.fill", title: "今天就吃這個", body: "確定後才會記錄到最近午餐。")
            }
            heroCard(
                name: "牛肉麵",
                chips: ["麵類", "150+", "商圈"],
                note: "重抽後馬上給你下一個更有感的選項。"
            )
            Spacer()
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 28)
        .padding(.top, 8)
    }

    private var screenshotFavoritesContent: some View {
        VStack(alignment: .leading, spacing: 22) {
            topBar(title: "我的收藏")
            heroCard(
                name: "收藏想再吃一次的午餐",
                chips: ["快速回找", "常吃店家", "不怕忘記"],
                note: "看到喜歡的選項就點星星，下次更快決定。"
            )
            HStack(spacing: 16) {
                favoriteCard(name: "雞腿便當", detail: "便當 ・ 100-150", note: "白飯配三樣菜，穩定不踩雷")
                favoriteCard(name: "咖哩飯", detail: "飯類 ・ 100-150", note: "濃郁又有飽足感")
            }
            HStack(spacing: 16) {
                favoriteCard(name: "韓式拌飯", detail: "異國料理 ・ 100-150", note: "想吃重口味時很適合")
                favoriteCard(name: "鹽水雞", detail: "清爽類 ・ 100-150", note: "可以客製配菜，吃起來沒負擔")
            }
            Spacer()
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 28)
        .padding(.top, 8)
    }

    private var screenshotManageContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            topBar(title: "午餐清單")
            sectionCard(title: "新增午餐選項") {
                VStack(spacing: 12) {
                    formRow(label: "名稱", value: "排骨便當")
                    formRow(label: "類型", value: "便當")
                    formRow(label: "預算", value: "100-150")
                    formRow(label: "地點", value: "公司附近")
                    formRow(label: "可外送", value: "是")
                    formRow(label: "備註", value: "份量夠、出餐快")
                    primaryButton("加入清單")
                        .padding(.top, 6)
                }
            }
            sectionCard(title: "目前選項") {
                VStack(spacing: 12) {
                    manageRow(name: "雞腿便當", detail: "便當 ・ 100-150 ・ 公司附近", favorite: true)
                    manageRow(name: "牛肉麵", detail: "麵類 ・ 150+ ・ 商圈", favorite: false)
                    manageRow(name: "咖哩飯", detail: "飯類 ・ 100-150 ・ 商圈", favorite: true)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 28)
        .padding(.top, 8)
    }

    private var title: String {
        switch scene {
        case .hero: "今天中午吃什麼\n一抽就決定"
        case .filters: "依預算、地點與類型\n快速縮小範圍"
        case .reroll: "不想吃這個？\n立刻換一個"
        case .favorites: "把想再吃一次的午餐\n先收藏起來"
        case .manage: "建立自己的台灣午餐清單"
        }
    }

    private var subtitle: String {
        switch scene {
        case .hero: "快速幫你從常吃清單裡選出今天的午餐"
        case .filters: "公司附近、住家附近、商圈都能分開設定"
        case .reroll: "保留隨機感，也保留反悔的自由"
        case .favorites: "常吃店家、愛吃品項，之後更快找到"
        case .manage: "便當、麵類、滷肉飯、超商、早餐店都能自訂"
        }
    }

    private func topBar(title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.ink)
            Spacer()
        }
    }

    private func statsRow(values: [(String, String)]) -> some View {
        HStack(spacing: 14) {
            ForEach(values, id: \.0) { value, label in
                VStack(alignment: .leading, spacing: 4) {
                    Text(value)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                    Text(label)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppTheme.muted)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(.white.opacity(0.86))
                )
            }
        }
    }

    private func heroCard(name: String, chips: [String], note: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("今日命運午餐")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.8))
            Text(name)
                .font(.system(size: 38, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
            HStack(spacing: 8) {
                ForEach(chips, id: \.self) { chip in
                    Text(chip)
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.white.opacity(0.88))
                        .foregroundStyle(AppTheme.ink)
                        .clipShape(Capsule())
                }
            }
            Text(note)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.88))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(AppTheme.hero)
        )
    }

    private func primaryButton(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 22, weight: .bold, design: .rounded))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(AppTheme.ink)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private func secondaryButtons(left: String, right: String) -> some View {
        HStack(spacing: 14) {
            smallButton(left, fill: .white.opacity(0.88), foreground: AppTheme.ink)
            smallButton(right, fill: AppTheme.accent, foreground: .white)
        }
    }

    private func smallButton(_ title: String, fill: Color, foreground: Color) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(fill)
            .foregroundStyle(foreground)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func filterGroup(title: String, items: [String], selected: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.ink)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        Text(item)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(index == selected ? AppTheme.ink : .white.opacity(0.9))
                            .foregroundStyle(index == selected ? .white : AppTheme.ink)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white.opacity(0.76))
        )
    }

    private func infoRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            Spacer()
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.accent)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white.opacity(0.76))
        )
    }

    private func actionCard(icon: String, title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(AppTheme.accent)
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Text(body)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(AppTheme.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white.opacity(0.82))
        )
    }

    private func favoriteCard(name: String, detail: String, note: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(name)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .lineLimit(1)
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundStyle(AppTheme.accent)
            }
            Text(detail)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(AppTheme.muted)
            Text(note)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(AppTheme.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white.opacity(0.84))
        )
    }

    private func sectionCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.ink)
            content()
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.white.opacity(0.76))
        )
    }

    private func formRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(AppTheme.muted)
            Spacer()
            Text(value)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(AppTheme.ink)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white.opacity(0.88))
        )
    }

    private func manageRow(name: String, detail: String, favorite: Bool) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                Text(detail)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(AppTheme.muted)
            }
            Spacer()
            if favorite {
                Image(systemName: "star.fill")
                    .foregroundStyle(AppTheme.accent)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white.opacity(0.88))
        )
    }
}

#Preview {
    AppStoreScreenshotView(scene: .hero)
}
