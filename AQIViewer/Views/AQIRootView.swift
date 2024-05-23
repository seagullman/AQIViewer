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
                if let sampleAQIInfo = viewModel.aqiInfo, !viewModel.isLoading {
                    AQICardView(aqiInfo: sampleAQIInfo)
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            .navigationTitle("AQI Viewer")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.isShowingDetailView = true
                    } label: {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.isShowingDetailView) {
                CitySearchView(selectedCityState: $viewModel.selectedCityState)
            }
        }
        .onAppear { fetchAQIData() }
        .onChange(of: viewModel.locationManager.lastLocation) { fetchAQIData() }
        .refreshable { viewModel.locationManager.refreshLocation() }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
        .onChange(of: viewModel.selectedCityState) {
            guard let cityState = viewModel.selectedCityState else { return }
            
            Task { await viewModel.fetchAQIDataBy(cityName: cityState.city, state: cityState.state) }
        }
    }
    
    func fetchAQIData() {
        Task { await viewModel.fetchAQIDataByLatLong() }
    }
}

#Preview {
    AQIRootView()
}
