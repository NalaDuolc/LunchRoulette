import SwiftUI

struct ManageLunchView: View {
    let store: LunchStore

    @State private var newName = ""
    @State private var selectedCategory: LunchCategory = .bento
    @State private var selectedPriceTier: PriceTier = .standard
    @State private var selectedArea: LunchArea = .office
    @State private var isDeliveryFriendly = false
    @State private var notes = ""

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            List {
                Section {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("新增午餐選項")
                            .font(.headline)
                        TextField("例如：排骨便當", text: $newName)
                        Picker("類型", selection: $selectedCategory) {
                            ForEach(LunchCategory.allCases) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        Picker("預算", selection: $selectedPriceTier) {
                            ForEach(PriceTier.allCases) { tier in
                                Text(tier.rawValue).tag(tier)
                            }
                        }
                        Picker("地點", selection: $selectedArea) {
                            ForEach(LunchArea.allCases) { area in
                                Text(area.rawValue).tag(area)
                            }
                        }
                        Toggle("可外送", isOn: $isDeliveryFriendly)
                        TextField("備註，例如：排隊快、湯很讚", text: $notes, axis: .vertical)

                        Button("加入清單") {
                            store.addOption(
                                name: newName,
                                category: selectedCategory,
                                priceTier: selectedPriceTier,
                                area: selectedArea,
                                isDeliveryFriendly: isDeliveryFriendly,
                                notes: notes
                            )
                            resetForm()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(.white)
                        .padding(.vertical, 12)
                        .background(AppTheme.ink)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .listRowBackground(Color.white.opacity(0.82))
                }

                Section("目前選項") {
                    ForEach(store.options) { option in
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 8) {
                                    Text(option.name)
                                        .font(.headline)
                                    if option.isFavorite {
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(AppTheme.accent)
                                    }
                                }
                                Text("\(option.category.rawValue) ・ \(option.priceTier.rawValue) ・ \(option.area.rawValue)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                if !option.notes.isEmpty {
                                    Text(option.notes)
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            Button {
                                store.toggleFavorite(for: option.id)
                            } label: {
                                Image(systemName: option.isFavorite ? "star.fill" : "star")
                                    .foregroundStyle(option.isFavorite ? AppTheme.accent : AppTheme.muted)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.vertical, 6)
                        .listRowBackground(Color.white.opacity(0.74))
                    }
                    .onDelete(perform: store.deleteOptions)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("午餐清單")
    }

    private func resetForm() {
        newName = ""
        selectedCategory = .bento
        selectedPriceTier = .standard
        selectedArea = .office
        isDeliveryFriendly = false
        notes = ""
    }
}

#Preview {
    NavigationStack {
        ManageLunchView(store: LunchStore(preview: true))
    }
}
