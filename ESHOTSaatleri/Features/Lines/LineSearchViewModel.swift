import Foundation

@MainActor
final class LineSearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var lines: [BusLine] = []
    @Published var state: ViewState = .idle

    private var searchTask: Task<Void, Never>?

    func search(using repository: RouteRepository) {
        searchTask?.cancel()
        guard !query.isEmpty else {
            lines = []
            state = .idle
            return
        }

        searchTask = Task {
            state = .loading
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            do {
                let result = try await repository.searchLines(query: query)
                lines = result
                state = result.isEmpty ? .empty("Sonuç bulunamadı") : .loaded
            } catch {
                state = .failed(error.localizedDescription)
            }
        }
    }
}
