//
//  BleDeviceModel.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 01/04/2023.
//

import Foundation

struct BleDeviceModel {
    var id: UUID = UUID()
    var name: String
    var peripheral: Peripheral
    var advertisementData: [String: Any] = [:]
}
