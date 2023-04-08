//
//  DeviceCellView.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 31/03/2023.
//

import SwiftUI

struct DeviceCellView: View {
    let deviceViewModel: DeviceViewModel

    var body: some View {
        GroupBox {
            ZStack(alignment: .topLeading) {
                HStack {
                    if let icon = deviceViewModel.iconName {
                        Image(icon)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.primary)
                            .cornerRadius(25)
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text(deviceViewModel.model)
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            if let product = deviceViewModel.product {
                                Text(product)
                                    .font(.headline)
                            }
                        }
                    }
                    .padding(.horizontal, 4.0)
                    .frame(height: 56)
                    Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                }
            }
        }
        .foregroundColor(.primary)
    }
}

struct DeviceCellView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceCellView(deviceViewModel: PreviewDataDeviceList.deviceViewModel)
            .previewLayout(.sizeThatFits)
    }
}
