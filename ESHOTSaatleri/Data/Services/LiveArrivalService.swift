import Foundation

protocol LiveArrivalServicing {
    func arrivals(stopCode: String) async throws -> [LiveArrival]
}

final class LiveArrivalService: LiveArrivalServicing {
    private let networkManager: NetworkManaging

    init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    func arrivals(stopCode: String) async throws -> [LiveArrival] {
        var components = URLComponents(url: AppEndpoint.approachingByStopBase, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "stopId", value: stopCode)]

        guard let url = components?.url else { return [] }

        do {
            let data = try await networkManager.fetchData(from: Endpoint(url: url))
            let decoded = try JSONDecoder().decode([LiveArrivalDTO].self, from: data)
            return decoded.enumerated().map { idx, dto in
                LiveArrival(
                    id: "\(dto.hatNo)-\(idx)",
                    lineCode: dto.hatNo,
                    destination: dto.hatAdi,
                    minutes: dto.dakika,
                    plate: dto.plaka
                )
            }
        } catch {
            // Graceful degradation for offline or unavailable live endpoint.
            return []
        }
    }
}
