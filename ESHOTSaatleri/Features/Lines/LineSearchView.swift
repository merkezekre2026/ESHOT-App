import SwiftUI

struct LineSearchView: View {
    @EnvironmentObject private var container: AppContainer
    @StateObject var viewModel: LineSearchViewModel

    var body: some View {
        NavigationStack {
            VStack {
                SearchField(text: $viewModel.query, placeholder: "Hat numarası veya güzergah")
                    .padding(.horizontal)
                    .padding(.top, 8)

                List(viewModel.lines) { line in
                    NavigationLink {
                        LineDetailView(viewModel: LineDetailViewModel(line: line))
                    } label: {
                        VStack(alignment: .leading) {
                            Text(line.code).font(.headline)
                            Text(line.title).font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Hat Ara")
            .onChange(of: viewModel.query) { _, _ in
                viewModel.search(using: container.routeRepository)
            }
        }
    }
}
