import Foundation
import CoreLocation

protocol StopsServicing {
    func refreshIfNeeded(maxAgeHours: Int) async throws
    func stops() async throws -> [BusStop]
}

final class StopsService: StopsServicing {
    private let networkManager: NetworkManaging
    private let cache: DatasetCaching
    private var stopsCache: [BusStop] = []

    init(networkManager: NetworkManaging, cache: DatasetCaching) {
        self.networkManager = networkManager
        self.cache = cache
    }

    func refreshIfNeeded(maxAgeHours: Int = 24) async throws {
        let key = "otobus_duraklari.csv"
        let shouldRefresh: Bool = {
            guard let last = cache.lastModified(for: key) else { return true }
            return Date().timeIntervalSince(last) > Double(maxAgeHours) * 3600
        }()

        if shouldRefresh {
            let data = try await networkManager.fetchData(from: Endpoint(url: AppEndpoint.busStopsCsv))
            try cache.save(data: data, key: key)
        }
    }

    func stops() async throws -> [BusStop] {
        if !stopsCache.isEmpty { return stopsCache }
        try await refreshIfNeeded(maxAgeHours: 24)

        guard let data = try cache.loadData(for: "otobus_duraklari.csv"),
              let raw = String(data: data, encoding: .utf8)
        else { throw AppError.noData }

        let rows = raw.split(whereSeparator: \ .isNewline).dropFirst()
        stopsCache = rows.compactMap { row in
            let c = row.split(separator: ";").map(String.init)
            guard c.count >= 5, let lat = Double(c[3]), let lon = Double(c[4]) else { return nil }
            return BusStop(id: c[0], code: c[1], name: c[2], district: c.count > 5 ? c[5] : nil, coordinate: .init(latitude: lat, longitude: lon))
        }
        return stopsCache
    }
}
