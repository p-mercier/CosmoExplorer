//
//  DeviceList.swift
//  CosmoDeviceExplorerTests
//
//  Created by Philippe Mercier on 03/04/2023.
//

import XCTest
@testable import CosmoDeviceExplorer

final class DeviceList: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // test parser
    func testDeviceService_GetDevices_Parsing_Success() throws {
        let jsonData = UnitTestHelper.loadJson(filename: "GetDevicesResponse")!
        let result: Result<Data, Error> = .success(jsonData)
        let devicesModel = try result.decoded() as DevicesModel
        XCTAssertEqual(devicesModel.devices.count, 6)
    }

    // test view model
    func testDeviceListViewModel_GetDevices_Loading_Success() {
        let asyncExpectation = expectation(description: "Async getDevices block executed")
        let mockDeviceModels = [PreviewDataDeviceList.deviceModel]
        let deviceListViewModel = DeviceListViewModel(deviceService: DeviceServiceMock(mockDeviceModels: mockDeviceModels))
        deviceListViewModel.getDevices {
            XCTAssertEqual(deviceListViewModel.state, .loaded)
            XCTAssertEqual(deviceListViewModel.deviceViewModels.count, 1)
            asyncExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testDeviceListViewModel_GetDevices_Loading_Empty() {
        let asyncExpectation = expectation(description: "Async getDevices block executed")
        let deviceListViewModel = DeviceListViewModel(deviceService: DeviceServiceMock(mockDeviceModels: []))
        deviceListViewModel.getDevices() {
            XCTAssertEqual(deviceListViewModel.state, .empty)
            XCTAssertTrue(deviceListViewModel.deviceViewModels.isEmpty)
            asyncExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testDeviceListViewModel_GetDevices_Loading_Failed() {
        let asyncExpectation = expectation(description: "Async getDevices block executed")
        
        let deviceServiceMock = DeviceServiceMock(mockDeviceModels: [])
        deviceServiceMock.withError = true

        let deviceListViewModel = DeviceListViewModel(deviceService: deviceServiceMock)
        deviceListViewModel.getDevices() {
            XCTAssertEqual(deviceListViewModel.state, .loadingFailed(description: NetworkManagerError.unknownError.localizedDescription))
            XCTAssertTrue(deviceListViewModel.deviceViewModels.isEmpty)
            asyncExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}
