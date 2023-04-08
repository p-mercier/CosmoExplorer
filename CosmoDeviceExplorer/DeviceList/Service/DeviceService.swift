//
//  DeviceService.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 30/03/2023.
//

import Foundation

protocol DeviceService {
    func getDevices(completion: @escaping (Result<DevicesModel, Error>) -> Void)
}
