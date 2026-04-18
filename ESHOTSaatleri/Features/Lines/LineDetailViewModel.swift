import Foundation

@MainActor
final class LineDetailViewModel: ObservableObject {
    @Published var stops: [BusStop] = []
    @Published var timetable: [StopTime] = []
    @Published var state: ViewState = .idle

    let line: BusLine

    init(line: BusLine) {
        self.line = line
    }

    func load(repository: RouteRepository) async {
        state = .loading
        do {
            async let stops = repository.stops(for: line.id)
            async let times = repository.timetable(for: line.id)
            self.stops = try await stops
            self.timetable = try await times
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
