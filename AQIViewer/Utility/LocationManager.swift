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
        
        lastLocation = location
        locationManager.stopUpdatingLocation()
        print(#function, location)
    }
    
    func geocode(city: String, state: String) async throws -> CLLocationCoordinate2D {
        let address = "\(city), \(state)"
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.geocodeAddressString(address)
        
        guard let location = placemarks.first?.location else {
            throw AQIError.invalidResponse
        }
        
        return location.coordinate
        
//        if let coordinate = location.coo
//        geocoder.geocodeAddressString(address) { (placemarks, error) in
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//            

//            
//            let coordinate = location.coordinate
//            completion(coordinate, nil)
//        }
    }
}
