import Foundation
import CoreLocation

@MainActor
final class NearbyStopsViewModel: ObservableObject {
    @Published var nearby: [NearbyStop] = []
    @Published var state: ViewState = .idle

    private let locationService: LocationServicing
    private let stopRepository: StopRepository

    init(locationService: LocationServicing, stopRepository: StopRepository) {
        self.locationService = locationService
        self.stopRepository = stopRepository
    }

    func load() async {
        state = .loading
        do {
            locationService.requestPermission()
            let current = try await locationService.currentLocation()
            let allStops = try await stopRepository.searchStops(query: "")
            nearby = allStops
                .map { stop in
                    NearbyStop(
                        id: stop.id,
                        stop: stop,
                        distanceMeters: current.distance(from: CLLocation(latitude: stop.coordinate.latitude, longitude: stop.coordinate.longitude))
                    )
                }
                .sorted(by: { $0.distanceMeters < $1.distanceMeters })
                .prefix(25)
                .map { $0 }
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
