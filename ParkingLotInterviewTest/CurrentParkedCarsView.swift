//
//  CurrentParkedCarsView.swift
//  ParkingLotInterviewTest
//
//  Created by Michael Isasi on 7/19/23.
//

import SwiftUI

struct CurrentParkedCarsView: View {
    let parkedCars: [ParkingLot.Space: [Vehicle: Int]]
    
    var body: some View {
        HStack {
            ForEach(ParkingLot.Space.allCases, id: \.self) { space in
                VStack {
                    Text(space.rawValue.capitalized)
                        .font(.headline)
                    List(Vehicle.allCases, id: \.self) { vehicle in
                        HStack(alignment: .center) {
                            Text(vehicle.rawValue.capitalized + ":")
                            Spacer()
                            Text("\(parkedCars[space]?[vehicle] ?? 0)")
                        }
                        .font(.caption)
                        .padding(.horizontal, -16)
                    }
                    .listStyle(.plain)
                }
                .frame(maxWidth: .infinity)
                if space != .large {
                    Divider()
                }
            }
        }
    }
}

struct CurrentParkedCarsView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentParkedCarsView(
            parkedCars: [
                .compact: [.van: 1]
            ]
        )
        .frame(width: 350)
    }
}
