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
}
