//
//  StepCountViewModel.swift
//  BVOY Demo
//
//  Created by Sahil Saiyed on 27/08/24.
//

import SwiftUI

class StepCountViewModel: ObservableObject {
    @Published private(set) var stepCounts: [StepCount] = []
    private let repository: StepCountRepository
    
    init(repository: StepCountRepository) {
        self.repository = repository
    }
    
    func fetchStepCounts(from startDate: Date, to endDate: Date) {
        Task {
            do {
                let fetchedStepCounts = try await repository.fetchStepCounts(from: startDate, to: endDate)
                await MainActor.run {
                    self.stepCounts = fetchedStepCounts.sorted { $0.startDate < $1.startDate }
                }
            } catch {
                print("Error fetching step counts: \(error)")
                await MainActor.run {
                    self.stepCounts = []
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
