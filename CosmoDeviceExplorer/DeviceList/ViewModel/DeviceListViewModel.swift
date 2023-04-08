//
//  DeviceListViewModel.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 30/03/2023.
//

import Foundation

final class DeviceListViewModel: ObservableObject {
    @Published private(set) var state: CommonViewState = .initialize
    @Published private(set) var deviceViewModels: [DeviceViewModel] = []

    let deviceService: DeviceService

    init(deviceService: DeviceService = WebDeviceService()) {
        self.deviceService = deviceService
    }

    func getDevices(refresh: Bool = false, completion: (() -> ())? = nil) {
        if state == .initialize || refresh == true {
            state = .loading
            deviceService.getDevices { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(let devicesModel):
                        if devicesModel.devices.isEmpty {
                            self.state = .empty
                        } else {
                            self.load(devicesModel: devicesModel)
                            self.state = .loaded
                        }
                    case .failure(let error):
                        self.state = .loadingFailed(description: error.localizedDescription)
                    }
                    completion?()
                }
            }
        }
    }

    func load(devicesModel: DevicesModel) {
        self.deviceViewModels = devicesModel.devices.map { deviceModel in
            DeviceViewModel(deviceModel: deviceModel)
        }
    }
}
