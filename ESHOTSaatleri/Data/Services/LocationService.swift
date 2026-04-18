import Foundation
import CoreLocation

protocol LocationServicing: AnyObject {
    var authorizationStatus: CLAuthorizationStatus { get }
    func requestPermission()
    func currentLocation() async throws -> CLLocation
}

final class LocationService: NSObject, LocationServicing, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocation, Error>?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    var authorizationStatus: CLAuthorizationStatus { manager.authorizationStatus }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func currentLocation() async throws -> CLLocation {
        manager.requestLocation()
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            continuation?.resume(returning: location)
            continuation = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}
