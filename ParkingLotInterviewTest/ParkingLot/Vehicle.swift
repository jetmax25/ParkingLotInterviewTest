//
//  Vehicle.swift
//  ParkingLotInterviewTest
//
//  Created by Michael Isasi on 7/19/23.
//

import Foundation

enum Vehicle: String, CaseIterable {
    case motorcycle
    case car
    case van
}

extension Vehicle {
    var possibleSpots: [(space: ParkingLot.Space, count: Int)] {
        switch self {
        case .motorcycle: return [(.compact, 1), (.standard, 1), (.large, 1)]
        case .car: return [(.compact, 1), (.standard, 1)]
        case .van: return [(.large, 1), (.standard, 3)]
        }
    }
}
