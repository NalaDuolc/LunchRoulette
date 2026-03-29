import Foundation

struct LunchFilters: Codable, Equatable {
    var selectedPriceTier: PriceTier?
    var selectedCategory: LunchCategory?
    var selectedArea: LunchArea = .office
    var deliveryOnly = false
    var avoidRecentDays = 2

    static let `default` = LunchFilters()
}
