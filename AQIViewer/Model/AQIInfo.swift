//
//  AQIInfo.swift
//  AQIViewer
//
//  Created by Brad Siegel on 5/20/24.
//

import Foundation

struct AQIInfo {
    let name: String
    let latitude: Double
    let longitude: Double
    let aqi: Int
    let current: AQIMeasurements
    let yesterday: AQIMeasurements
    let tomorrow: AQIMeasurements
}

struct AQIMeasurements {
    let o3: Pollutant?
    let pm10: Pollutant?
    let pm25: Pollutant?
}
