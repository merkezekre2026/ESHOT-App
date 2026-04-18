import Foundation

protocol NetworkManaging {
    func fetchData(from endpoint: Endpoint) async throws -> Data
}

final class NetworkManager: NetworkManaging {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchData(from endpoint: Endpoint) async throws -> Data {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw AppError.httpStatus(httpResponse.statusCode)
        }

        return data
    }
}
