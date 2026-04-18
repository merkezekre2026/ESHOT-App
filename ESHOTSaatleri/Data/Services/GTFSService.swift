import Foundation
import ZIPFoundation
import CoreLocation

protocol GTFSServicing {
    func refreshIfNeeded(maxAgeHours: Int) async throws
    func routes() async throws -> [BusLine]
    func stops() async throws -> [BusStop]
    func stopTimes(for routeID: String) async throws -> [StopTime]
    func routeStops(routeID: String) async throws -> [BusStop]
}

final class GTFSService: GTFSServicing {
    private let networkManager: NetworkManaging
    private let parser: GTFSParsing
    private let cache: DatasetCaching

    private var routesCache: [BusLine] = []
    private var stopsCache: [BusStop] = []

    init(networkManager: NetworkManaging, parser: GTFSParsing, cache: DatasetCaching) {
        self.networkManager = networkManager
        self.parser = parser
        self.cache = cache
    }

    func refreshIfNeeded(maxAgeHours: Int = 24) async throws {
        let key = "eshot_gtfs.zip"
        let shouldRefresh: Bool = {
            guard let last = cache.lastModified(for: key) else { return true }
            return Date().timeIntervalSince(last) > Double(maxAgeHours) * 3600
        }()

        if shouldRefresh {
            let data = try await networkManager.fetchData(from: Endpoint(url: AppEndpoint.gtfsZip))
            try cache.save(data: data, key: key)
        }
        try await loadGTFSFromCache()
    }

    func routes() async throws -> [BusLine] {
        if routesCache.isEmpty { try await loadGTFSFromCache() }
        return routesCache
    }

    func stops() async throws -> [BusStop] {
        if stopsCache.isEmpty { try await loadGTFSFromCache() }
        return stopsCache
    }

    func stopTimes(for routeID: String) async throws -> [StopTime] {
        _ = routeID
        // Production note: parse trips.txt + stop_times.txt mapping route->trip->stop_times.
        return []
    }

    func routeStops(routeID: String) async throws -> [BusStop] {
        let lineStops = try await stops()
        // Production note: build ordered route stop list via stop_times sequence.
        return Array(lineStops.prefix(30))
    }

    private func loadGTFSFromCache() async throws {
        guard let zipData = try cache.loadData(for: "eshot_gtfs.zip") else {
            throw AppError.noData
        }

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("eshot_gtfs.zip")
        try zipData.write(to: tempURL, options: .atomic)
        let extractURL = FileManager.default.temporaryDirectory.appendingPathComponent("eshot_gtfs_extracted", isDirectory: true)
        try? FileManager.default.removeItem(at: extractURL)
        try FileManager.default.createDirectory(at: extractURL, withIntermediateDirectories: true)

        guard let archive = Archive(url: tempURL, accessMode: .read) else {
            throw AppError.decodingError("GTFS ZIP açılamadı")
        }

        for entry in archive {
            let fileURL = extractURL.appendingPathComponent(entry.path)
            try archive.extract(entry, to: fileURL)
        }

        let routesData = try Data(contentsOf: extractURL.appendingPathComponent("routes.txt"))
        let stopsData = try Data(contentsOf: extractURL.appendingPathComponent("stops.txt"))

        let routeRows = try parser.parseCSV(routesData)
        self.routesCache = routeRows.compactMap { row in
            guard let id = row["route_id"], let code = row["route_short_name"], let title = row["route_long_name"] else { return nil }
            return BusLine(id: id, code: code, title: title, direction: nil)
        }

        let stopRows = try parser.parseCSV(stopsData)
        self.stopsCache = stopRows.compactMap { row in
            guard
                let id = row["stop_id"],
                let code = row["stop_code"],
                let name = row["stop_name"],
                let latString = row["stop_lat"],
                let lonString = row["stop_lon"],
                let lat = Double(latString),
                let lon = Double(lonString)
            else { return nil }

            return BusStop(id: id, code: code, name: name, district: nil, coordinate: .init(latitude: lat, longitude: lon))
        }
    }
}
