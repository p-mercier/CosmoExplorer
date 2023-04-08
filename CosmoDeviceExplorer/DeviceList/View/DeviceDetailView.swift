//
//  DeviceDetailView.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 31/03/2023.
//

import SwiftUI

struct DeviceDetailView: View {
    var deviceViewModel: DeviceViewModel
    
    var body: some View {
        Form {
            Section {
                if let product = deviceViewModel.product {
                    DeviceDetailCellView(title: "Product", value: product)
                }
                DeviceDetailCellView(title: "Mac Address", value: deviceViewModel.macAddress)
                DeviceDetailCellView(title: "Firmware Version", value: deviceViewModel.firmwareVersion)
                if let serial = deviceViewModel.serial {
                    DeviceDetailCellView(title: "Serial", value: serial)
                }
            }

            if let installationMode = deviceViewModel.installationMode {
                Section(header: Text("Installation Mode")) {
                    Text(installationMode)
                }
            }
            
            Section(header: Text("Lights")) {
                if let lightMode = deviceViewModel.lightMode {
                    DeviceDetailCellView(title: "Light Mode", value: lightMode)
                }
                DeviceDetailCellView(title: "Brake Light", value: deviceViewModel.brakeLight)
                DeviceDetailCellView(title: "Light Auto", value: deviceViewModel.lightAuto)
                DeviceDetailCellView(title: "Light Value", value: deviceViewModel.lightValue)
            }
        }
        .navigationTitle(deviceViewModel.model)
    }
}

struct DeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetailView(deviceViewModel: PreviewDataDeviceList.deviceViewModel)
    }
}
