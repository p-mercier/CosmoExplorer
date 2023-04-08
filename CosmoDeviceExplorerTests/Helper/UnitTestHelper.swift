//
//  UnitTestHelper.swift
//  CosmoDeviceExplorerTests
//
//  Created by Philippe Mercier on 01/04/2023.
//

import Foundation

final class UnitTestHelper {
    static func loadJson(filename fileName: String) -> Data? {
        if let url = Bundle(for: UnitTestHelper.self).url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                return data
            } catch {
                return nil
            }
        }
        return nil
    }
}
