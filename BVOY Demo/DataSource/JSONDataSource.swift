//
//  JSONStepCountDataSource.swift
//  BVOY Demo
//
//  Created by Sahil Saiyed on 27/08/24.
//

import Foundation

class JSONDataSource<T: HealthData>: HealthDataSource {
    typealias DataType = T
    private let jsonFileName: String = String(describing: T.self)
    
    private func loadJSONData() async throws -> [T] {
        guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") else {
            throw NSError(domain: "File not found", code: 404, userInfo: nil)
        }
        
        let data = try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let data = try Data(contentsOf: url)
                    continuation.resume(returning: data)
                } catch {
                    continuation.resume(throwing: NSError(domain: "Data couldn't be loaded", code: 100, userInfo: nil))
                }
            }
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode([T].self, from: data)
    }
    
    func fetchData(from startDate: Date, to endDate: Date) async throws -> [T] {
        let allData = try await loadJSONData()
        return allData.filter { $0.startDate >= startDate && $0.endDate <= endDate }
    }
}
