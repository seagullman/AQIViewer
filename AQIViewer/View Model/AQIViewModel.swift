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
    var isShowingDetailView = false
    var selectedCityState: CityState?
    
    func fetchAQIDataByLatLong(lat: Double? = nil, long: Double? = nil) async {
        let lastLocationCoordinate = locationManager.lastLocation?.coordinate
        
        if let lat, let long {
            isLoading = true
            
            do {
                let response = try await NetworkManager.shared.fetchAQIDataBy(latitude: lat, longitude: long)
                aqiInfo = createAQIInfo(from: response)
            } catch { handleError(error: error) }
            
            isLoading = false
        } else {
            guard
                let lat = lastLocationCoordinate?.latitude,
                let long = lastLocationCoordinate?.longitude
            else { return }
            
            isLoading = true
            
            do {
                let response = try await NetworkManager.shared.fetchAQIDataBy(latitude: lat, longitude: long)
                aqiInfo = createAQIInfo(from: response)
            } catch { handleError(error: error) }
            
            isLoading = false
        }
    }
    
    func fetchAQIDataBy(cityName: String, state: String) async {
        do {
            isLoading = true
            let coordinate = try await locationManager.geocode(city: cityName, state: state)
            Task { await self.fetchAQIDataByLatLong(lat: coordinate.latitude, long: coordinate.longitude) }
        } catch { handleError(error: error) }
        
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
    
    /**
     *  Create AQIInfo object from the AQIResponse. AQIInfo contains only what
     *  is needed to display on screen.
     */
    private func createAQIInfo(from response: AQIResponse) -> AQIInfo {
        let yesterday = AQIMeasurements(
            o3: getPollutant(for: .yesterday, pollutants: response.data.forecast.daily.o3),
            pm10: getPollutant(for: .yesterday, pollutants: response.data.forecast.daily.pm10),
            pm25: getPollutant(for: .yesterday, pollutants: response.data.forecast.daily.pm25)
        )
        
        let current = AQIMeasurements(
            o3: getPollutant(for: .today, pollutants: response.data.forecast.daily.o3),
            pm10: getPollutant(for: .today, pollutants: response.data.forecast.daily.pm10),
            pm25: getPollutant(for: .today, pollutants: response.data.forecast.daily.pm25)
        )
        
        let tomorrow = AQIMeasurements(
            o3: getPollutant(for: .tomorrow, pollutants: response.data.forecast.daily.o3),
            pm10: getPollutant(for: .tomorrow, pollutants: response.data.forecast.daily.pm10),
            pm25: getPollutant(for: .tomorrow, pollutants: response.data.forecast.daily.pm25)
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
    
    /**
     * Loops through all of the pollutants (from the forecast array) and retrieves
     * the corresponding pollutants for yesterday, today, tomorrow.
     */
    private func getPollutant(for day: Day, pollutants: [Pollutant]) -> Pollutant? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = .current
        
        let calendar = Calendar.current
        
        switch day {
        case .yesterday:
            let yesterdayPollutant = pollutants.filter { pollutant in
                guard let date = dateFormatter.date(from: pollutant.day) else {
                    return false
                }
                
                let targetDate = calendar.startOfDay(for: date)
                return calendar.isDateInYesterday(targetDate)
            }
            return yesterdayPollutant.first
        case .today:
            let todayPollutant = pollutants.filter { pollutant in
                guard let date = dateFormatter.date(from: pollutant.day) else {
                    return false
                }
                
                let targetDate = calendar.startOfDay(for: date)
                return calendar.isDateInToday(targetDate)
            }
            return todayPollutant.first
        case .tomorrow:
            let tomorrowPollutant = pollutants.filter { pollutant in
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
