//
//  CoreBluetoothManager.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 01/04/2023.
//

import Foundation
import CoreBluetooth
import CoreData

class CoreBluetoothManager: NSObject, BluetoothManager {
    var centralManager: CentralManager
    var didEncounterError: ((String) -> Void)?
    var didReceiveNewBleDeviceData: (([BleDeviceModel]) -> Void)?
    
    var discoveredDevices: [UUID: BleDeviceModel] = [:] {
        didSet {
            didReceivedNewPeripheralData()
        }
    }

    init(centralManager: CentralManager = CBCentralManager(),
         discoveredPeripheralManager: DiscoveredPeripheralManager = DiscoveredPeripheralManager()) {
        self.centralManager = centralManager
        super.init()
        self.centralManager.delegate = self
    }

    private func didReceivedNewPeripheralData() {
        didReceiveNewBleDeviceData?(discoveredDevices.values.map({$0}))
    }
}

extension CoreBluetoothManager {
    func startScan() {
        if centralManager.state == .poweredOn {
            for (_, bleDevice) in discoveredDevices {
                centralManager.cancelPeripheralConnection(bleDevice.peripheral)
            }
            discoveredDevices = [:]
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    func stopScan() {
        centralManager.stopScan()
    }
}

extension CoreBluetoothManager: CentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CentralManager) {
        switch central.state {
        case.unknown:
            didEncounterError?("Unknown Bluetooth error happened")
            stopScan()
        case .resetting:
            didEncounterError?("Bluetooth did reset")
            stopScan()
        case .unsupported:
            didEncounterError?("Bluetooth low energy is not supported")
            stopScan()
        case .unauthorized:
            didEncounterError?("Bluetooth usage is not authorized")
            stopScan()
        case .poweredOff:
            didEncounterError?("Bluetooth is Powered off")
            stopScan()
        case .poweredOn:
            print("Bluetooth is powered on")
        @unknown default:
            didEncounterError?("Unknown Bluetooth error happened")
            stopScan()
        }
    }

    func centralManager(_ central: CentralManager, didDiscover peripheral: Peripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // only display devices with a name
        guard let name = peripheral.name ?? advertisementData[CBAdvertisementDataLocalNameKey] as? String, !name.isEmpty else { return }

        let id = peripheral.identifier
        if discoveredDevices[id] == nil {
            var bleDevice = BleDeviceModel(
                id: id,
                name: name,
                peripheral: peripheral,
                advertisementData: advertisementData
            )
            bleDevice.peripheral.delegate = self
            discoveredDevices[id] = bleDevice
            
            let isConnectable = advertisementData[CBAdvertisementDataIsConnectable] as? Bool
            if isConnectable == true {
                central.connect(peripheral, options: nil)
            }
        }
    }

    func centralManager(_ central: CentralManager, didConnect peripheral: Peripheral) {
        peripheral.discoverServices(nil)
    }

    // MARK: CBCentralManagerDelegate

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        centralManagerDidUpdateState(central as CentralManager)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        centralManager(central as CentralManager, didDiscover: peripheral as Peripheral, advertisementData: advertisementData, rssi: RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        centralManager(central as CentralManager, didConnect: peripheral as Peripheral)
    }
}

extension CoreBluetoothManager: PeripheralDelegate {
    func peripheral(_ peripheral: Peripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services, services.isEmpty == false else { return }
        didReceivedNewPeripheralData()

        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: Peripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let serviceCharacteristics = service.characteristics, serviceCharacteristics.isEmpty == false else { return }
        didReceivedNewPeripheralData()
    }

    // MARK: CBPeripheralDelegate

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        self.peripheral(peripheral as Peripheral, didDiscoverServices: error)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        self.peripheral(peripheral as Peripheral, didDiscoverCharacteristicsFor: service, error: error)
    }
}
