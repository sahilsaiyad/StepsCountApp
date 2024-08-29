//
//  StepCountRepository.swift
//  BVOY Demo
//
//  Created by Sahil Saiyed on 27/08/24.
//
import Foundation

class StepCountRepository {
    private let dataSource: StepCountDataSource
    
    init(dataSource: StepCountDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchStepCounts(from startDate: Date, to endDate: Date) async throws -> [StepCount] {
        return try await dataSource.fetchStepCounts(from: startDate, to: endDate)
    }
}
