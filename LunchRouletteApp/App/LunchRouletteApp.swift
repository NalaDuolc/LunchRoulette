import SwiftUI

@main
struct LunchRouletteApp: App {
    @State private var store = LunchStore()
    private let screenshotScene = AppStoreScreenshotScene()

    var body: some Scene {
        WindowGroup {
            if let screenshotScene {
                AppStoreScreenshotView(scene: screenshotScene)
            } else {
                AppView(store: store)
            }
        }
    }
}
