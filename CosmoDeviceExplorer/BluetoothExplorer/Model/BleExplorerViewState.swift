//
//  BleExplorerViewState.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 01/04/2023.
//

import Foundation

enum BleExplorerViewState: Equatable {
    case initialize
    case scanning
    case stopped
    case bluetoothError(description: String)
}
