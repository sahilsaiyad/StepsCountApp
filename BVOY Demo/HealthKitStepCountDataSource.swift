//
//  HealthKitStepCountDataSource.swift
//  BVOY Demo
//
//  Created by Sahil Saiyed on 27/08/24.
//

import Foundation
import HealthKit

class HealthKitStepCountDataSource: StepCountDataSource {
    private let healthStore = HKHealthStore()
    
    init() {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device")
            return
        }
        
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        healthStore.requestAuthorization(toShare: [], read: [stepCountType]) { success, error in
            if let error = error {
                print("HealthKit authorization failed: \(error.localizedDescription)")
            } else if success {
                print("HealthKit authorization succeeded")
            } else {
                print("HealthKit authorization denied")
            }
        }
    }
    
    func fetchStepCounts(from startDate: Date, to endDate: Date) async throws -> [StepCount] {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: stepCountType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let samples = samples as? [HKQuantitySample] else {
                    continuation.resume(returning: [])
                    return
                }
                
                let stepCounts = samples.map { sample in
                    StepCount(startDate: sample.startDate, endDate: sample.endDate, count: Int(sample.quantity.doubleValue(for: .count())))
                }
                
                continuation.resume(returning: stepCounts)
            }
            
            self.healthStore.execute(query)
        }
    }
}
