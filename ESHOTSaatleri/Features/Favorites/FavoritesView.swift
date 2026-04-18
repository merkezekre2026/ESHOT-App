import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var container: AppContainer
    @StateObject var viewModel: FavoritesViewModel

    var body: some View {
        List {
            Section("Favori Hatlar") {
                if viewModel.lines.isEmpty {
                    Text("Henüz favori hat yok")
                }
                ForEach(viewModel.lines) { line in
                    Text("\(line.lineCode) • \(line.lineTitle)")
                }
            }

            Section("Favori Duraklar") {
                if viewModel.stops.isEmpty {
                    Text("Henüz favori durak yok")
                }
                ForEach(viewModel.stops) { stop in
                    Text("\(stop.stopCode) • \(stop.stopName)")
                }
            }
        }
        .navigationTitle("Favoriler")
        .task {
            viewModel.load(service: container.favoritesService)
        }
    }
}
