//
//  Alert.swift
//  AQIViewer
//
//  Created by Brad Siegel on 5/20/24.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    
    static let invalidUrl = AlertItem(title: Text("Server Error"),
                                          message: Text("There was an issue completing your request. If the issue persists, please contact support."),
                                          dismissButton: .default(Text("OK")))
    
    static let invalidResponse = AlertItem(title: Text("Oops"),
                                          message: Text("There was an issue completing your request. Please make sure you are connected to the internet and try again."),
                                          dismissButton: .default(Text("OK")))
    
    static let invalidData = AlertItem(title: Text("Something went wrong"),
                                          message: Text("There was an issue completing your request. There may not be any AQI data for the requested location. Please try again in a few minutes."),
                                          dismissButton: .default(Text("OK")))
}
