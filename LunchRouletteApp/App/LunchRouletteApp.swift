import SwiftUI

@main
struct LunchRouletteApp: App {
    @State private var store = LunchStore()

    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}
