//
//  SpaceListView.swift
//  ParkingLotInterviewTest
//
//  Created by Michael Isasi on 7/19/23.
//

import SwiftUI

struct SpaceListView: View {
    let spaceCounts: ParkingLot.SpotAvailability
    
    var body: some View {
        HStack {
            ForEach(ParkingLot.Space.allCases, id: \.self) { space in
                VStack {
                    Text(space.rawValue.capitalized)
                        .font(.subheadline)
                    Text("\(spaceCounts[space, default: 0])")
                        .font(.title2)
                }
                .frame(maxWidth: .infinity)
                Divider()
            }
        }
    }
}

struct SpaceListView_Previews: PreviewProvider {
    static var previews: some View {
        SpaceListView(spaceCounts: [.compact: 1, .standard: 1, .large: 1])
    }
}
