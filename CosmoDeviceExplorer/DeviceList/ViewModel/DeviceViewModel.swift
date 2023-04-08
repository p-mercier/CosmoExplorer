//
//  DeviceViewModel.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 30/03/2023.
//

import Foundation

final class DeviceViewModel: Identifiable {
    let id = UUID()
    let iconName: String?
    let macAddress: String
    let model: String
    let product: String?
    let firmwareVersion: String
    let serial: String?
    let installationMode: String?
    let brakeLight: String
    let lightMode: String?
    let lightAuto: String
    let lightValue: String

    init(deviceModel: DeviceModel) {
        self.iconName = deviceModel.getIconName()
        self.macAddress = deviceModel.macAddress
        self.model = deviceModel.model.capitalized
        self.product = deviceModel.product?.capitalized
        self.firmwareVersion = deviceModel.firmwareVersion
        self.serial = deviceModel.serial
        self.installationMode = deviceModel.installationMode?.getDescription()
        self.brakeLight = deviceModel.brakeLight ? "Yes" : "No"
        self.lightMode = deviceModel.lightMode?.getDescription()
        self.lightAuto = deviceModel.lightAuto ? "Yes" : "No"
        self.lightValue = String(deviceModel.lightValue)
    }
}
