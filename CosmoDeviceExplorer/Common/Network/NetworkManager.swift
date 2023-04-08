//
//  NetworkManager.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 03/04/2023.
//

import Foundation

protocol NetworkManager {
    func get(apiBaseUrl: String, endpoint: String, parameters: [String: String], completion: @escaping (Result<Data, Error>) -> Void)
}
