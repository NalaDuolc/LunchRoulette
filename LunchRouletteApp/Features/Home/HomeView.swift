import SwiftUI

struct HomeView: View {
    let store: LunchStore
    @State private var didJustAccept = false
    @State private var acceptedRecommendationID: LunchOption.ID?

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()
            decorativeBackdrop

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header

                    statsStrip

                    recommendationCard(recommendation: store.currentRecommendation)

                    actionPanel

                    filterPanel(store: store)

                    favoritesSection

                    recentSection(history: store.recentHistory)
                }
                .padding(20)
            }
        }
        .navigationTitle("今天吃什麼")
        .navigationBarTitleDisplayMode(.large)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("午餐不用再想")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(AppTheme.ink)
            Text("用更像產品版的方式幫你做決定。先抽，再收藏，真的不想吃就立刻換一個。")
                .font(.subheadline)
                .foregroundStyle(AppTheme.muted)
        }
    }

    private var statsStrip: some View {
        HStack(spacing: 12) {
            statCard(value: "\(store.filteredOptions.count)", label: "符合條件")
            statCard(value: "\(store.favoriteOptions.count)", label: "已收藏")
            statCard(value: "\(store.acceptedCount)", label: "已決定")
        }
    }

    @ViewBuilder
    private func recommendationCard(recommendation: LunchOption?) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("今日命運午餐")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.78))
                Spacer()
                if let recommendation {
                    favoriteButton(for: recommendation, foreground: .white)
                }
            }

            if let recommendation {
                VStack(alignment: .leading, spacing: 12) {
                    Text(recommendation.name)
                        .font(.system(size: 38, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)

                    HStack(spacing: 8) {
                        tag(recommendation.category.rawValue, foreground: AppTheme.ink, fill: .white.opacity(0.9))
                        tag(recommendation.priceTier.rawValue, foreground: AppTheme.ink, fill: AppTheme.cream)
                        tag(recommendation.area.rawValue, foreground: .white, fill: .white.opacity(0.16))
                    }

                    Text(recommendation.notes)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.84))

                    if didJustAccept {
                        Text("已加入最近午餐紀錄")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(AppTheme.cream)
                    }
                }
            } else {
                Text("按下按鈕，讓 App 幫你抽一頓午餐")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
                Text("如果篩選太嚴格，系統會自動放寬「最近吃過」限制，避免抽不到。")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.78))
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(AppTheme.hero)
                .shadow(color: AppTheme.accent.opacity(0.25), radius: 24, x: 0, y: 14)
        )
        .overlay(alignment: .topTrailing) {
            Image(systemName: "fork.knife")
                .font(.title2)
                .padding(16)
                .foregroundStyle(.white.opacity(0.24))
        }
    }

    private var actionPanel: some View {
        VStack(spacing: 12) {
            Button {
                didJustAccept = false
                acceptedRecommendationID = nil
                store.spin()
            } label: {
                Label("幫我決定午餐", systemImage: "sparkles")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.ink)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }

            HStack(spacing: 12) {
                Button {
                    didJustAccept = false
                    acceptedRecommendationID = nil
                    store.reroll()
                } label: {
                    Label("不想吃這個", systemImage: "arrow.triangle.2.circlepath")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white.opacity(0.86))
                        .foregroundStyle(AppTheme.ink)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .disabled(store.currentRecommendation == nil)

                Button {
                    store.acceptCurrentRecommendation()
                    didJustAccept = true
                    acceptedRecommendationID = store.currentRecommendation?.id
                } label: {
                    Label("今天就吃這個", systemImage: "checkmark.seal.fill")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .disabled(store.currentRecommendation == nil || acceptedRecommendationID == store.currentRecommendation?.id)
            }
        }
    }

    private func filterPanel(store: LunchStore) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("今天條件")
                    .font(.headline)
                Spacer()
                Button("重設") {
                    store.resetFilters()
                }
                .foregroundStyle(AppTheme.accent)
            }

            Picker("地點", selection: areaBinding(for: store)) {
                ForEach(LunchArea.allCases) { area in
                    Text(area.rawValue).tag(area)
                }
            }
            .pickerStyle(.segmented)

            VStack(alignment: .leading, spacing: 10) {
                Text("預算")
                    .font(.subheadline.weight(.semibold))
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        selectableChip("不限", isSelected: store.filters.selectedPriceTier == nil) {
                            store.updateFilters { $0.selectedPriceTier = nil }
                        }

                        ForEach(PriceTier.allCases) { tier in
                            selectableChip(tier.rawValue, isSelected: store.filters.selectedPriceTier == tier) {
                                store.updateFilters { $0.selectedPriceTier = tier }
                            }
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("類型")
                    .font(.subheadline.weight(.semibold))
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        selectableChip("隨便都行", isSelected: store.filters.selectedCategory == nil) {
                            store.updateFilters { $0.selectedCategory = nil }
                        }

                        ForEach(LunchCategory.allCases) { category in
                            selectableChip(category.rawValue, isSelected: store.filters.selectedCategory == category) {
                                store.updateFilters { $0.selectedCategory = category }
                            }
                        }
                    }
                }
            }

            Toggle("只看可外送", isOn: Binding(
                get: { store.filters.deliveryOnly },
                set: { newValue in
                    store.updateFilters { $0.deliveryOnly = newValue }
                }
            ))

            Stepper(
                "避免重複天數：\(store.filters.avoidRecentDays) 天",
                value: Binding(
                    get: { store.filters.avoidRecentDays },
                    set: { newValue in
                        store.updateFilters { $0.avoidRecentDays = newValue }
                    }
                ),
                in: 1...5
            )

            Text("目前符合條件：\(store.filteredOptions.count) 項")
                .font(.footnote)
                .foregroundStyle(AppTheme.muted)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white.opacity(0.72))
        )
    }

    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("我的收藏")
                    .font(.headline)
                Spacer()
                Text("\(store.favoriteOptions.count) 項")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(AppTheme.muted)
            }

            if store.favoriteOptions.isEmpty {
                Text("看到想再吃一次的店，就點星星收進收藏。")
                    .foregroundStyle(AppTheme.muted)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(store.favoriteOptions) { option in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(option.name)
                                        .font(.headline)
                                        .lineLimit(1)
                                    Spacer(minLength: 8)
                                    favoriteButton(for: option, foreground: AppTheme.accent)
                                }

                                Text("\(option.category.rawValue) ・ \(option.priceTier.rawValue)")
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.muted)

                                Text(option.notes)
                                    .font(.footnote)
                                    .foregroundStyle(AppTheme.ink)
                                    .lineLimit(2)
                            }
                            .padding(16)
                            .frame(width: 210, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .fill(.white.opacity(0.82))
                            )
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white.opacity(0.62))
        )
    }

    private func recentSection(history: [LunchHistory]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("最近吃過")
                .font(.headline)

            if history.isEmpty {
                Text("還沒有紀錄，抽第一餐吧。")
                    .foregroundStyle(.black.opacity(0.6))
            } else {
                ForEach(history.prefix(5)) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text(item.date.formatted(date: .abbreviated, time: .omitted))
                            .foregroundStyle(.black.opacity(0.55))
                    }
                    .font(.subheadline)
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white.opacity(0.65))
        )
    }

    private func statCard(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.ink)
            Text(label)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(AppTheme.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white.opacity(0.78))
        )
    }

    private func tag(_ text: String, foreground: Color = AppTheme.ink, fill: Color = AppTheme.accent.opacity(0.15)) -> some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .foregroundStyle(foreground)
            .background(fill)
            .clipShape(Capsule())
    }

    private func selectableChip(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .background(isSelected ? AppTheme.ink : .white.opacity(0.9))
                .foregroundStyle(isSelected ? .white : AppTheme.ink)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private func areaBinding(for store: LunchStore) -> Binding<LunchArea> {
        Binding(
            get: { store.filters.selectedArea },
            set: { newValue in
                store.updateFilters { $0.selectedArea = newValue }
            }
        )
    }

    private func favoriteButton(for option: LunchOption, foreground: Color) -> some View {
        Button {
            store.toggleFavorite(for: option.id)
        } label: {
            Image(systemName: option.isFavorite ? "star.fill" : "star")
                .font(.headline)
                .foregroundStyle(foreground)
                .padding(10)
                .background(.white.opacity(option.isFavorite ? 0.18 : 0.12))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(option.isFavorite ? "取消收藏" : "加入收藏")
    }

    private var decorativeBackdrop: some View {
        ZStack {
            Circle()
                .fill(AppTheme.accentSoft.opacity(0.18))
                .frame(width: 240, height: 240)
                .offset(x: 130, y: -250)
            Circle()
                .fill(.white.opacity(0.22))
                .frame(width: 180, height: 180)
                .offset(x: -140, y: -120)
        }
        .blur(radius: 2)
    }
}

#Preview {
    NavigationStack {
        HomeView(store: LunchStore(preview: true))
    }
}
