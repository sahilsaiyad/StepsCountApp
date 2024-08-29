//
//  JSONStepCountDataSource.swift
//  BVOY Demo
//
//  Created by Sahil Saiyed on 27/08/24.
//

import Foundation

class JSONStepCountDataSource: StepCountDataSource {
    private let jsonFileName = "StepCounts"
    
    private func loadJSONData() -> [StepCount] {
        guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return []
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return (try? decoder.decode([StepCount].self, from: data)) ?? []
    }
    
    func fetchStepCounts(from startDate: Date, to endDate: Date) async throws -> [StepCount] {
        let allStepCounts = loadJSONData()
        return allStepCounts.filter { $0.startDate >= startDate && $0.endDate <= endDate }
    }
}
