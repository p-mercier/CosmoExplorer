//
//  MockDeviceService.swift
//  CosmoDeviceExplorerTests
//
//  Created by Philippe Mercier on 30/03/2023.
//

import Foundation
@testable import CosmoDeviceExplorer

final class DeviceServiceMock: DeviceService {
    let mockDeviceModels: [DeviceModel]
    var withError = false

    init(mockDeviceModels: [DeviceModel]) {
        self.mockDeviceModels = mockDeviceModels
    }

    func getDevices(completion: @escaping (CosmoDeviceExplorer.Result<CosmoDeviceExplorer.DevicesModel, Error>) -> Void) {
        if withError == true {
            completion(.failure(NetworkManagerError.unknownError))
        } else {
            completion(.success(DevicesModel(devices: mockDeviceModels)))
        }
    }
}
