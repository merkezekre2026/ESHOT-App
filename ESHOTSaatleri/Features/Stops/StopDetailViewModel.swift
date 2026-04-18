import Foundation

@MainActor
final class StopDetailViewModel: ObservableObject {
    @Published var lines: [BusLine] = []
    @Published var arrivals: [LiveArrival] = []

    let stop: BusStop
    private var liveTask: Task<Void, Never>?

    init(stop: BusStop) {
        self.stop = stop
    }

    func load(repository: StopRepository) async {
        lines = (try? await repository.lines(for: stop.id)) ?? []
        arrivals = (try? await repository.liveArrivals(stopCode: stop.code)) ?? []
    }

    func startLiveRefresh(repository: StopRepository) {
        liveTask?.cancel()
        liveTask = Task {
            while !Task.isCancelled {
                arrivals = (try? await repository.liveArrivals(stopCode: stop.code)) ?? []
                try? await Task.sleep(for: .seconds(25))
            }
        }
    }

    func stopLiveRefresh() {
        liveTask?.cancel()
    }
}
