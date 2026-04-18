import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var container: AppContainer
    @StateObject var viewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    SearchField(text: $viewModel.query, placeholder: "Hat veya durak ara")

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        NavigationLink("Yakındaki Duraklar") {
                            NearbyStopsView(viewModel: NearbyStopsViewModel(locationService: container.locationService, stopRepository: container.stopRepository))
                        }
                        .buttonStyle(.borderedProminent)

                        NavigationLink("Favori Hatlar") {
                            FavoritesView(viewModel: FavoritesViewModel())
                        }
                        .buttonStyle(.bordered)

                        NavigationLink("Favori Duraklar") {
                            FavoritesView(viewModel: FavoritesViewModel())
                        }
                        .buttonStyle(.bordered)
                    }

                    if !viewModel.recentItems.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Son Görüntülenenler").font(.headline)
                            ForEach(viewModel.recentItems, id: \.self) { item in
                                Text(item).padding(.vertical, 2)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }
            .navigationTitle("ESHOT Saatleri")
        }
    }
}
