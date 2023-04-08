//
//  CentralManagerMock.swift
//  CosmoDeviceExplorerTests
//
//  Created by Philippe Mercier on 03/04/2023.
//

import Foundation
import CoreBluetooth
@testable import CosmoDeviceExplorer

final class CentralManagerMock: CentralManager {
    private(set) var messages: [Message] = []
    enum Message {
        case scanForPeripherals
        case connect
        case cancelPeripheral
        case stopScan
    }

    var delegate: CBCentralManagerDelegate?
    var state: CBManagerState = .poweredOff

    func scanForPeripherals(withServices: [CBUUID]?, options: [String : Any]?) {
        messages.append(.scanForPeripherals)
    }

    func connect(_ peripheral: CosmoDeviceExplorer.Peripheral, options: [String : Any]?) {
        messages.append(.connect)
    }

    func cancelPeripheralConnection(_ peripheral: CosmoDeviceExplorer.Peripheral) {
        messages.append(.cancelPeripheral)
    }

    func stopScan() {
        messages.append(.stopScan)
    }
}
