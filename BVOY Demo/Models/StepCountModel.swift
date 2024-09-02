//
//  StepCountModel.swift
//  BVOY Demo
//
//  Created by Sahil Saiyed on 27/08/24.
//

import Foundation
import HealthKit

struct StepCount: HealthData {
    typealias ValueType = Int
    
    let startDate: Date
    let endDate: Date
    let count: Int
    var id: Date { startDate }
    
    static let healthKitTypeIdentifier: HKQuantityTypeIdentifier = .stepCount
    static let healthKitUnit: HKUnit = .count()
    
    static func create(startDate: Date, endDate: Date, value: Double) -> StepCount? {
        return StepCount(startDate: startDate, endDate: endDate, count: Int(value))
    }
}
