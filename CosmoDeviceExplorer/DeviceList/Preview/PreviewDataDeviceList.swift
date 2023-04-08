//
//  PreviewDataDeviceList.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 31/03/2023.
//

import Foundation

struct PreviewDataDeviceList {
    static let deviceModel = DeviceModel(macAddress: "4921201e38d5", model: "RIDE", product: "RIDE", firmwareVersion: "2.2.2", serial: "BC892C9C-047D-8402-A9FD-7B2CC0048736", installationMode: .helmet, brakeLight: false, lightMode: .OFF, lightAuto: false, lightValue: 0)
    
    static let deviceViewModel = DeviceViewModel(deviceModel: PreviewDataDeviceList.deviceModel)
    
    static let devicesModel = DevicesModel(devices: [PreviewDataDeviceList.deviceModel])
}
