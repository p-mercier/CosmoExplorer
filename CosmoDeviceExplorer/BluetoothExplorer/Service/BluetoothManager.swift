//
//  BluetoothManager.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 06/04/2023.
//

import Foundation

protocol BluetoothManager {
    var centralManager: CentralManager { get set }
    var didEncounterError: ((String) -> Void)? { get set }
    var didReceiveNewBleDeviceData: (([BleDeviceModel]) -> Void)? { get set }
    func startScan()
    func stopScan()
}
