//
//  AQIView.swift
//  AQIViewer
//
//  Created by Brad Siegel on 5/20/24.
//

import SwiftUI

struct AQIView: View {
    
    let aqi: Int?
    let o3: Int?
    let pm10: Int?
    let pm25: Int?
    
    var body: some View {
        GroupBox("Currently") {
            VStack(spacing: 25) {
                VStack {
                    Text(String(aqi ?? 0))
                        .font(.system(size: 50))
                    
                    Text("AQI")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                
                HStack(spacing: 50) {
                    MeasurementView(measurement: o3, text: "o3")
                    MeasurementView(measurement: pm10, text: "PM10")
                    MeasurementView(measurement: pm25, text: "PM2.5")
                }
            }
        }
    }
}

#Preview {
    AQIView(aqi: 41, o3: 4, pm10: 6, pm25: 23)
}
