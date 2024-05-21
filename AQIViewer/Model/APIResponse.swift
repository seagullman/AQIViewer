//
//  APIResponse.swift
//  AQIViewer
//
//  Created by Brad Siegel on 5/19/24.
//

import Foundation

// MARK: - Root Response
struct AQIResponse: Codable {
    let data: AQIData
}

// MARK: - AQIData
struct AQIData: Codable {
    let aqi: Int
    let city: City
    let time: Time
    let forecast: Forecast
}

// MARK: - City
struct City: Codable {
    let geo: [Double]
    let name: String
    let url: String
    let location: String
}

// MARK: - Time
struct Time: Codable {
    let iso: String
}

// MARK: - Forecast
struct Forecast: Codable {
    let daily: Daily
}

// MARK: - Daily
struct Daily: Codable {
    let o3: [Pollutant]
    let pm10: [Pollutant]
    let pm25: [Pollutant]
}

// MARK: - Pollutant
struct Pollutant: Codable {
    let avg: Int
    let day: String
    let max: Int
    let min: Int
}
