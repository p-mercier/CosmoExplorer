//
//  DeviceListView.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 30/03/2023.
//

import SwiftUI

struct DeviceListView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @StateObject private var deviceListViewModel: DeviceListViewModel

    init(deviceListViewModel: DeviceListViewModel = .init()) {
        _deviceListViewModel = StateObject(wrappedValue: deviceListViewModel)
    }

    var body: some View {
        NavigationView {
            ZStack {
                if networkMonitor.isConnected == false {
                    Text("No internet connection available")
                } else {
                    switch (deviceListViewModel.state) {
                    case .initialize, .loading:
                        ScrollView {
                            LazyVStack {
                                ForEach(0..<10) { _ in
                                    DeviceCellView(deviceViewModel: PreviewDataDeviceList.deviceViewModel)
                                }
                                .redacted(reason: .placeholder)
                            }
                        }
                    case .loaded:
                        ScrollView {
                            LazyVStack {
                                ForEach(deviceListViewModel.deviceViewModels, id: \.id) { deviceViewModel in
                                    NavigationLink(destination: DeviceDetailView(deviceViewModel: deviceViewModel)) {
                                        DeviceCellView(deviceViewModel: deviceViewModel)
                                    }
                                }
                            }
                        }
                    case .empty:
                        Text("No devices have been found")
                    case .loadingFailed(description: let description):
                        Text(description)
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("Cosmo Devices")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        deviceListViewModel.getDevices(refresh: true)
                    } label: {
                        Image(systemName: "arrow.clockwise.circle")
                    }
                }
            }
            .onAppear {
                deviceListViewModel.getDevices()
            }
        }
    }
}

struct DeviceListView_Previews: PreviewProvider {
    static var previews: some View {
        let deviceListViewModel = DeviceListViewModel()
        deviceListViewModel.load(devicesModel: PreviewDataDeviceList.devicesModel)
        return DeviceListView(deviceListViewModel: deviceListViewModel)
    }
}
