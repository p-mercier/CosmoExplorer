//
//  BleDeviceViewModel.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 06/04/2023.
//

import Foundation

final class BleDeviceViewModel: Identifiable {
    let id: UUID
    let name: String
    let isNewlyDiscovered: Bool
    let advertisedDataFormatted: String
    let servicesAndCharacteristics: [String: [String]]

    init(bleDeviceModel: BleDeviceModel, isNewlyDiscovered: Bool) {
        self.id = bleDeviceModel.peripheral.identifier
        self.name = bleDeviceModel.name
        self.isNewlyDiscovered = isNewlyDiscovered
        self.advertisedDataFormatted = bleDeviceModel.advertisementData.sorted {$0.key < $1.key}.map { "\($0): \($1)" }.joined(separator: "\n")

        var newServicesAndCharacteristics: [String: [String]] = [:]
        if let services = bleDeviceModel.peripheral.services {
            for service in services {
                let serviceUuid = service.uuid.uuidString
                newServicesAndCharacteristics[serviceUuid] = []
                if let characteristics = service.characteristics {
                    var newCharacteristics: [String] = []
                    for characteristic in characteristics {
                        newCharacteristics.append(characteristic.uuid.uuidString)
                    }
                    newServicesAndCharacteristics[serviceUuid] = newCharacteristics
                }
            }
        }
        self.servicesAndCharacteristics = newServicesAndCharacteristics
    }

    func getServices() -> [String] {
        return servicesAndCharacteristics.keys.map({$0})
    }

    func getCharacteristicsForService(service: String) -> [String] {
        return servicesAndCharacteristics[service] ?? []
    }
}
