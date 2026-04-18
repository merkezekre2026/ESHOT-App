import Foundation

final class DefaultRouteRepository: RouteRepository {
    private let gtfsService: GTFSServicing
    private let timetableService: TimetableServicing

    init(gtfsService: GTFSServicing, timetableService: TimetableServicing) {
        self.gtfsService = gtfsService
        self.timetableService = timetableService
    }

    func refreshIfNeeded() async throws {
        try await gtfsService.refreshIfNeeded(maxAgeHours: 24)
    }

    func searchLines(query: String) async throws -> [BusLine] {
        let normalized = query.normalizedForSearch
        return try await gtfsService.routes().filter {
            $0.code.normalizedForSearch.contains(normalized) ||
            $0.title.normalizedForSearch.contains(normalized)
        }
    }

    func stops(for lineID: String) async throws -> [BusStop] {
        try await gtfsService.routeStops(routeID: lineID)
    }

    func timetable(for lineID: String) async throws -> [StopTime] {
        try await timetableService.timetable(for: lineID)
    }
}
