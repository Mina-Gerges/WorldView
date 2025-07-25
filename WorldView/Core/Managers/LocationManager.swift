//
//  LocationManager.swift
//  WorldView
//
//  Created by Mina Gerges on 24/07/2025.
//

import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // MARK: - Properties
    static let shared = LocationManager()
    private let manager = CLLocationManager()
    @Published var country: String?

    // MARK: - Initializer
    override init() {
        super.init()
        manager.delegate = self
    }

    // MARK: - Methods
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.country = "Egypt"
            }
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(location) { placemarks, error in
            if let countryName = placemarks?.first?.country {
                DispatchQueue.main.async {
                    self.country = countryName
                }
            } else {
                DispatchQueue.main.async {
                    self.country = "Egypt"
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.country = "Egypt"
        }
    }
}
