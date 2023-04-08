//
//  CommonViewState.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 30/03/2023.
//

import Foundation

enum CommonViewState: Equatable {
    case initialize
    case empty
    case loading
    case loaded
    case loadingFailed(description: String)
}
