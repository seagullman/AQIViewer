//
//  CityStateCache.swift
//  AQIViewer
//
//  Created by Brad Siegel on 5/22/24.
//

import Foundation

class CityStateCache {
    static let shared = CityStateCache()
    private var cityStates: [CityState]?

    private init() {}

    func getCityStates(from filename: String) -> [CityState]? {
        if let cityStates = cityStates {
            // Return cached data if available
            return cityStates
        } else {
            // Parse and cache the data if not already cached
            if let jsonData = loadJsonFileAsData(filename: filename) {
                do {
                    // Decode the JSON data
                    let dictionary = try JSONDecoder().decode([String: [String]].self, from: jsonData)
                    
                    // Create an array to hold CityState objects
                    var cityStatePairs = [CityState]()
                    
                    // Iterate through the dictionary and create CityState objects
                    for (state, cities) in dictionary {
                        for city in cities {
                            let cityState = CityState(city: city, state: state)
                            cityStatePairs.append(cityState)
                        }
                    }
                    
                    cityStates = cityStatePairs
                    
                    return cityStatePairs
                } catch {
                    print("Error decoding JSON: \(error)")
                    return nil
                }
            }
        }
        return nil
    }
    
    private func loadJsonFileAsData(filename: String) -> Data? {
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
                return jsonData
            } catch {
                print("Error reading JSON file: \(error)")
            }
        } else {
            print("File not found: \(filename).json")
        }
        return nil
    }
}
