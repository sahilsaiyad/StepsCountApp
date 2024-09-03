//
//  HealthKitStepCountDataSource.swift
//  BVOY Demo
//
//  Created by Sahil Saiyed on 27/08/24.
//

import Foundation
import HealthKit

class HealthKitDataSource<T: HealthData>: HealthDataSource {
    typealias DataType = T
    
    private let healthStore = HKHealthStore()
    private var authorizationStatus: HealthKitAuthorizationStatus = .notDetermined
    
    private func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw NSError(domain: "HealthKitError", code: 0, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available on this device"])
        }
        
        do {
            try await healthStore.requestAuthorization(toShare: [], read: [T.healthKitSampleType])
            authorizationStatus = .authorized
            print("HealthKit authorization succeeded")
        } catch {
            authorizationStatus = .denied
            throw error
        }
    }
    
    private func checkAuthorization() async throws {
        switch authorizationStatus {
        case .notDetermined:
            try await requestAuthorization()
        case .authorized:
            return
        case .denied:
            throw NSError(domain: "HealthKitError", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit authorization has been denied"])
        }
    }
    
    func fetchData(from startDate: Date, to endDate: Date) async throws -> [T] {
        try await checkAuthorization()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: T.healthKitSampleType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let samples = samples else {
                    continuation.resume(returning: [])
                    return
                }
                                
                let healthData = samples.compactMap { sample -> T? in
                    switch sample {
                        //For quantity samples like steps and heart rate
                    case let quantitySample as HKQuantitySample:
                        let value = quantitySample.quantity.doubleValue(for: T.healthKitUnit)
                        return T.create(startDate: sample.startDate, endDate: sample.endDate, value: value)
                        //For category samples like sleep
                    case let categorySample as HKCategorySample:
                        return T.create(startDate: sample.startDate, endDate: sample.endDate, value: Double(categorySample.value))
                    default:
                        return nil
                    }
                }
                
                continuation.resume(returning: healthData)
            }
            
            self.healthStore.execute(query)
        }
    }
}

enum HealthKitAuthorizationStatus {
    case notDetermined
    case authorized
    case denied
}
