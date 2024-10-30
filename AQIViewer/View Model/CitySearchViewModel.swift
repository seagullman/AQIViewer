//
//  CitySearchViewModel.swift
//  AQIViewer
//
//  Created by Brad Siegel on 5/22/24.
//

import Foundation

@Observable
class CitySearchViewModel {
    
    var cityStatePairs: [CityState] = []
    
    init() {
        if let cityStates = CityStateCache.shared.getCityStates(from: "US_States_and_Cities") {
            cityStatePairs = cityStates
        }
    }
}


