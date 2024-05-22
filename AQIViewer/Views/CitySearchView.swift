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
    @Binding var selectedCityState: CityState?
    
    var viewModel = CitySearchViewModel()
    
    var filteredCities: [CityState] {
        return viewModel.cityStatePairs.filter { cityState in
            cityState.city.localizedCaseInsensitiveContains(searchText) ||
            cityState.state.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        VStack {
            TextField("Search cities", text: $searchText)
                .padding()
            
            List {
                ForEach(filteredCities, id: \.self) { cityState in
                    Text("\(cityState.city), \(cityState.state)")
                        .onTapGesture {
                            selectedCityState = cityState
                            dismiss()
                        }
                }
            }
        }
        .navigationTitle("City Search")
//        .padding()
    }
}

#Preview {
    CitySearchView(selectedCityState: .constant(CityState(city: "Knoxville", state: "TN")))
}
