import SwiftUI

struct AppView: View {
    let store: LunchStore

    var body: some View {
        TabView {
            NavigationStack {
                HomeView(store: store)
            }
            .tabItem {
                Label("今天吃什麼", systemImage: "fork.knife.circle.fill")
            }

            NavigationStack {
                ManageLunchView(store: store)
            }
            .tabItem {
                Label("午餐清單", systemImage: "square.and.pencil")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("設定", systemImage: "slider.horizontal.3")
            }
        }
        .tint(AppTheme.accent)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
    }
}

#Preview {
    AppView(store: LunchStore(preview: true))
}
