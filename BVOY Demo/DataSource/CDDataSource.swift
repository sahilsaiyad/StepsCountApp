//
//  CDDataSource.swift
//  BVOY Demo
//
//  Created by Sahil S on 03/09/24.
//

import CoreData
import HealthKit

class CDDataSource<T: HealthData>: HealthDataSource {
    private let cdManager: CDManager = .shared

    func fetchData(from startDate: Date, to endDate: Date) async throws -> [T] {
        guard let modelURL = Bundle.main.url(forResource: "HealthDataModel", withExtension: "momd") else { return [] }
        
        let context = cdManager.newBackgroundContext()
        
        return try await context.perform {
            let fetchRequest: NSFetchRequest<QueryResult> = QueryResult.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "startDate == %@ AND endDate == %@ AND type == %@",
                                                 startDate as NSDate,
                                                 endDate as NSDate,
                                                 T.getRawVal())
            
            guard let result = try context.fetch(fetchRequest).first else {
                return []
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode([T].self, from: result.data)
        }
    }

    func saveData(_ data: [T], from startDate: Date, to endDate: Date) async throws {
        guard let modelURL = Bundle.main.url(forResource: "HealthDataModel", withExtension: "momd") else { return }
        
        let context = cdManager.newBackgroundContext()
        
        try await context.perform {
            let fetchRequest: NSFetchRequest<QueryResult> = QueryResult.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "startDate == %@ AND endDate == %@ AND type == %@",
                                                 startDate as NSDate,
                                                 endDate as NSDate,
                                                 T.getRawVal())
            
            let queryResult = try context.fetch(fetchRequest).first ?? QueryResult(context: context)
            queryResult.startDate = startDate
            queryResult.endDate = endDate
            queryResult.type = T.getRawVal()
            
            queryResult.data = try JSONEncoder().encode(data)
            
            try context.save()
        }
    }
}
