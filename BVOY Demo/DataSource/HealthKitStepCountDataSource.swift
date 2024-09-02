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
    private let quantityType = HKQuantityType.quantityType(forIdentifier: T.healthKitTypeIdentifier)!
    private let unit = T.healthKitUnit
    
    init() {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device")
            return
        }
        
        healthStore.requestAuthorization(toShare: [], read: [quantityType]) { success, error in
            if let error = error {
                print("HealthKit authorization failed: \(error.localizedDescription)")
            } else if success {
                print("HealthKit authorization succeeded")
            } else {
                print("HealthKit authorization denied")
            }
        }
    }
    
    func fetchData(from startDate: Date, to endDate: Date) async throws -> [T] {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: quantityType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let samples = samples as? [HKQuantitySample] else {
                    continuation.resume(returning: [])
                    return
                }
                
                let healthData = samples.compactMap { sample -> T? in
                    let value = sample.quantity.doubleValue(for: self.unit)
                    return T.create(startDate: sample.startDate, endDate: sample.endDate, value: value)
                }
                
                continuation.resume(returning: healthData)
            }
            
            self.healthStore.execute(query)
        }
    }
}
