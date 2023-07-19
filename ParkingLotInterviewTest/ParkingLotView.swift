//
//  ContentView.swift
//  ParkingLotInterviewTest
//
//  Created by Michael Isasi on 7/19/23.
//

import SwiftUI

struct ParkingLotView: View {
    enum Constants {
        static let headerWidth: CGFloat = 90
        static let infoHeight: CGFloat = 50
    }
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Total Spots")
                    .frame(width: Constants.headerWidth)
                    .font(.headline)
                SpaceListView(spaceCounts: viewModel.totalSpots)
                    .frame(height: Constants.infoHeight)
            }
            Divider()
            HStack {
                Text("Remaining Spots")
                    .frame(width: Constants.headerWidth)
                    .font(.headline)
                SpaceListView(spaceCounts: viewModel.remainingSpots)
                    .frame(height: Constants.infoHeight)
            }
            Divider()
            CurrentParkedCarsView(parkedCars: viewModel.parkedCars)
                .frame(height: 200)
            VStack(spacing: 24) {
                Text("Starting Numbers")
                    .font(.headline)
                HStack {
                    VStack(spacing: 0) {
                        Text("Compact")
                        TextField("Compact", value: $viewModel.startingCompact, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                    }
                    VStack(spacing: 0) {
                        Text("Standard")
                        TextField("Standard", value: $viewModel.startingStandard, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .padding()
                    }
                    VStack(spacing: 0) {
                        Text("Large")
                        TextField("Large", value: $viewModel.startingLarge, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                    }
                    .keyboardType(.numberPad)
                }
                Button("Reset Parking Lot") {
                    viewModel.reset()
                }
            }
            Spacer()
            VStack {
                VStack {
                    Text("Add")
                    HStack {
                        Spacer()
                        Button("Motorcycle") {
                            viewModel.add(vehicle: .motorcycle)
                        }
                        Spacer()
                        Button("Car") {
                            viewModel.add(vehicle: .car)
                        }
                        Spacer()
                        Button("Van") {
                            viewModel.add(vehicle: .van)
                        }
                        Spacer()
                    }
                }
                Divider()
                VStack {
                    Text("Remove")
                    HStack {
                        Spacer()
                        Button("Motorcycle") {
                            viewModel.remove(vehicle: .motorcycle)
                        }
                        Spacer()
                        Button("Car") {
                            viewModel.remove(vehicle: .car)
                        }
                        Spacer()
                        Button("Van") {
                            viewModel.remove(vehicle: .van)
                        }
                        Spacer()
                    }
                }
            }
            .font(.title)
        }
        .padding()
        .alert("Could Not Add \(viewModel.failedVehicle?.rawValue.capitalized ?? "N/A")", isPresented: $viewModel.didFailAdd) {
            Button("OK", role: .cancel) { }
        }
        .alert("Could Not Remove \(viewModel.failedVehicle?.rawValue.capitalized ?? "N/A")", isPresented: $viewModel.didFailRemove) {
            Button("OK", role: .cancel) { }
        }
    }
}

struct ParkingLotView_Previews: PreviewProvider {
    static var previews: some View {
        ParkingLotView()
    }
}

extension ParkingLotView {
    class ViewModel: ObservableObject {
        @Published private var parkingLot: ParkingLot
        @Published var didFailAdd: Bool = false
        @Published var didFailRemove: Bool = false
        
        var startingCompact: Int = 10
        var startingStandard: Int = 10
        var startingLarge: Int = 10
        
        var failedVehicle: Vehicle?
        
        init() {
            self.parkingLot = ParkingLot(
                compactSpots: UInt(max(startingCompact, .zero)),
                standardSpots: UInt(max(startingStandard, .zero)),
                largeSpots: UInt(max(startingLarge, .zero))
            )
        }
        
        func add(vehicle: Vehicle) {
            let success = parkingLot.add(vehicle: vehicle)
            if !success {
                failedVehicle = vehicle
                didFailAdd = true
            }
        }
        
        func remove(vehicle: Vehicle) {
            let success = parkingLot.remove(vehicle: vehicle)
            if !success {
                failedVehicle = vehicle
                didFailRemove = true
            }
        }
        
        var totalSpots: ParkingLot.SpotAvailability {
            parkingLot.totalSpots
        }
        
        var remainingSpots: ParkingLot.SpotAvailability {
            parkingLot.remainingSpots
        }
        
        var parkedCars: ParkingLot.ParkingInfo {
            parkingLot.takenSpots
        }
        
        func reset() {
            self.parkingLot = ParkingLot(
                compactSpots: UInt(max(startingCompact, .zero)),
                standardSpots: UInt(max(startingStandard, .zero)),
                largeSpots: UInt(max(startingLarge, .zero))
            )
        }
    }
}
