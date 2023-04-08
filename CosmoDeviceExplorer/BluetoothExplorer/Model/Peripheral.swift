//
//  Peripheral.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 05/04/2023.
//

import Foundation
import CoreBluetooth

// MARK: Peripheral

protocol Peripheral {
    var identifier: UUID { get }
    var name: String? { get }
    var delegate: CBPeripheralDelegate? { get set }
    var services: [CBService]? { get }

    func discoverServices(_ serviceUUIDs: [CBUUID]?)
    func discoverCharacteristics(_ characteristicUUIDs: [CBUUID]?, for service: CBService)
}

extension CBPeripheral: Peripheral {
}

struct PeripheralPreview: Peripheral {
    var identifier: UUID = UUID()
    var name: String?
    var delegate: CBPeripheralDelegate?
    var services: [CBService]?

    func discoverServices(_ serviceUUIDs: [CBUUID]?) {
    }
    
    func discoverCharacteristics(_ characteristicUUIDs: [CBUUID]?, for service: CBService) {
    }
}

// MARK: Peripheral Delegate

protocol PeripheralDelegate: CBPeripheralDelegate {
    func peripheral(_ peripheral: Peripheral, didDiscoverServices error: Error?)
    func peripheral(_ peripheral: Peripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
}
