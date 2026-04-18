import SwiftUI

struct StopSearchView: View {
    @EnvironmentObject private var container: AppContainer
    @StateObject var viewModel: StopSearchViewModel

    var body: some View {
        NavigationStack {
            VStack {
                SearchField(text: $viewModel.query, placeholder: "Durak kodu veya adı")
                    .padding(.horizontal)

                List(viewModel.stops) { stop in
                    NavigationLink {
                        StopDetailView(viewModel: StopDetailViewModel(stop: stop))
                    } label: {
                        VStack(alignment: .leading) {
                            Text("\(stop.code) • \(stop.name)")
                            if let district = stop.district {
                                Text(district).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Durak Ara")
            .onChange(of: viewModel.query) { _, _ in
                viewModel.search(repository: container.stopRepository)
            }
        }
    }
}
