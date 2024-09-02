//
//  JSONStepCountDataSource.swift
//  BVOY Demo
//
//  Created by Sahil Saiyed on 27/08/24.
//

import Foundation

class JSONDataSource<T: HealthData>: HealthDataSource {
    typealias DataType = T
    
    private let jsonFileName: String
    
    init(jsonFileName: String) {
        self.jsonFileName = jsonFileName
    }
    
    private func loadJSONData() -> [T] {
        guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return []
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return (try? decoder.decode([T].self, from: data)) ?? []
    }
    
    func fetchData(from startDate: Date, to endDate: Date) async throws -> [T] {
        let allData = loadJSONData()
        return allData.filter { $0.startDate >= startDate && $0.endDate <= endDate }
    }
}
