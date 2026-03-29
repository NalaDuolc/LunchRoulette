import Foundation
import Observation

@MainActor
@Observable
final class LunchStore {
    private static let optionsKey = "lunch.options"
    private static let filtersKey = "lunch.filters"
    private static let historyKey = "lunch.history"

    var options: [LunchOption]
    var filters: LunchFilters
    var currentRecommendation: LunchOption?
    var recentHistory: [LunchHistory]

    private let defaults: UserDefaults

    init(preview: Bool = false, defaults: UserDefaults = .standard) {
        self.defaults = defaults

        if preview {
            self.options = LunchOption.samples
            self.filters = .default
            self.currentRecommendation = LunchOption.samples[3]
            self.recentHistory = [
                LunchHistory(name: "雞腿便當", date: .now.addingTimeInterval(-86_400)),
                LunchHistory(name: "咖哩飯", date: .now.addingTimeInterval(-172_800))
            ]
            return
        }

        self.options = Self.load([LunchOption].self, key: Self.optionsKey, defaults: defaults) ?? LunchOption.samples
        self.filters = Self.load(LunchFilters.self, key: Self.filtersKey, defaults: defaults) ?? .default
        self.recentHistory = Self.load([LunchHistory].self, key: Self.historyKey, defaults: defaults) ?? []
        self.currentRecommendation = nil
    }

    var filteredOptions: [LunchOption] {
        options.filter { option in
            let matchesPrice = filters.selectedPriceTier == nil || option.priceTier == filters.selectedPriceTier
            let matchesCategory = filters.selectedCategory == nil || option.category == filters.selectedCategory
            let matchesArea = option.area == filters.selectedArea
            let matchesDelivery = !filters.deliveryOnly || option.isDeliveryFriendly
            let notTooRecent = !recentNames.contains(option.name)

            return matchesPrice && matchesCategory && matchesArea && matchesDelivery && notTooRecent
        }
    }

    var favoriteOptions: [LunchOption] {
        options
            .filter(\.isFavorite)
            .sorted { $0.name < $1.name }
    }

    var acceptedCount: Int {
        recentHistory.count
    }

    var recentNames: Set<String> {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        return Set(
            recentHistory.compactMap { entry in
                guard let dayDiff = calendar.dateComponents([.day], from: calendar.startOfDay(for: entry.date), to: today).day else {
                    return nil
                }

                return dayDiff < filters.avoidRecentDays ? entry.name : nil
            }
        )
    }

    func spin() {
        currentRecommendation = pickRandomOption(excluding: [])
    }

    func reroll() {
        let excluded = currentRecommendation.map { [$0.id] } ?? []
        currentRecommendation = pickRandomOption(excluding: excluded)
    }

    func acceptCurrentRecommendation() {
        guard let currentRecommendation else { return }
        addHistory(for: currentRecommendation)
    }

    func toggleFavorite(for optionID: LunchOption.ID) {
        guard let index = options.firstIndex(where: { $0.id == optionID }) else { return }
        options[index].isFavorite.toggle()
        if currentRecommendation?.id == optionID {
            currentRecommendation = options[index]
        }
        persistOptions()
    }

    func resetFilters() {
        filters = .default
        persistFilters()
    }

    func updateFilters(_ transform: (inout LunchFilters) -> Void) {
        transform(&filters)
        persistFilters()
    }

    func addOption(name: String, category: LunchCategory, priceTier: PriceTier, area: LunchArea, isDeliveryFriendly: Bool, notes: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        options.insert(
            LunchOption(
                name: trimmedName,
                category: category,
                priceTier: priceTier,
                area: area,
                isDeliveryFriendly: isDeliveryFriendly,
                isFavorite: false,
                notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
            ),
            at: 0
        )
        persistOptions()
    }

    func deleteOptions(at offsets: IndexSet) {
        options.remove(atOffsets: offsets)
        persistOptions()
    }

    private var fallbackOptions: [LunchOption] {
        options.filter { option in
            let matchesPrice = filters.selectedPriceTier == nil || option.priceTier == filters.selectedPriceTier
            let matchesCategory = filters.selectedCategory == nil || option.category == filters.selectedCategory
            let matchesArea = option.area == filters.selectedArea
            let matchesDelivery = !filters.deliveryOnly || option.isDeliveryFriendly

            return matchesPrice && matchesCategory && matchesArea && matchesDelivery
        }
    }

    private func pickRandomOption(excluding ids: [LunchOption.ID]) -> LunchOption? {
        let excludedIDs = Set(ids)
        let primaryPool = filteredOptions.filter { !excludedIDs.contains($0.id) }
        let fallbackPool = fallbackOptions.filter { !excludedIDs.contains($0.id) }
        let candidatePool = primaryPool.isEmpty ? fallbackPool : primaryPool

        return candidatePool.randomElement()
    }

    private func addHistory(for option: LunchOption) {
        recentHistory.insert(LunchHistory(name: option.name, date: .now), at: 0)
        recentHistory = Array(recentHistory.prefix(10))
        persistHistory()
    }

    private func persistOptions() {
        persist(options, key: Self.optionsKey)
    }

    private func persistFilters() {
        persist(filters, key: Self.filtersKey)
    }

    private func persistHistory() {
        persist(recentHistory, key: Self.historyKey)
    }

    private func persist<T: Encodable>(_ value: T, key: String) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(value) else { return }
        defaults.set(data, forKey: key)
    }

    private static func load<T: Decodable>(_ type: T.Type, key: String, defaults: UserDefaults) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(type, from: data)
    }
}

struct LunchHistory: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let date: Date

    init(id: UUID = UUID(), name: String, date: Date) {
        self.id = id
        self.name = name
        self.date = date
    }
}
