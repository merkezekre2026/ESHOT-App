import Foundation

@MainActor
final class StopSearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var stops: [BusStop] = []

    private var task: Task<Void, Never>?

    func search(repository: StopRepository) {
        task?.cancel()
        guard !query.isEmpty else {
            stops = []
            return
        }

        task = Task {
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            stops = (try? await repository.searchStops(query: query)) ?? []
        }
    }
}
