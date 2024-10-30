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
    @FocusState private var keyboardFocused: Bool
    
    var viewModel = CitySearchViewModel()
    
    var filteredCityStates: [CityState] {
        return viewModel.cityStatePairs.filter { cityState in
            cityState.city.localizedCaseInsensitiveContains(searchText) ||
            cityState.state.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        VStack {
            TextField("Search cities", text: $searchText)
                .padding()
                .font(.title2)
                .submitLabel(.search)
                .focused($keyboardFocused)
            
            List {
                ForEach(filteredCityStates, id: \.self) { cityState in
                    HStack {
                        Text("\(cityState.city), \(cityState.state)")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedCityState = cityState
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("City Search")
        .onAppear { keyboardFocused = true }
    }
}

#Preview {
    CitySearchView(selectedCityState: .constant(CityState(city: "Knoxville", state: "TN")))
}
