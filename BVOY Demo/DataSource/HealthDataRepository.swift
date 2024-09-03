//
//  HealthDataRepositoryImpl.swift
//  BVOY Demo
//
//  Created by Sahil S on 01/09/24.
//

import Foundation

class HealthDataRepository<T: HealthData> {
    private let primaryDataSource: any HealthDataSource<T>
    private let cdDataSource: CDDataSource<T>
    
    init(primaryDataSource: any HealthDataSource<T>) {
        self.primaryDataSource = primaryDataSource
        self.cdDataSource = CDDataSource<T>()
    }
    
    func fetchData(from startDate: Date, to endDate: Date) async throws -> [T] {
        // First, try to fetch from Core Data
        let cachedData = try await cdDataSource.fetchData(from: startDate, to: endDate)
        
        if !cachedData.isEmpty {
            return cachedData
        }
        
        // If no cached data, fetch from primary source
        let freshData = try await primaryDataSource.fetchData(from: startDate, to: endDate)
        
        // Cache the fresh data
        try await cdDataSource.saveData(freshData, from: startDate, to: endDate)
        
        return freshData
    }
}

