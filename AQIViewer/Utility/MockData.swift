//
//  MockData.swift
//  AQIViewer
//
//  Created by Brad Siegel on 5/20/24.
//

import Foundation

public struct MockData {
    static let sampleAQIInfo = AQIInfo(
        name: "Air Lab, Tennessee, USA",
        latitude: 35.9803,
        longitude: -83.9306,
        aqi: 20,
        current: AQIMeasurements(
            o3: Pollutant(avg: 10, day: "2022-10-01", max: 20, min: 5),
            pm10: Pollutant(avg: 15, day: "2022-10-01", max: 25, min: 10),
            pm25: Pollutant(avg: 12, day: "2022-10-01", max: 18, min: 8)
        ),
        yesterday: AQIMeasurements(
            o3: Pollutant(avg: 8, day: "2022-10-01", max: 16, min: 4),
            pm10: Pollutant(avg: 14, day: "2022-10-01", max: 20, min: 10),
            pm25: Pollutant(avg: 11, day: "2022-10-01", max: 17, min: 7)
        ),
        tomorrow: AQIMeasurements(
            o3: Pollutant(avg: 9, day: "2022-10-01", max: 19, min: 5),
            pm10: Pollutant(avg: 13, day: "2022-10-01", max: 22, min: 9),
            pm25: Pollutant(avg: 14, day: "2022-10-01", max: 20, min: 10)
        )
    )
}
