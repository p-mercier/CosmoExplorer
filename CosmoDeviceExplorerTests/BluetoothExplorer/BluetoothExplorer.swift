//
//  BluetoothExplorer.swift
//  CosmoDeviceExplorerTests
//
//  Created by Philippe Mercier on 03/04/2023.
//

import XCTest
import CoreBluetooth
@testable import CosmoDeviceExplorer

final class BluetoothExplorer: XCTestCase {
    private var bluetoothManager: CoreBluetoothManager!
    private var centralManager: CentralManagerMock!

    override func setUp() {
        super.setUp()
        centralManager = CentralManagerMock()
        bluetoothManager = CoreBluetoothManager(centralManager: centralManager)
    }

    func testInitializer() {
        XCTAssertNotNil(bluetoothManager)
        XCTAssertEqual(centralManager.delegate as? CoreBluetoothManager, bluetoothManager)
        XCTAssertTrue(centralManager.messages.isEmpty)
    }

    // MARK: CentralManager DidUpdateState

    func testCentralManagerDidUpdateState_PoweredOff() {
        centralManager.state = .poweredOff
        bluetoothManager.centralManagerDidUpdateState(centralManager)
        XCTAssertEqual(centralManager.messages.count, 1)
        XCTAssertTrue(centralManager.messages.contains(.stopScan))
    }

    func testCentralManagerDidUpdateStatePowered_Resetting() {
        centralManager.state = .resetting
        bluetoothManager.centralManagerDidUpdateState(centralManager)
        XCTAssertEqual(centralManager.messages.count, 1)
        XCTAssertTrue(centralManager.messages.contains(.stopScan))
    }

    func testCentralManagerDidUpdateState_Unauthorized() {
        centralManager.state = .unauthorized
        bluetoothManager.centralManagerDidUpdateState(centralManager)
        XCTAssertEqual(centralManager.messages.count, 1)
        XCTAssertTrue(centralManager.messages.contains(.stopScan))
    }

    func testCentralManagerDidUpdateState_Unknown() {
        centralManager.state = .unknown
        bluetoothManager.centralManagerDidUpdateState(centralManager)
        XCTAssertEqual(centralManager.messages.count, 1)
        XCTAssertTrue(centralManager.messages.contains(.stopScan))
    }

    func testCentralManagerDidUpdateState_Unsupported() {
        centralManager.state = .unsupported
        bluetoothManager.centralManagerDidUpdateState(centralManager)
        XCTAssertEqual(centralManager.messages.count, 1)
        XCTAssertTrue(centralManager.messages.contains(.stopScan))
    }
    
    func testCentralManagerDidUpdateState_PoweredOn() {
        centralManager.state = .poweredOn
        bluetoothManager.centralManagerDidUpdateState(centralManager)
        XCTAssertTrue(centralManager.messages.isEmpty)
    }

    // MARK: CentralManager DidDiscoverPeripheral

    func testDidDiscoverPeripheral_ValidPeripheralName() {
        let peripheral = PeripheralMock()
        peripheral.name = "NAME"
        let advertisementData: [String: Any] = [CBAdvertisementDataIsConnectable: true]

        
        bluetoothManager.centralManager(centralManager,
                               didDiscover: peripheral,
                               advertisementData: advertisementData,
                               rssi: 1)
    
        XCTAssertEqual(centralManager.messages.count, 1)
        XCTAssertTrue(centralManager.messages.contains(.connect))
    }

    func testDidDiscoverPeripheral_NoName() {
        let peripheral = PeripheralMock()
        peripheral.name = nil
        let advertisementData: [String: Any] = [:]
        
        bluetoothManager.centralManager(centralManager,
                               didDiscover: peripheral,
                               advertisementData: advertisementData,
                               rssi: 1)

        XCTAssertEqual(centralManager.messages.count, 0)
    }

    func testDidDiscoverPeripheral_NoNameButWithCBAdvertisementDataLocalNameKey() {
        let peripheral = PeripheralMock()
        peripheral.name = nil
        let advertisementData: [String: Any] = [CBAdvertisementDataLocalNameKey: "NAME", CBAdvertisementDataIsConnectable: true]

        bluetoothManager.centralManager(centralManager,
                               didDiscover: peripheral,
                               advertisementData: advertisementData,
                               rssi: 1)

        XCTAssertEqual(centralManager.messages.count, 1)
        XCTAssertTrue(centralManager.messages.contains(.connect))
    }
    
    // MARK: Peripheral DidDiscoverServices

    func testPeripheral_DidDiscoverServices_NoServices() {
        let peripheral = PeripheralMock()
        peripheral.services = []
        bluetoothManager.peripheral(peripheral, didDiscoverServices: nil)
        XCTAssertEqual(peripheral.messages.count, 0)
    }

    func testPeripheral_DidDiscoverServices_SeveralServices() {
        let peripheral = PeripheralMock()
        peripheral.services = [CBMutableService(type: CBUUID(), primary: true), CBMutableService(type: CBUUID(), primary: false)]
        bluetoothManager.peripheral(peripheral, didDiscoverServices: nil)
        XCTAssertEqual(peripheral.messages.count, 2)
        XCTAssertEqual(peripheral.messages[0], .discoverCharacteristics)
        XCTAssertEqual(peripheral.messages[1], .discoverCharacteristics)
    }

    // MARK: CentralManager Start (CancelPeripheral + ScanForPeripherals)

    func testManager_Start() {
        centralManager.state = .poweredOn
        bluetoothManager.startScan()
        XCTAssertEqual(centralManager.messages.count, 1)
        XCTAssertTrue(centralManager.messages.contains(.scanForPeripherals))
    }

    func testManager_CancelPeripheral_Before_Start() {
        centralManager.state = .poweredOn
        let id = UUID()
        bluetoothManager.discoveredDevices = [id: BleDeviceModel(id: id, name: "device-test", peripheral: PeripheralMock())]
        bluetoothManager.startScan()
        XCTAssertEqual(centralManager.messages.count, 2)
        XCTAssertTrue(centralManager.messages[0] == .cancelPeripheral)
        XCTAssertTrue(centralManager.messages[1] == .scanForPeripherals)
    }

    func testManager_CancelMultiplePeripherals_Before_Start() {
        centralManager.state = .poweredOn
        bluetoothManager.discoveredDevices = [UUID(): BleDeviceModel(id: UUID(), name: "device-test", peripheral: PeripheralMock()), UUID(): BleDeviceModel(id: UUID(), name: "device-test2", peripheral: PeripheralMock())]
        bluetoothManager.startScan()
        XCTAssertEqual(centralManager.messages.count, 3)
        XCTAssertTrue(centralManager.messages[0] == .cancelPeripheral)
        XCTAssertTrue(centralManager.messages[1] == .cancelPeripheral)
        XCTAssertTrue(centralManager.messages[2] == .scanForPeripherals)
    }

    // MARK: CentralManager StopScan

    func testManager_Stop() {
        centralManager.state = .poweredOn
        bluetoothManager.stopScan()
        XCTAssertEqual(centralManager.messages.count, 1)
        XCTAssertTrue(centralManager.messages.contains(.stopScan))
    }
}
