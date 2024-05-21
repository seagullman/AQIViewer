//
//  AQIRootView.swift
//  AQIViewer
//
//  Created by Brad Siegel on 5/17/24.
//

import SwiftUI

struct AQIRootView: View {
    @State var viewModel = AQIViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if let sampleAQIInfo = viewModel.aqiInfo {
                    AQICardView(aqiInfo: sampleAQIInfo)
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            .navigationTitle("AQI Viewer")
        }
        .padding()
        .onAppear { fetchAQIData() }
        .onChange(of: viewModel.locationManager.lastLocation) { fetchAQIData() }
        .refreshable { viewModel.locationManager.refreshLocation() }
        .searchable(text: $viewModel.searchText, prompt: "Search for city")
        .onSubmit(of: .search, runSearch)
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }
    
    func fetchAQIData() {
        Task { await viewModel.fetchAQIDataByLatLong() }
    }
    
    func runSearch() {
        Task { await viewModel.fetchAQIDataBy(cityName: viewModel.searchText) }
    }
}

#Preview {
    AQIRootView()
}
