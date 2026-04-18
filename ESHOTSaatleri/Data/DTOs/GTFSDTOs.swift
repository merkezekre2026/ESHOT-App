import Foundation

struct GTFSRouteDTO: Decodable {
    let routeID: String
    let routeShortName: String
    let routeLongName: String

    enum CodingKeys: String, CodingKey {
        case routeID = "route_id"
        case routeShortName = "route_short_name"
        case routeLongName = "route_long_name"
    }
}

struct GTFSStopDTO: Decodable {
    let stopID: String
    let stopCode: String
    let stopName: String
    let stopLat: Double
    let stopLon: Double

    enum CodingKeys: String, CodingKey {
        case stopID = "stop_id"
        case stopCode = "stop_code"
        case stopName = "stop_name"
        case stopLat = "stop_lat"
        case stopLon = "stop_lon"
    }
}

struct LiveArrivalDTO: Decodable {
    let hatNo: String
    let hatAdi: String
    let dakika: Int
    let plaka: String?
}
