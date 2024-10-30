//
//  ForecastView.swift
//  AQIViewer
//
//  Created by Brad Siegel on 5/20/24.
//

import SwiftUI

struct ForecastView: View {
    
    let title: String
    let o3: Int?
    let pm10: Int?
    let pm25: Int?
    
    var body: some View {
        VStack(spacing: 5) {
            if let _ = o3, let _ = pm10, let _ = pm25 {
                Text(title)
            } else {
                Text("No data")
            }
            
            HStack {
                MeasurementView(measurement: o3, text: "o3")
                MeasurementView(measurement: pm10, text: "PM10")
                MeasurementView(measurement: pm25, text: "PM2.5")
            }
        }
        .padding()
    }
}

#Preview {
    ForecastView(title: "Yesterday", o3: 7, pm10: 11, pm25: 26)
}
