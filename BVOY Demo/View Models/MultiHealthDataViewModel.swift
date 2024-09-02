//
//  MultiHealthDataViewModel.swift
//  BVOY Demo
//
//  Created by Sahil S on 01/09/24.
//

import Foundation

class MultiHealthDataViewModel: ObservableObject {
    @Published var selectedDataType: HealthDataType = .steps
    @Published var selectedQuery: [HealthDataType: QueryType] = [.steps: .query1, .sleep: .query1, .heartRate: .query1]
    
    let stepViewModel: HealthDataViewModel<StepCount>
    let sleepViewModel: HealthDataViewModel<SleepData>
    let heartRateViewModel: HealthDataViewModel<HeartRateData>
    
    init() {
        self.stepViewModel = HealthDataViewModel(repository: HealthDataRepository(dataSource: AppConfig.getHealthDataSource(for: StepCount.self)))
        self.sleepViewModel = HealthDataViewModel(repository: HealthDataRepository(dataSource: AppConfig.getHealthDataSource(for: SleepData.self)))
        self.heartRateViewModel = HealthDataViewModel(repository: HealthDataRepository(dataSource: AppConfig.getHealthDataSource(for: HeartRateData.self)))
    }
    
    func fetchHealthData(for query: QueryType) {
        let (startDate, endDate) = query.dateRange
        
        stepViewModel.fetchHealthData(from: startDate, to: endDate)
//        sleepViewModel.fetchHealthData(from: startDate, to: endDate)
//        heartRateViewModel.fetchHealthData(from: startDate, to: endDate)
    }
}

enum HealthDataType: String, CaseIterable, Identifiable {
    case steps = "Steps"
    case sleep = "Sleep"
    case heartRate = "Heart Rate"
    
    var id: String { self.rawValue }
}
