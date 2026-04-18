import Foundation
import CoreLocation

final class DefaultStopRepository: StopRepository {
    private let stopsService: StopsServicing
    private let gtfsService: GTFSServicing
    private let liveArrivalService: LiveArrivalServicing

    init(stopsService: StopsServicing, gtfsService: GTFSServicing, liveArrivalService: LiveArrivalServicing) {
        self.stopsService = stopsService
        self.gtfsService = gtfsService
        self.liveArrivalService = liveArrivalService
    }

    func refreshIfNeeded() async throws {
        try await stopsService.refreshIfNeeded(maxAgeHours: 24)
    }

    func searchStops(query: String) async throws -> [BusStop] {
        let normalized = query.normalizedForSearch
        let all = try await stopsService.stops()
        guard !normalized.isEmpty else { return all }
        return all.filter {
            $0.code.normalizedForSearch.contains(normalized) ||
            $0.name.normalizedForSearch.contains(normalized)
        }
    }

    func lines(for stopID: String) async throws -> [BusLine] {
        // Simplified fallback: infer by checking line stop lists.
        let routes = try await gtfsService.routes()
        var output: [BusLine] = []
        for route in routes {
            let stops = try await gtfsService.routeStops(routeID: route.id)
            if stops.contains(where: { $0.id == stopID }) {
                output.append(route)
            }
        }
        return output
    }

    func liveArrivals(stopCode: String) async throws -> [LiveArrival] {
        try await liveArrivalService.arrivals(stopCode: stopCode)
    }
}
