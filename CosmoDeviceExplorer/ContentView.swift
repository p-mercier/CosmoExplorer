//
//  ContentView.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 30/03/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DeviceListView()
                .tabItem {
                    Label("Cosmo Devices", systemImage: "bolt.horizontal")
                }
            BleExplorerView()
                .tabItem {
                    Label("Nearby Devices", systemImage: "wave.3.right")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
