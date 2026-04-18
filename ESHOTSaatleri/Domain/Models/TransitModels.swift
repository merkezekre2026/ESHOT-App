import Foundation
import CoreLocation

struct BusLine: Identifiable, Hashable {
    let id: String
    let code: String
    let title: String
    let direction: String?
}

struct BusStop: Identifiable, Hashable {
    let id: String
    let code: String
    let name: String
    let district: String?
    let coordinate: CLLocationCoordinate2D

    static func == (lhs: BusStop, rhs: BusStop) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct StopTime: Hashable {
    let tripID: String
    let stopID: String
    let arrival: String
    let departure: String
    let sequence: Int
}

struct TripSchedule: Hashable {
    let tripID: String
    let routeID: String
    let headsign: String?
    let serviceID: String
}

struct LiveArrival: Identifiable, Hashable {
    let id: String
    let lineCode: String
    let destination: String
    let minutes: Int
    let plate: String?
}

struct NearbyStop: Identifiable {
    let id: String
    let stop: BusStop
    let distanceMeters: CLLocationDistance

    var walkingMinutesEstimate: Int {
        max(1, Int((distanceMeters / 75.0).rounded()))
    }
}
