//
//  HealthDataViewModel.swift
//  BVOY Demo
//
//  Created by Sahil S on 31/08/24.
//

import SwiftUI

class HealthDataViewModel<T: HealthData>: ObservableObject {
    @Published var currentQuery: QueryType {
        didSet {
            // Save to UserDefaults whenever currentQuery changes
            UserDefaults.standard.setValue(currentQuery.rawValue, forKey: "\(T.getRawVal()) currentQuery")
        }
    }
    @Published var healthData: [T] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let repository: HealthDataRepository<T>
    
    init(repository: HealthDataRepository<T>) {
        self.repository = repository
        
        // Load currentQuery from last session
        if let savedQueryRawValue = UserDefaults.standard.string(forKey: "\(T.getRawVal()) currentQuery"),
           let savedQuery = QueryType(rawValue: savedQueryRawValue) {
            self.currentQuery = savedQuery
        } else {
            self.currentQuery = .query1
        }
    }
    
    func fetchHealthData(for query: QueryType) {
        currentQuery = query
        let (startDate, endDate) = query.dateRange
        fetchHealthData(from: startDate, to: endDate)
    }
    
    func fetchHealthData(from startDate: Date, to endDate: Date) {
        isLoading = true
        error = nil
        
        Task {
            do {
                let fetchedData = try await repository.fetchData(from: startDate, to: endDate)
                await MainActor.run {
                    self.healthData = fetchedData.sorted { $0.startDate < $1.startDate }
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.healthData = []
                    self.isLoading = false
                }
            }
        }
    }
}
