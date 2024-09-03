//
//  HealthDataView.swift
//  BVOY Demo
//
//  Created by Sahil S on 02/09/24.
//

import SwiftUI

struct HealthDataView<T: HealthData>: View {
    @StateObject private var viewModel: HealthDataViewModel<T>
    @State private var selectedData: T?
    @State private var isTouching = false
    
    init() {
        let repository = HealthDataRepository(dataSource: AppConfig.getHealthDataSource(for: T.self))
        _viewModel = StateObject(wrappedValue: HealthDataViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                QuerySelector(
                    selectedQuery: Binding(
                        get: { self.viewModel.currentQuery },
                        set: { self.viewModel.currentQuery = $0 }
                    ),
                    onQuerySelect: viewModel.fetchHealthData
                )
                
                Text(viewModel.currentQuery.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                healthChartView
                
                if let selectedData = selectedData, isTouching {
                    HealthDataDetailView(healthData: selectedData)
                }
                
                Spacer()
            }
            .padding(.top, 20)
            .onAppear {
                viewModel.fetchHealthData(for: viewModel.currentQuery)
            }
            .navigationTitle("\(T.getRawVal())")
        }
    }
    
    private var healthChartView: some View {
        VStack(alignment: .leading) {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                ErrorView(error: error)
            } else if viewModel.healthData.isEmpty {
                Text("No data available")
                    .foregroundColor(.secondary)
            } else {
                HealthDataChart(
                    healthData: viewModel.healthData,
                    selectedData: $selectedData,
                    isTouching: $isTouching
                )
            }
        }
    }
}
