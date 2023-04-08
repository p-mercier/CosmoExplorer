//
//  DateFormatter+Extension.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 30/03/2023.
//

import Foundation

extension DateFormatter {
    static let mainDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
}
