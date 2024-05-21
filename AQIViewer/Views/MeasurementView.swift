//
//  MeasurementView.swift
//  AQIViewer
//
//  Created by Brad Siegel on 5/20/24.
//

import SwiftUI

struct MeasurementView: View {
    let measurement: Int?
    let text: String
    
    var body: some View {
        if let measurement {
            VStack {
                Text(String(measurement))
                    .font(.title3)
                Text(text)
                    .font(.system(.caption))
            }
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    MeasurementView(measurement: 4, text: "o3")
}
