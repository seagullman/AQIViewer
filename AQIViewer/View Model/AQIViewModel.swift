//
//  AQIViewModel.swift
//  AQIViewer
//
//  Created by Brad Siegel on 5/19/24.
//

import SwiftUI

enum Day {
    case yesterday
    case today
    case tomorrow
}

@Observable
class AQIViewModel {
    
    let locationManager = LocationManager()
    var alertItem: AlertItem?
    var aqiInfo: AQIInfo?
    var isLoading: Bool = false
    var searchText = ""
    
    func fetchAQIDataByLatLong() async {
        let lastLocationCoordinate = locationManager.lastLocation?.coordinate
        
        guard
            let lat = lastLocationCoordinate?.latitude,
            let long = lastLocationCoordinate?.longitude
        else { return }
        
        isLoading = true
        
        do {
            let response = try await NetworkManager.shared.fetchAQIDataBy(latitude: lat, longitude: long)
            aqiInfo = createAQIInfo(from: response)
        } catch {
            print("***** TODO: catch error for fetchAQIDataBy lat long")
            handleError(error: error)
        }
        isLoading = false
    }
    
    func fetchAQIDataBy(cityName: String) async {
        do {
            isLoading = true
            
            let response = try await NetworkManager.shared.fetchAQIDataBy(cityName: cityName)
            aqiInfo = createAQIInfo(from: response)
        } catch {
            handleError(error: error)
            print("***** TODO: catch error for fetchAQIDataBy(cityName")
        }
        isLoading = false
    }
    
    // MARK: Private functions
    
    private func handleError(error: Error) {
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
    
    private func createAQIInfo(from response: AQIResponse) -> AQIInfo {
        let yesterday = AQIMeasurements(
            o3: getPollutant(for: .yesterday, all: response.data.forecast.daily.o3)!,
            pm10: getPollutant(for: .yesterday, all: response.data.forecast.daily.pm10)!,
            pm25: getPollutant(for: .yesterday, all: response.data.forecast.daily.pm25)!
        )
        
        let current = AQIMeasurements(
            o3: getPollutant(for: .today, all: response.data.forecast.daily.o3)!,
            pm10: getPollutant(for: .today, all: response.data.forecast.daily.pm10)!,
            pm25: getPollutant(for: .today, all: response.data.forecast.daily.pm25)!
        )
        
        let tomorrow = AQIMeasurements(
            o3: getPollutant(for: .tomorrow, all: response.data.forecast.daily.o3)!,
            pm10: getPollutant(for: .tomorrow, all: response.data.forecast.daily.pm10)!,
            pm25: getPollutant(for: .tomorrow, all: response.data.forecast.daily.pm25)!
        )
        
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
    
    private func getPollutant(for day: Day, all: [Pollutant]) -> Pollutant? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = .current
        
        let calendar = Calendar.current
        
        switch day {
        case .yesterday:
            let yesterdayPollutant = all.filter { pollutant in
                guard let date = dateFormatter.date(from: pollutant.day) else {
                    return false
                }
                
                let targetDate = calendar.startOfDay(for: date)
                return calendar.isDateInYesterday(targetDate)
            }
            return yesterdayPollutant.first
        case .today:
            let todayPollutant = all.filter { pollutant in
                guard let date = dateFormatter.date(from: pollutant.day) else {
                    return false
                }
                
                let targetDate = calendar.startOfDay(for: date)
                return calendar.isDateInToday(targetDate)
            }
            return todayPollutant.first
        case .tomorrow:
            let tomorrowPollutant = all.filter { pollutant in
                guard let date = dateFormatter.date(from: pollutant.day) else {
                    return false
                }
                
                let targetDate = calendar.startOfDay(for: date)
                return calendar.isDateInTomorrow(targetDate)
            }
            return tomorrowPollutant.first
        }
    }
}
