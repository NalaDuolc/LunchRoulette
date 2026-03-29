import AppKit
import SwiftUI

enum ScreenshotScene: String, CaseIterable {
    case hero = "01-hero"
    case filters = "02-filters"
    case reroll = "03-reroll"
    case favorites = "04-favorites"
    case manage = "05-manage"

    var title: String {
        switch self {
        case .hero: "今天中午吃什麼\n一抽就決定"
        case .filters: "依預算、地點與類型\n快速縮小範圍"
        case .reroll: "不想吃這個？\n立刻換一個"
        case .favorites: "把想再吃一次的午餐\n先收藏起來"
        case .manage: "建立自己的台灣午餐清單"
        }
    }

    var subtitle: String {
        switch self {
        case .hero: "快速幫你從常吃清單裡選出今天的午餐"
        case .filters: "公司附近、住家附近、商圈都能分開設定"
        case .reroll: "保留隨機感，也保留反悔的自由"
        case .favorites: "常吃店家、愛吃品項，之後更快找到"
        case .manage: "便當、麵類、滷肉飯、超商、早餐店都能自訂"
        }
    }
}

enum Theme {
    static let bgTop = Color(red: 0.98, green: 0.85, blue: 0.73)
    static let bgBottom = Color(red: 0.98, green: 0.96, blue: 0.91)
    static let ink = Color(red: 0.14, green: 0.12, blue: 0.11)
    static let muted = Color(red: 0.43, green: 0.39, blue: 0.34)
    static let accent = Color(red: 0.92, green: 0.48, blue: 0.22)
    static let heroTop = Color(red: 0.27, green: 0.20, blue: 0.18)
    static let heroBottom = Color(red: 0.78, green: 0.39, blue: 0.17)
}

struct ScreenshotCanvas: View {
    let scene: ScreenshotScene

    var body: some View {
        card
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(colors: [Theme.bgTop, Theme.bgBottom], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            )
    }

    @ViewBuilder
    private var card: some View {
        switch scene {
        case .hero:
            shell { heroContent }
        case .filters:
            shell { filtersContent }
        case .reroll:
            shell { rerollContent }
        case .favorites:
            shell { favoritesContent }
        case .manage:
            shell { manageContent }
        }
    }

