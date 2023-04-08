//
//  BleExplorerView.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 01/04/2023.
//

import SwiftUI

struct BleExplorerView: View {
    @StateObject private var bleExplorerViewModel: BleExplorerViewModel

    init(bleExplorerViewModel: BleExplorerViewModel = .init()) {
        _bleExplorerViewModel = StateObject(wrappedValue: bleExplorerViewModel)
    }

    var body: some View {
        NavigationView {
            VStack {
                switch(bleExplorerViewModel.state) {
                case .initialize:
                    Button(action: {
                        bleExplorerViewModel.startScan()
                    }) {
                        Text("Scan")
                            .frame(width: 150, height: 150)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                case .scanning, .stopped:
                    if bleExplorerViewModel.bleDeviceViewModels.count == 0 {
                        if bleExplorerViewModel.state == .scanning {
                            Text("Scanning ...")
                        } else {
                            Text("No device found ...")
                        }
                    } else {
                        ScrollView {
                            LazyVStack {
                                ForEach(bleExplorerViewModel.bleDeviceViewModels, id: \.id) { bleDeviceViewModel in
                                    BleDeviceCellView(bleDeviceViewModel: bleDeviceViewModel)
                                }
                            }
                        }
                    }

                    Button(action: {
                        if bleExplorerViewModel.state == .scanning {
                            self.bleExplorerViewModel.stopScan()
                        } else {
                            self.bleExplorerViewModel.startScan()
                        }
                    }) {
                        if bleExplorerViewModel.state == .scanning {
                            Text("Stop Scan")
                        } else {
                            Text("Restart Scan")
                        }
                    }
                    .foregroundColor(Color.white)
                    .padding()
                    .background(bleExplorerViewModel.state == .scanning ? Color.red : Color.blue)
                    .cornerRadius(5.0)
                case .bluetoothError(description: let description):
                    Text(description)
                }
            }
            .navigationTitle("Nearby devices")
        }
    }
}

struct BleExplorerView_Previews: PreviewProvider {
    static var previews: some View {
        BleExplorerView()
    }
}
