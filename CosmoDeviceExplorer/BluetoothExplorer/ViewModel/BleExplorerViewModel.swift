//
//  BleExplorerViewModel.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 01/04/2023.
//

import Foundation

final class BleExplorerViewModel: ObservableObject {
    @Published private(set) var state: BleExplorerViewState = .initialize
    @Published private(set) var bleDeviceViewModels: [BleDeviceViewModel] = []

    var bluetoothManager: BluetoothManager
    let discoveredPeripheralManager: DiscoveredPeripheralManager

    init(bluetoothManager: BluetoothManager = CoreBluetoothManager(),
         discoveredPeripheralManager: DiscoveredPeripheralManager = DiscoveredPeripheralManager()) {
        self.bluetoothManager = bluetoothManager
        self.discoveredPeripheralManager = discoveredPeripheralManager

        self.bluetoothManager.didReceiveNewBleDeviceData = { [weak self] bleDeviceModels in
            guard let self = self else { return }
            self.discoveredPeripheralManager.processBleDevices(bleDeviceModels: bleDeviceModels)
            self.load(bleDeviceModels: bleDeviceModels)
        }

        self.bluetoothManager.didEncounterError = { [weak self] description in
            guard let self = self else { return }
            self.state = .bluetoothError(description: description)
        }
    }

    func startScan() {
        bleDeviceViewModels = []
        state = .scanning
        bluetoothManager.startScan()
    }

    func stopScan() {
        state = .stopped
        discoveredPeripheralManager.save()
        bluetoothManager.stopScan()
    }

    func load(bleDeviceModels: [BleDeviceModel]) {
        self.bleDeviceViewModels = bleDeviceModels.map { bleDeviceModel in
            return BleDeviceViewModel(bleDeviceModel: bleDeviceModel, isNewlyDiscovered: discoveredPeripheralManager.isNewlyDiscoveredPeripheral(uuid: bleDeviceModel.peripheral.identifier))
        }
    }
}
