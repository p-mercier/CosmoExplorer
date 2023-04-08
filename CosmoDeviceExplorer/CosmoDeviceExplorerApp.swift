//
//  CosmoDeviceExplorerApp.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 30/03/2023.
//

import SwiftUI

@main
struct CosmoDeviceExplorerApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var networkMonitor = NetworkMonitor()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkMonitor)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
