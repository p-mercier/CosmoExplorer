//
//  DiscoveredPeripheralManager.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 05/04/2023.
//

import Foundation
import CoreData

class DiscoveredPeripheralManager {
    var discoveredPeripheralHistory: [UUID] = []
    var newlyDiscoveredPeripherals: [UUID: DiscoveredPeripheralModel] = [:]

    init() {
        load()
    }

    private func load() {
        self.discoveredPeripheralHistory = getDiscoveredPeripheralHistory()
        self.newlyDiscoveredPeripherals = [:]
    }

    private func getDiscoveredPeripheralHistory() -> [UUID] {
        let managedObjectContext = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<DiscoveredPeripheral> = DiscoveredPeripheral.fetchRequest()
        let objects = (try? managedObjectContext.fetch(fetchRequest)) ?? []
        
        var result: [UUID] = []
        for object in objects {
            if let id = object.identifier {
                result.append(id)
            }
        }
        return result
    }

    func processBleDevices(bleDeviceModels: [BleDeviceModel]) {
        for bleDeviceModel in bleDeviceModels {
            let peripheral = bleDeviceModel.peripheral
            if isNewlyDiscoveredPeripheral(uuid: peripheral.identifier) {
                if newlyDiscoveredPeripherals[peripheral.identifier] == nil {
                    newlyDiscoveredPeripherals[peripheral.identifier] = DiscoveredPeripheralModel(identifier: peripheral.identifier, discoveryDate: Date())
                }
            }
        }
    }

    func isNewlyDiscoveredPeripheral(uuid: UUID?) -> Bool {
        guard let uuid = uuid else { return false }

        if discoveredPeripheralHistory.contains(uuid) {
            return false
        }
        return true
    }

    func save() {
        for (_, value) in newlyDiscoveredPeripherals {
            let managedObjectContext = PersistenceController.shared.container.viewContext
            let discoveredPeripheral = DiscoveredPeripheral(context: managedObjectContext)
            discoveredPeripheral.identifier = value.identifier
            discoveredPeripheral.discoveryDate = value.discoveryDate
            PersistenceController.shared.save()
        }
        load()
    }
}
