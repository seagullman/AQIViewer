//
//  NetworkManager.swift
//  AQIViewer
//
//  Created by Brad Siegel on 5/19/24.
//

import Foundation

enum AQIError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
}

protocol NetworkClient: AnyObject {
    func fetchAQIDataBy(latitude: Double, longitude: Double) async throws -> AQIResponse
    func fetchAQIDataBy(cityName: String) async throws -> AQIResponse
}

class NetworkManager: NetworkClient {

    static let shared = NetworkManager()
    
    private let baseURL = "http://api.waqi.info/feed/"
    
    // TODO: this should be stored somewhere secure, but for the scope of this challenge, I am putting it here
    private let testToken = "d92d59027c616462a8a13a93402c7f08a8024b01"
    
    private init() {}
    
    func fetchAQIDataBy(latitude: Double, longitude: Double) async throws -> AQIResponse {
        let urlString = baseURL.appending("geo:\(latitude);\(longitude)/?token=\(testToken)")
        
        print("***** USING THIS URL: \(urlString)")
        
        return try await makeRequest(urlString: urlString)
    }
    
    func fetchAQIDataBy(cityName: String) async throws -> AQIResponse {
        if let encodedCityName = encodeForURL(cityName) {
            let urlString = baseURL.appending("\(encodedCityName)/?token=\(testToken)")
            print("***** USING THIS URL (city search): \(urlString)")
            
            let response: AQIResponse = try await makeRequest(urlString: urlString)
            return response
        } else {
            throw AQIError.invalidData
        }
    }
    
    // MARK: Private functions
    
    private func makeRequest<T: Decodable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw AQIError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200
        else {
            throw AQIError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode(T.self, from: data)
        } catch {
            throw AQIError.invalidData
        }
    }
    
    private func encodeForURL(_ string: String) -> String? {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
