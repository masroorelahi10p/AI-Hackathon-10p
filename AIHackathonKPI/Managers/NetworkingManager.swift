//
//  NetworkingManager.swift
//  AIHackathon
//
//  Created by Masroor Elahi on 26/10/2024.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case requestFailed
    case decodingFailed
    case unknownError
}

protocol NetworkManaging {
    func performRequest<T: Codable>(urlString: String, method: String, body: Data?) async throws -> T
}

class NetworkManager: NetworkManaging {
    func performRequest<T: Codable>(urlString: String, method: String = "GET", body: Data? = nil) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
