import Foundation

protocol TimetableServicing {
    func timetable(for lineID: String) async throws -> [StopTime]
}

final class TimetableService: TimetableServicing {
    private let gtfsService: GTFSServicing
    private let stopsService: StopsServicing

    init(gtfsService: GTFSServicing, stopsService: StopsServicing) {
        self.gtfsService = gtfsService
        self.stopsService = stopsService
    }

    func timetable(for lineID: String) async throws -> [StopTime] {
        _ = try await stopsService.stops()
        // We prefer GTFS as source of truth, because it is normalized for route/trip/stop_time joins.
        return try await gtfsService.stopTimes(for: lineID)
    }
}
