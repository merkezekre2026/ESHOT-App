import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView(viewModel: HomeViewModel())
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house")
                }

            LineSearchView(viewModel: LineSearchViewModel())
                .tabItem {
                    Label("Hatlar", systemImage: "bus")
                }

            StopSearchView(viewModel: StopSearchViewModel())
                .tabItem {
                    Label("Duraklar", systemImage: "mappin.circle")
                }

            FavoritesView(viewModel: FavoritesViewModel())
                .tabItem {
                    Label("Favoriler", systemImage: "star")
                }
        }
    }
}
