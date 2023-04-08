//
//  NetworkManagerError.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 30/03/2023.
//

import Foundation

enum NetworkManagerError: Error {
    case unknownError
    case httpError(statusCode: Int)
    case mimeTypeError
    case decodingError
}

extension NetworkManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknownError, .mimeTypeError:
            return NSLocalizedString("Apologies something went wrong. Please try again later.", comment: "")
        case .decodingError:
            return NSLocalizedString("Apologies an error happened while decoding data", comment: "")
        case let .httpError(statusCode):
            return NSLocalizedString("Apologies an error happened while fetching data from our server, status code: \(statusCode). Please try again later.", comment: "")
        }
    }
}
