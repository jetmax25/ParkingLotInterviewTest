//
//  ParkingLot.swift
//  ParkingLotInterviewTest
//
//  Created by Michael Isasi on 7/19/23.
//

import Foundation

struct ParkingLot {
    ///How many spots of each space exist
    typealias SpotAvailability = [Space: Int]
    ///Vehicles with counts
    typealias SpotInfo = [Vehicle: Int]
    ///Vehicles with counts per space
    typealias ParkingInfo = [Space: SpotInfo]
    
    let totalSpots: SpotAvailability
    var takenSpots: ParkingInfo
    
    init(compactSpots: UInt, standardSpots: UInt, largeSpots: UInt) {
        totalSpots = [
            .compact: Int(compactSpots),
            .standard: Int(standardSpots),
            .large: Int(largeSpots)
        ]
        takenSpots = .init()
    }
}

extension ParkingLot {
    var currentState: State {
        let currentSpace = Array(totalSpots.keys).reduce(into: SpotAvailability()) { result, space in
            result[space] = countForSpace(space)
        }
        
        if totalSpots == currentSpace {
            return .empty(currentSpace)
        }
        
        if currentSpace.values.allSatisfy({ $0 == 0 }) {
            return .full
        }
        
        return .hasSpaces(currentSpace)
    }
    
    var remainingSpots: SpotAvailability {
        Array(totalSpots.keys).reduce(into: SpotAvailability()) { result, space in
            result[space] = remainingCount(at: space)
        }
    }
}

extension ParkingLot {
    private func countForSpace(_ space: Space) -> Int {
        guard let spotsForSpace = takenSpots[space] else { return 0 }
        return spotsForSpace.reduce(0) { result, vehicleCountPair in
            result + vehicleCountPair.value * (countCost(of: vehicleCountPair.key, at: space) ?? 0)
        }
    }
    
    private func currentCount(for vehicle: Vehicle, at space: Space) -> Int {
        vehicle.possibleSpots.first { $0.0 == space }?.1 ?? 0
    }
    
    private func countCost(of vehicle: Vehicle, at space: Space) -> Int? {
        vehicle.possibleSpots.first(where: { $0.space == space })?.count
    }
    
    private func remainingCount(at space: Space) -> Int {
        totalSpots[space, default: 0] - countForSpace(space)
    }
    
    private func hasSpace(for vehicle: Vehicle, at space: Space) -> Bool {
        guard let countRequired = countCost(of: vehicle, at: space) else { return false }
        return remainingCount(at: space) >= countRequired
    }
    
    private func bestSpaceToAdd(vehicle: Vehicle) -> Space? {
        vehicle.possibleSpots.first(where: { hasSpace(for: vehicle, at: $0.space) })?.space
    }
    
    private func bestSpaceToRemove(vehicle: Vehicle) -> Space? {
        vehicle.possibleSpots.last(where: { (takenSpots[$0.space]?[vehicle] ?? 0) > 0 })?.space
    }
}

//: MARK: Mutating Functions
extension ParkingLot {
    mutating func add(vehicle: Vehicle) -> Bool {
        guard let space = bestSpaceToAdd(vehicle: vehicle) else { return false }
        takenSpots[space, default: [vehicle: 0]][vehicle, default: 0] += 1
        return true
    }
    
    mutating func remove(vehicle: Vehicle) -> Bool {
        guard let space = bestSpaceToRemove(vehicle: vehicle) else { return false }
        takenSpots[space, default: [vehicle: 0]][vehicle, default: 0] -= 1
        return true
    }
}
