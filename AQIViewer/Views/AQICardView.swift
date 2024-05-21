//
//  AQICardView.swift
//  AQIViewer
//
//  Created by Brad Siegel on 5/20/24.
//

import SwiftUI

struct AQICardView: View {
    
    let aqiInfo: AQIInfo
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                LocationView(
                    name: aqiInfo.name,
                    latitude: aqiInfo.latitude,
                    longitude: aqiInfo.longitude
                )
                
                AQIView(
                    aqi: aqiInfo.aqi,
                    o3: aqiInfo.current.o3.avg,
                    pm10: aqiInfo.current.pm10.avg,
                    pm25: aqiInfo.current.pm25.avg
                )
                
                GroupBox {
                    HStack {
                        ForecastView(
                            title: "Yesterday",
                            o3: aqiInfo.yesterday.o3.avg,
                            pm10: aqiInfo.yesterday.pm10.avg,
                            pm25: aqiInfo.yesterday.pm25.avg
                        )
                        
                        Spacer()
                        
                        Divider()

                        Spacer()
                        
                        ForecastView(
                            title: "Tomorrow",
                            o3: aqiInfo.tomorrow.o3.avg,
                            pm10: aqiInfo.tomorrow.pm10.avg,
                            pm25: aqiInfo.tomorrow.pm25.avg
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    AQICardView(aqiInfo: MockData.sampleAQIInfo)
}
