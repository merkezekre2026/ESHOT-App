import SwiftUI
import MapKit

struct StopDetailView: View {
    @EnvironmentObject private var container: AppContainer
    @StateObject var viewModel: StopDetailViewModel

    var body: some View {
        List {
            Section("Durak") {
                Text("\(viewModel.stop.code) • \(viewModel.stop.name)")
            }

            Section("Yaklaşan Otobüsler") {
                if viewModel.arrivals.isEmpty {
                    Text("Canlı veri şu an yok")
                } else {
                    ForEach(viewModel.arrivals) { row in
                        HStack {
                            Text(row.lineCode).bold()
                            Text(row.destination)
                            Spacer()
                            Text("\(row.minutes) dk")
                        }
                    }
                }
            }

            Section("Bu Duraktan Geçen Hatlar") {
                ForEach(viewModel.lines) { line in
                    Text("\(line.code) • \(line.title)")
                }
            }

            Section("Harita") {
                Map(position: .constant(.region(.init(center: viewModel.stop.coordinate, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))))) {
                    Marker(viewModel.stop.name, coordinate: viewModel.stop.coordinate)
                }
                .frame(height: 220)
            }
        }
        .navigationTitle(viewModel.stop.name)
        .toolbar {
            Button {
                try? container.favoritesService.toggleStop(viewModel.stop)
            } label: { Image(systemName: "star") }
        }
        .task {
            await viewModel.load(repository: container.stopRepository)
            viewModel.startLiveRefresh(repository: container.stopRepository)
        }
        .onDisappear {
            viewModel.stopLiveRefresh()
        }
    }
}
