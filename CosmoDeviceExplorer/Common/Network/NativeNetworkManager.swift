//
//  NetworkManager.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 30/03/2023.
//

import Foundation

struct NativeNetworkManager: NetworkManager {
    func get(apiBaseUrl: String, endpoint: String, parameters: [String: String], completion: @escaping (Result<Data, Error>) -> Void) {
        guard var components = URLComponents(string: apiBaseUrl + endpoint) else {
            return
        }

        if !parameters.isEmpty {
            components.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }

        if let componentsUrl = components.url {
            // create request
            var request = URLRequest(url: componentsUrl)
            request.httpMethod = "GET"

            return sendRequest(request: request, completion: completion)
        }
    }

    private func sendRequest(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        // create URLSession
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        let session = URLSession(configuration: configuration)

        // create task
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                completion(.failure(error ?? NetworkManagerError.unknownError))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkManagerError.httpError(statusCode: httpResponse.statusCode)))
                return
            }

            guard let mime = httpResponse.mimeType, mime == "application/json" else {
                completion(.failure(NetworkManagerError.mimeTypeError))
                return
            }

            completion(.success(data))
        }
        
        // start task
        task.resume()
    }
}
