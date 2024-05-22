//
//  CitySearchView.swift
//  AQIViewer
//
//  Created by Brad Siegel on 5/21/24.
//

import SwiftUI

struct CitySearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @Binding var selectedCity: String
    
    // Sample list of cities
    let cities = ["Portland", "Los Angeles", "Chicago", "Houston", "Phoenix", "Philadelphia", "San Antonio", "San Diego", "Dallas", "San Jose", "Austin", "Jacksonville", "Fort Worth", "Columbus", "Charlotte", "San Francisco", "Indianapolis", "Seattle", "Denver", "Washington"]

    var body: some View {
        VStack {
            // Search TextField
            TextField("Search cities", text: $searchText)
                .padding()
//                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // List of filtered cities
            List {
                ForEach(filteredCities, id: \.self) { city in
                    Text(city)
                        .onTapGesture {
                            print("**** \(city) tapped")
                            selectedCity = city
                            dismiss()
                        }
                }
            }
        }
        .navigationTitle("City Search")
//        .padding()
    }
    
    // Computed property to filter cities based on search text
    var filteredCities: [String] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

#Preview {
    CitySearchView(selectedCity: .constant(""))
}
