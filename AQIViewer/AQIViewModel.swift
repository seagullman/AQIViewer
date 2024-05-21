//
//  AQIViewModel.swift
//  AQIViewer
//
//  Created by Brad Siegel on 5/19/24.
//

import SwiftUI

@Observable
class AQIViewModel {
    
    let locationManager = LocationManager()
    var aqiInfo: AQIInfo?
    var isLoading: Bool = false
    var alertItem: AlertItem?
    
    func fetchAQIDataByLatLong() async {
        let lastLocationCoordinate = locationManager.lastLocation?.coordinate
        
        guard
            let lat = lastLocationCoordinate?.latitude,
            let long = lastLocationCoordinate?.longitude
        else { return }
        
        isLoading.toggle()
        
        do {
            let response = try await NetworkManager.shared.fetchAQIDataBy(latitude: lat, longitude: long)
            aqiInfo = createAQIInfo(from: response)
        } catch {
            print("***** TODO: catch error for fetchAQIDataBy lat long")
            let alertItem: AlertItem
            if let aqiError = error as? AQIError {
                switch aqiError {
                case .invalidUrl:
                    alertItem = AlertContext.invalidUrl
                case .invalidResponse:
                    alertItem = AlertContext.invalidResponse
                case .invalidData:
                    alertItem = AlertContext.invalidData
                }
            } else {
                alertItem = AlertContext.invalidResponse
            }
            self.alertItem = alertItem
        }
        isLoading.toggle()
    }
    
    func fetchAQIDataBy(cityName: String) async {
        do {
            isLoading.toggle()
            
            let response = try await NetworkManager.shared.fetchAQIDataBy(cityName: cityName)
            aqiInfo = createAQIInfo(from: response)
        } catch {
            print(error)
            print("***** TODO: catch error for fetchAQIDataBy(cityName")
        }
        isLoading.toggle()
    }
    
    // MARK: Private functions
    
    private func createAQIInfo(from response: AQIResponse) -> AQIInfo {
//        let dateFormatterNew = DateFormatter()
//                dateFormatterNew.dateFormat = "yyyy-MM-dd"
//        
//        let o3Yesterday = response.data.forecast.daily.o3.filter { pollutant in
//            let dateString = pollutant.day
//
//        }
        let yesterday = AQIMeasurements(o3: response.data.forecast.daily.o3[1], pm10: response.data.forecast.daily.pm10[1], pm25: response.data.forecast.daily.pm25[1])
        
        let current = AQIMeasurements(o3: response.data.forecast.daily.o3[2], pm10: response.data.forecast.daily.pm10[2], pm25: response.data.forecast.daily.pm25[2])
        
        let tomorrow = AQIMeasurements(o3: response.data.forecast.daily.o3[3], pm10: response.data.forecast.daily.pm10[3], pm25: response.data.forecast.daily.pm25[3])
        
        let info = AQIInfo(
            name: response.data.city.name,
            latitude: response.data.city.geo[0],
            longitude: response.data.city.geo[1],
            aqi: response.data.aqi,
            current: current,
            yesterday: yesterday,
            tomorrow: tomorrow
        )
        
        return info
    }
}
