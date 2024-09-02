//
//  HealthDataChartView.swift
//  BVOY Demo
//
//  Created by Sahil S on 02/09/24.
//

//import SwiftUI
//
//struct HealthDataChartView<T: HealthData>: View {
//    @ObservedObject var viewModel: HealthDataViewModel<T>
//    @Binding var selectedData: (any HealthData)?
//    @Binding var isTouching: Bool
//
//    var body: some View {
//        Group {
//            if viewModel.isLoading {
//                ProgressView()
//            } else if let error = viewModel.error {
//                ErrorView(error: error)
//            } else if viewModel.healthData.isEmpty {
//                Text("No data available")
//                    .foregroundColor(.secondary)
//            } else {
//                HealthDataChart(healthData: viewModel.healthData, selectedData: $selectedData, isTouching: $isTouching)
//            }
//        }
//    }
//}
