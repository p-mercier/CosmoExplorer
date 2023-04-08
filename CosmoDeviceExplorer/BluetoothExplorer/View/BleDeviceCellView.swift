//
//  BleDeviceCellView.swift
//  CosmoDeviceExplorer
//
//  Created by Philippe Mercier on 02/04/2023.
//

import SwiftUI

struct BleDeviceCellView: View {
    let bleDeviceViewModel: BleDeviceViewModel

    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    if bleDeviceViewModel.isNewlyDiscovered {
                        Text("🎉 You found this device for the first time 🎉")
                            .fontWeight(.semibold)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                    }

                    Text(bleDeviceViewModel.name)
                        .font(.title)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(bleDeviceViewModel.id.uuidString)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)

                    if let peripheralAdvertisedData = bleDeviceViewModel.advertisedDataFormatted {
                        Text(peripheralAdvertisedData)
                    }
                }
                .padding(.bottom, 10.0)

                if bleDeviceViewModel.getServices().isEmpty == false {
                    ForEach(values: bleDeviceViewModel.getServices()) { service in
                        VStack(alignment: .leading){
                            Text("Service")
                                .font(.title2)
                                .fontWeight(.semibold)

                            Text(service)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .minimumScaleFactor(0.2)
                                .lineLimit(1)

                            if bleDeviceViewModel.getCharacteristicsForService(service: service).isEmpty == false {
                                Text("Characteristics")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)

                                ForEach(values: bleDeviceViewModel.getCharacteristicsForService(service: service)) { characteristic in
                                    Text(characteristic)
                                        .foregroundColor(.gray)
                                        .minimumScaleFactor(0.5)
                                        .lineLimit(1)
                                }
                            }
                        }
                        .padding(.bottom, 10.0)
                    }
                }
            }
        }
    }
}


struct BleDeviceCellView_Previews: PreviewProvider {
    static var previews: some View {
        BleDeviceCellView(bleDeviceViewModel: BleDeviceViewModel(bleDeviceModel: BleDeviceModel(name: "Name", peripheral: PeripheralPreview()), isNewlyDiscovered: false))
    }
}