    private func shell<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("9:41")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                Spacer()
                HStack(spacing: 8) {
                    Image(systemName: "wifi")
                    Image(systemName: "battery.100")
                }
                .font(.system(size: 17, weight: .semibold))
            }
            .padding(.horizontal, 26)
            .padding(.top, 16)
            .padding(.bottom, 12)
            .background(Color.white.opacity(0.08))

            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .background(LinearGradient(colors: [Theme.bgTop, Theme.bgBottom], startPoint: .topLeading, endPoint: .bottomTrailing))
    }

    private var heroContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            topBar("今天吃什麼")
            statsRow([("18", "符合條件"), ("6", "已收藏"), ("12", "已決定")])
            heroCard(name: "韓式拌飯", chips: ["異國料理", "100-150", "商圈"], note: "想吃重口味時很適合，抽到就不用再猶豫。")
            primaryButton("幫我決定午餐")
            secondaryButtons("不想吃這個", "今天就吃這個")
            Spacer()
        }
        .padding(.horizontal, 34)
        .padding(.top, 18)
        .padding(.bottom, 34)
    }

    private var filtersContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            topBar("今天條件")
            heroCard(name: "先設定條件", chips: ["公司附近", "100-150", "便當"], note: "根據今天預算、地點和午餐類型，快速縮小範圍。")
            filterGroup("地點", ["公司附近", "住家附近", "商圈"], selected: 0)
            filterGroup("預算", ["不限", "100 內", "100-150", "150+"], selected: 2)
            filterGroup("類型", ["隨便都行", "便當", "麵類", "飯類"], selected: 1)
            infoRow("只看可外送", value: "開啟")
            infoRow("避免重複天數", value: "2 天")
            Spacer()
        }
        .padding(.horizontal, 34)
        .padding(.top, 18)
        .padding(.bottom, 34)
    }

    private var rerollContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            topBar("重抽也很快")
            heroCard(name: "雞腿便當", chips: ["便當", "100-150", "公司附近"], note: "如果今天不想吃便當，也可以立刻換一個結果。")
            HStack(spacing: 16) {
                actionCard("arrow.triangle.2.circlepath", title: "不想吃這個", body: "一鍵重抽，不用重新設定。")
                actionCard("checkmark.seal.fill", title: "今天就吃這個", body: "確定後才會記錄到最近午餐。")
            }
            heroCard(name: "牛肉麵", chips: ["麵類", "150+", "商圈"], note: "重抽後馬上給你下一個更有感的選項。")
            Spacer()
        }
        .padding(.horizontal, 34)
        .padding(.top, 18)
        .padding(.bottom, 34)
    }

    private var favoritesContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            topBar("我的收藏")
            heroCard(name: "收藏想再吃一次的午餐", chips: ["快速回找", "常吃店家", "不怕忘記"], note: "看到喜歡的選項就點星星，下次更快決定。")
            HStack(spacing: 16) {
                favoriteCard("雞腿便當", detail: "便當 ・ 100-150", note: "白飯配三樣菜，穩定不踩雷")
                favoriteCard("咖哩飯", detail: "飯類 ・ 100-150", note: "濃郁又有飽足感")
            }
            HStack(spacing: 16) {
                favoriteCard("韓式拌飯", detail: "異國料理 ・ 100-150", note: "想吃重口味時很適合")
                favoriteCard("鹽水雞", detail: "清爽類 ・ 100-150", note: "可以客製配菜，吃起來沒負擔")
            }
            Spacer()
        }
        .padding(.horizontal, 34)
        .padding(.top, 18)
        .padding(.bottom, 34)
    }

    private var manageContent: some View {
        VStack(alignment: .leading, spacing: 22) {
            topBar("午餐清單")
            sectionCard("新增午餐選項") {
                VStack(spacing: 12) {
                    formRow("名稱", value: "排骨便當")
                    formRow("類型", value: "便當")
                    formRow("預算", value: "100-150")
                    formRow("地點", value: "公司附近")
                    formRow("可外送", value: "是")
                    formRow("備註", value: "份量夠、出餐快")
                    primaryButton("加入清單")
                        .padding(.top, 8)
                }
            }
            sectionCard("目前選項") {
                VStack(spacing: 12) {
                    manageRow("雞腿便當", detail: "便當 ・ 100-150 ・ 公司附近", favorite: true)
                    manageRow("牛肉麵", detail: "麵類 ・ 150+ ・ 商圈", favorite: false)
                    manageRow("咖哩飯", detail: "飯類 ・ 100-150 ・ 商圈", favorite: true)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 34)
        .padding(.top, 18)
        .padding(.bottom, 34)
    }

    private func topBar(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.ink)
            Spacer()
        }
    }

    private func statsRow(_ values: [(String, String)]) -> some View {
        HStack(spacing: 14) {
            ForEach(Array(values.enumerated()), id: \.offset) { _, pair in
                VStack(alignment: .leading, spacing: 4) {
                    Text(pair.0)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                    Text(pair.1)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.muted)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(18)
                .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(Color.white.opacity(0.88)))
            }
        }
    }

    private func heroCard(name: String, chips: [String], note: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("今日命運午餐")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.84))
            Text(name)
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
            HStack(spacing: 8) {
                ForEach(chips, id: \.self) { chip in
                    Text(chip)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.9))
                        .foregroundStyle(Theme.ink)
                        .clipShape(Capsule())
                }
            }
            Text(note)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(LinearGradient(colors: [Theme.heroTop, Theme.heroBottom], startPoint: .topLeading, endPoint: .bottomTrailing))
        )
    }

    private func primaryButton(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 22, weight: .bold, design: .rounded))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Theme.ink)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private func secondaryButtons(_ left: String, _ right: String) -> some View {
        HStack(spacing: 14) {
            smallButton(left, fill: Color.white.opacity(0.9), foreground: Theme.ink)
            smallButton(right, fill: Theme.accent, foreground: .white)
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

    private func filterGroup(_ title: String, _ items: [String], selected: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.ink)
            HStack(spacing: 10) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    Text(item)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(index == selected ? Theme.ink : Color.white.opacity(0.9))
                        .foregroundStyle(index == selected ? .white : Theme.ink)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(18)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(Color.white.opacity(0.78)))
    }

    private func infoRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            Spacer()
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.accent)
        }
        .padding(18)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(Color.white.opacity(0.78)))
    }

    private func actionCard(_ icon: String, title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Theme.accent)
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Text(body)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(Color.white.opacity(0.84)))
    }

    private func favoriteCard(_ name: String, detail: String, note: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(name)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .lineLimit(1)
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundStyle(Theme.accent)
            }
            Text(detail)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.muted)
            Text(note)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24, style: .continuous).fill(Color.white.opacity(0.84)))
    }

    private func sectionCard<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.ink)
            content()
        }
        .padding(22)
        .background(RoundedRectangle(cornerRadius: 28, style: .continuous).fill(Color.white.opacity(0.78)))
    }

    private func formRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.muted)
            Spacer()
            Text(value)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.ink)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.white.opacity(0.9)))
    }

    private func manageRow(_ name: String, detail: String, favorite: Bool) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                Text(detail)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.muted)
            }
            Spacer()
            if favorite {
                Image(systemName: "star.fill")
                    .foregroundStyle(Theme.accent)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.white.opacity(0.9)))
    }
}

@MainActor
func exportScreenshots(to directory: URL) throws {
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

    let size = CGSize(width: 1284, height: 2778)
    for scene in ScreenshotScene.allCases {
        let view = ScreenshotCanvas(scene: scene)
            .frame(width: size.width, height: size.height)

        let renderer = ImageRenderer(content: view)
        renderer.scale = 1
        renderer.isOpaque = true
        renderer.proposedSize = ProposedViewSize(size)

        guard let nsImage = renderer.nsImage,
              let tiffData = nsImage.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            throw NSError(domain: "ScreenshotExport", code: 1)
        }

        let fileURL = directory.appendingPathComponent("\(scene.rawValue).png")
        try pngData.write(to: fileURL)
        print("Wrote \(fileURL.path)")
    }
}

let outputPath = CommandLine.arguments.dropFirst().first ?? "/Users/gnauh/Documents/APP/app-store-screenshots/6.5-inch-clean"

do {
    try MainActor.assumeIsolated {
        try exportScreenshots(to: URL(fileURLWithPath: outputPath))
    }
} catch {
    fputs("Failed to generate screenshots: \(error)\n", stderr)
    exit(1)
}
