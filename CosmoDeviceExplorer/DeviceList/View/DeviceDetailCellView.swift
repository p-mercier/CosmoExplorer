//
//  DeviceDetailCellView.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 01/04/2023.
//

import SwiftUI

struct DeviceDetailCellView: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value).foregroundColor(.gray)
        }
    }
}

struct DeviceDetailCellView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetailCellView(title: "Version", value: "2.2.1")
    }
}
