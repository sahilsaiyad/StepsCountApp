//
//  ContentView.swift
//  BVOY Demo
//
//  Created by Sahil Saiyed on 27/08/24.
//

import SwiftUI
import Charts

struct ContentView: View {
    @StateObject private var stepViewModel: HealthDataViewModel<StepCount>
    @StateObject private var sleepViewModel: HealthDataViewModel<SleepData>
    @StateObject private var heartRateViewModel: HealthDataViewModel<HeartRateData>
    
    @State private var selectedDataType: HealthDataType = .steps
    @State private var selectedQuery: QueryType = .query1
    @State private var selectedData: (any HealthData)?
    @State private var isTouching: Bool = false
    
    init() {
        let stepRepository = HealthDataRepository(dataSource: AppConfig.getHealthDataSource(for: StepCount.self))
        let sleepRepository = HealthDataRepository(dataSource: AppConfig.getHealthDataSource(for: SleepData.self))
        let heartRateRepository = HealthDataRepository(dataSource: AppConfig.getHealthDataSource(for: HeartRateData.self))
        
        _stepViewModel = StateObject(wrappedValue: HealthDataViewModel(repository: stepRepository))
        _sleepViewModel = StateObject(wrappedValue: HealthDataViewModel(repository: sleepRepository))
        _heartRateViewModel = StateObject(wrappedValue: HealthDataViewModel(repository: heartRateRepository))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Picker("Health Data Type", selection: $selectedDataType) {
                    ForEach(HealthDataType.allCases) { dataType in
                        Text(dataType.rawValue).tag(dataType)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedDataType) { oldValue, newValue in
                    selectedData = nil
                }
                
                QuerySelector(selectedQuery: $selectedQuery, onQuerySelect: fetchHealthData)
                
                Text(selectedQuery.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                selectedDataView
                
                if let selectedData = selectedData, isTouching {
                    HealthDataDetailView(healthData: selectedData)
                }
                
                Spacer()
            }
            .padding(.top, 20)
            .navigationTitle("Health Data")
        }
        .onAppear {
            fetchHealthData(for: selectedQuery)
        }
    }
    
    @ViewBuilder
    private var selectedDataView: some View {
        switch selectedDataType {
        case .steps:
            healthDataView(viewModel: stepViewModel)
        case .sleep:
            healthDataView(viewModel: sleepViewModel)
        case .heartRate:
            healthDataView(viewModel: heartRateViewModel)
        }
    }
    
    private func healthDataView<T: HealthData>(viewModel: HealthDataViewModel<T>) -> some View {
        Group {
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
                    selectedData: Binding(
                        get: { self.selectedData as? T },
                        set: { self.selectedData = $0 }
                    ),
                    isTouching: $isTouching
                )
            }
        }
    }
    
    private func fetchHealthData(for query: QueryType) {
        let (startDate, endDate) = query.dateRange
        stepViewModel.fetchHealthData(from: startDate, to: endDate)
        sleepViewModel.fetchHealthData(from: startDate, to: endDate)
        heartRateViewModel.fetchHealthData(from: startDate, to: endDate)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
