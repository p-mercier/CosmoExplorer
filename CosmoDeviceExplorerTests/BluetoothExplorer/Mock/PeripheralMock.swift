//
//  PeripheralMock.swift
//  CosmoDeviceExplorerTests
//
//  Created by Philippe Mercier on 03/04/2023.
//

import Foundation
import CoreBluetooth
@testable import CosmoDeviceExplorer

final class PeripheralMock: Peripheral {
    private(set) var messages: [Message] = []
    enum Message {
        case discoverServices
        case discoverCharacteristics
    }

    var identifier: UUID = UUID()
    var name: String?
    var delegate: CBPeripheralDelegate?
    var services: [CBService]?

    func discoverServices(_ serviceUUIDs: [CBUUID]?) {
        messages.append(.discoverServices)
    }

    func discoverCharacteristics(_ characteristicUUIDs: [CBUUID]?, for service: CBService) {
        messages.append(.discoverCharacteristics)
    }
}
