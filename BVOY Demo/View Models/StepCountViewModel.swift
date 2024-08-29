//
//  StepCountViewModel.swift
//  BVOY Demo
//
//  Created by Sahil Saiyed on 27/08/24.
//

import SwiftUI

class StepCountViewModel: ObservableObject {
    @Published private(set) var stepCounts: [StepCount] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let repository: StepCountRepository
    
    init(repository: StepCountRepository) {
        self.repository = repository
    }
    
    func fetchStepCounts(from startDate: Date, to endDate: Date) {
        isLoading = true
        error = nil
        
        Task {
            do {
                let fetchedStepCounts = try await repository.fetchStepCounts(from: startDate, to: endDate)
                await MainActor.run {
                    self.stepCounts = fetchedStepCounts.sorted { $0.startDate < $1.startDate }
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.stepCounts = []
                    self.isLoading = false
                }
            }
        }
    }
}

extension StepCountViewModel {
    func fetchStepCounts(for query: QueryType) {
        let (start, end) = query.dateRange
        fetchStepCounts(from: start, to: end)
    }
}
