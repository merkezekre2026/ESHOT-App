import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var lines: [FavoriteLineEntity] = []
    @Published var stops: [FavoriteStopEntity] = []

    func load(service: FavoritesServicing) {
        lines = (try? service.favoriteLines()) ?? []
        stops = (try? service.favoriteStops()) ?? []
    }
}
