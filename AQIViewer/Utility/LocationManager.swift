//
//  LocationManager.swift
//  AQIViewer
//
//  Created by Brad Siegel on 5/19/24.
//

import Foundation
import CoreLocation

@Observable
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    var locationStatus: CLAuthorizationStatus?
    var lastLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func refreshLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        #if targetEnvironment(simulator)
            // Use hardcoded location if the app is running on simulator
            lastLocation = CLLocation(latitude: 35.994034, longitude: -78.898621)
        #else
            lastLocation = location
        #endif
        
        locationManager.stopUpdatingLocation()
    }
    
    func geocode(city: String, state: String) async throws -> CLLocationCoordinate2D {
        let address = "\(city), \(state)"
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.geocodeAddressString(address)
        
        guard let location = placemarks.first?.location else {
            throw AQIError.invalidResponse
        }
        
        return location.coordinate
    }
}
