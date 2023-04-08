//
//  Result.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 30/03/2023.
//

import Foundation

enum Result<Success, Error: Swift.Error> {
    case success(Success)
    case failure(Error)
}

extension Result {
    func get() throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

extension Result where Success == Data {
    func decoded<T: Decodable>(using decoder: JSONDecoder = .init()) throws -> T {
        let data = try get()
        decoder.dateDecodingStrategy = .formatted(.mainDateFormatter)
        return try decoder.decode(T.self, from: data)
    }
}
