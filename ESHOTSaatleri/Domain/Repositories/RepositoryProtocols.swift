import Foundation

protocol RouteRepository {
    func refreshIfNeeded() async throws
    func searchLines(query: String) async throws -> [BusLine]
    func stops(for lineID: String) async throws -> [BusStop]
    func timetable(for lineID: String) async throws -> [StopTime]
}

protocol StopRepository {
    func refreshIfNeeded() async throws
    func searchStops(query: String) async throws -> [BusStop]
    func lines(for stopID: String) async throws -> [BusLine]
    func liveArrivals(stopCode: String) async throws -> [LiveArrival]
}
