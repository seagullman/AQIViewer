//
//  LocationView.swift
//  AQIViewer
//
//  Created by Brad Siegel on 5/20/24.
//

import SwiftUI

struct LocationView: View {
    
    let name: String
    let latitude: Double
    let longitude: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.headline)
            Text("Latitude: \(latitude), Longitude: \(longitude)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    LocationView(name: "Air Lab, Tennessee, USA", latitude: 35.9803, longitude: -83.9306)
}
