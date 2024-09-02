//
//  HealthDataRepositoryImpl.swift
//  BVOY Demo
//
//  Created by Sahil S on 01/09/24.
//

import Foundation

class HealthDataRepository<T: HealthData> {
    private let dataSource: any HealthDataSource<T>
    
    init(dataSource: any HealthDataSource<T>) {
        self.dataSource = dataSource
    }
    
    func fetchData(from startDate: Date, to endDate: Date) async throws -> [T] {
        return try await dataSource.fetchData(from: startDate, to: endDate)
    }
}

