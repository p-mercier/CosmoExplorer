//
//  WebDeviceService.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 30/03/2023.
//

import Foundation

struct WebDeviceService: DeviceService {
    let networkManager: NetworkManager

    init(networkManager: NetworkManager = NativeNetworkManager()){
        self.networkManager = networkManager
    }

    func getDevices(completion: @escaping (Result<DevicesModel, Error>) -> Void) {
        let endpoint = "/test/devices"
        let parameters: [String: String] = [:]

        networkManager.get(
            apiBaseUrl: Config.baseUrl,
            endpoint: endpoint,
            parameters: parameters) { result in
            switch result {
            case .success:
                do {
                    let devices = try result.decoded() as DevicesModel
                    completion(.success(devices))
                } catch {
                    completion(.failure(NetworkManagerError.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
