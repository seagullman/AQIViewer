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
                        .foregroundStyle(aqiTextColor())
                    
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
    
    func aqiTextColor() -> Color {
        guard let aqi else { return .black }
        
        let color: Color
        switch aqi {
        case 0...50:
            color = .green
        case 51...100:
            color = .yellow
        case 101...150:
            color = .orange
        case 151...200:
            color = .red
        case 201...300:
            color = .purple
        case 300...:
            color = .brown
        default:
            color = .black
        }
        return color
    }
}

#Preview {
    AQIView(aqi: 41, o3: 4, pm10: 6, pm25: 23)
}
