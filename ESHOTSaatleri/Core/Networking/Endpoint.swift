import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

struct Endpoint {
    let url: URL
    let method: HTTPMethod
    var headers: [String: String] = [:]

    init(url: URL, method: HTTPMethod = .get, headers: [String: String] = [:]) {
        self.url = url
        self.method = method
        self.headers = headers
    }
}

enum AppEndpoint {
    // NOTE: Replace with the latest official URLs from İzmir Open Data / ESHOT portals.
    static let gtfsZip = URL(string: "https://acikveri.bizizmir.com/dataset/eshot-gtfs.zip")!
    static let busStopsCsv = URL(string: "https://acikveri.bizizmir.com/dataset/otobus-duraklari.csv")!
    static let movementScheduleCsv = URL(string: "https://acikveri.bizizmir.com/dataset/otobus-hareket-saatleri.csv")!
    static let approachingByStopBase = URL(string: "https://openapi.izmir.bel.tr/api/eshot/duraga-yaklasan-otobusler")!
}
