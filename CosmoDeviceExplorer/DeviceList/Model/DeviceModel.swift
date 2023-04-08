//
//  DeviceModel.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 30/03/2023.
//

import Foundation

struct DeviceModel: Codable {
    let macAddress: String
    let model: String
    let product: String?
    let firmwareVersion: String
    let serial: String?
    let installationMode: InstallationMode?
    let brakeLight: Bool
    let lightMode: LightMode?
    let lightAuto: Bool
    let lightValue: Int
    
    func getIconName() -> String? {
        if model == "RIDE" {
            return "cosmo_ride"
        } else if model == "REMOTE" {
            return "cosmo_remote"
        } else if model == "VISION" {
            return "cosmo_vision"
        }
        return nil
    }
}

enum LightMode: String, Codable {
    case OFF
    case WARNING
    case POSITION
    case BOTH

    func getDescription() -> String {
        return rawValue.capitalized
    }
}

enum InstallationMode: String, Codable {
    case helmet
    case seat

    func getDescription() -> String {
        switch self {
        case .helmet:
            return "Helmet"
        case .seat:
            return "Seat"
        }
    }
}
