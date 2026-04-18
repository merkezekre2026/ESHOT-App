import SwiftUI

struct LineDetailView: View {
    @EnvironmentObject private var container: AppContainer
    @StateObject var viewModel: LineDetailViewModel

    var body: some View {
        List {
            Section("Duraklar") {
                ForEach(viewModel.stops) { stop in
                    Text("\(stop.code) • \(stop.name)")
                }
            }

            Section("Sefer Saatleri") {
                if viewModel.timetable.isEmpty {
                    Text("Saat bilgisi bulunamadı")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.timetable, id: \.self) { row in
                        HStack {
                            Text(row.departure)
                            Spacer()
                            Text("Durak #\(row.stopID)").foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("\(viewModel.line.code)")
        .toolbar {
            Button {
                try? container.favoritesService.toggleLine(viewModel.line)
            } label: { Image(systemName: "star") }
        }
        .task {
            await viewModel.load(repository: container.routeRepository)
        }
        .refreshable {
            await viewModel.load(repository: container.routeRepository)
        }
    }
}
