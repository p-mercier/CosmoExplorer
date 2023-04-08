//
//  BluetoothFacade.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 01/04/2023.
//

import Foundation
import CoreBluetooth

// MARK: Central Manager

protocol CentralManager {
    var delegate: CBCentralManagerDelegate? { get set }
    var state: CBManagerState { get }
    func scanForPeripherals(withServices: [CBUUID]?, options: [String : Any]?)
    func connect(_ peripheral: Peripheral, options: [String : Any]?)
    func cancelPeripheralConnection(_ peripheral: Peripheral)
    func stopScan()
}

extension CBCentralManager: CentralManager {
    func connect(_ peripheral: Peripheral, options: [String : Any]?) {
        guard let peripheral = peripheral as? CBPeripheral else { fatalError() }
        connect(peripheral, options: nil)
    }

    func cancelPeripheralConnection(_ peripheral: Peripheral) {
        guard let peripheral = peripheral as? CBPeripheral else { fatalError() }
        cancelPeripheralConnection(peripheral)
    }
}

// MARK: Central Manager Delegate

protocol CentralManagerDelegate: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CentralManager)

    func centralManager(_ central: CentralManager,
                        didDiscover peripheral: Peripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber)
    
    func centralManager(_ central: CentralManager, didConnect peripheral: Peripheral)
}
