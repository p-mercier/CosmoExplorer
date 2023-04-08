//
//  ForEach+Extension.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 02/04/2023.
//

import SwiftUI


extension ForEach where Data.Element: Hashable, ID == Data.Element, Content: View {
    init(values: Data, content: @escaping (Data.Element) -> Content) {
        self.init(values, id: \.self, content: content)
    }
}
