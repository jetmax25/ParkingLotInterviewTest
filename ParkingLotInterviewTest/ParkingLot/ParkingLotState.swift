//
//  ParkingLotState.swift
//  ParkingLotInterviewTest
//
//  Created by Michael Isasi on 7/19/23.
//

import Foundation


extension ParkingLot {
    enum State {
        case full
        case empty([Space: Int])
        case hasSpaces([Space: Int])
    }
}

extension ParkingLot.State: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.full, .full): return true
        case let (.empty(lhsRemaining), .empty(rhsRemaining)): return lhsRemaining == rhsRemaining
        case let (.hasSpaces(lhsRemaining), .hasSpaces(rhsRemaining)): return lhsRemaining == rhsRemaining
        default: return false
        }
    }
}
