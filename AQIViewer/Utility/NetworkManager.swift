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
    
    private var baseUrlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "api.waqi.info"
        components.path = "/feed/"
        components.queryItems = [
            .init(name: "token", value: testToken)
        ]
        
        return components
    }
    
    private let session: URLSession
    
    // TODO: this should be stored somewhere secure (Keychain) via config file
    private let testToken = "d92d59027c616462a8a13a93402c7f08a8024b01"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchAQIDataBy(latitude: Double, longitude: Double) async throws -> AQIResponse {
        let components = updatedComponents(for: "geo:\(latitude);\(longitude)/")
        
        return try await makeRequest(components: components)
    }
    
    func fetchAQIDataBy(cityName: String) async throws -> AQIResponse {
        let components = updatedComponents(for: cityName)
        let response: AQIResponse = try await makeRequest(components: components)
        
        return response
    }
    
    // MARK: Private functions
    
    private func makeRequest<T: Decodable>(components: URLComponents) async throws -> T {
        guard let url = components.url else {
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
    
    private func updatedComponents(for path: String) -> URLComponents {
        var components = baseUrlComponents
        components.path += path
        return components
    }
}
