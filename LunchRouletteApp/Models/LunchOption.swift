import Foundation

struct LunchOption: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var category: LunchCategory
    var priceTier: PriceTier
    var area: LunchArea
    var isDeliveryFriendly: Bool
    var isFavorite: Bool
    var notes: String

    init(
        id: UUID = UUID(),
        name: String,
        category: LunchCategory,
        priceTier: PriceTier,
        area: LunchArea,
        isDeliveryFriendly: Bool,
        isFavorite: Bool = false,
        notes: String
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.priceTier = priceTier
        self.area = area
        self.isDeliveryFriendly = isDeliveryFriendly
        self.isFavorite = isFavorite
        self.notes = notes
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case priceTier
        case area
        case isDeliveryFriendly
        case isFavorite
        case notes
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(LunchCategory.self, forKey: .category)
        priceTier = try container.decode(PriceTier.self, forKey: .priceTier)
        area = try container.decode(LunchArea.self, forKey: .area)
        isDeliveryFriendly = try container.decode(Bool.self, forKey: .isDeliveryFriendly)
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
        notes = try container.decode(String.self, forKey: .notes)
    }
}

enum LunchCategory: String, CaseIterable, Codable, Identifiable {
    case bento = "便當"
    case noodles = "麵類"
    case rice = "飯類"
    case hotpot = "鍋物"
    case vegetarian = "素食"
    case convenienceStore = "超商"
    case breakfast = "早餐店"
    case international = "異國料理"

    var id: String { rawValue }
}

enum PriceTier: String, CaseIterable, Codable, Identifiable {
    case budget = "100 內"
    case standard = "100-150"
    case premium = "150+"

    var id: String { rawValue }
}

enum LunchArea: String, CaseIterable, Codable, Identifiable {
    case office = "公司附近"
    case home = "住家附近"
    case businessDistrict = "商圈"

    var id: String { rawValue }
}

extension LunchOption {
    static let samples: [LunchOption] = [
        LunchOption(name: "雞腿便當", category: .bento, priceTier: .standard, area: .office, isDeliveryFriendly: true, isFavorite: true, notes: "白飯配三樣菜，穩定不踩雷"),
        LunchOption(name: "牛肉麵", category: .noodles, priceTier: .premium, area: .businessDistrict, isDeliveryFriendly: false, notes: "想吃熱湯就選它"),
        LunchOption(name: "滷肉飯", category: .rice, priceTier: .budget, area: .office, isDeliveryFriendly: true, notes: "快速解決，適合忙碌中午"),
        LunchOption(name: "韓式拌飯", category: .international, priceTier: .standard, area: .businessDistrict, isDeliveryFriendly: true, isFavorite: true, notes: "想吃重口味時很適合"),
        LunchOption(name: "鹽水雞", category: .vegetarian, priceTier: .standard, area: .office, isDeliveryFriendly: true, notes: "可以客製配菜，清爽一點"),
        LunchOption(name: "鍋燒意麵", category: .noodles, priceTier: .budget, area: .home, isDeliveryFriendly: false, notes: "下雨天很加分"),
        LunchOption(name: "便利商店健康餐盒", category: .convenienceStore, priceTier: .standard, area: .office, isDeliveryFriendly: false, notes: "趕時間的安全牌"),
        LunchOption(name: "咖哩飯", category: .rice, priceTier: .standard, area: .businessDistrict, isDeliveryFriendly: true, isFavorite: true, notes: "濃郁又有飽足感"),
        LunchOption(name: "小火鍋", category: .hotpot, priceTier: .premium, area: .home, isDeliveryFriendly: false, notes: "今天想吃熱一點的"),
        LunchOption(name: "鐵板麵加蛋", category: .breakfast, priceTier: .budget, area: .office, isDeliveryFriendly: true, notes: "懷舊又快速")
    ]
}
