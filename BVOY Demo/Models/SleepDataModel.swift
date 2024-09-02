//
//  SleepDataModel.swift
//  BVOY Demo
//
//  Created by Sahil S on 31/08/24.
//

import Foundation
import HealthKit

struct SleepData: HealthData {
    typealias ValueType = Double
    
    let startDate: Date
    let endDate: Date
    let count: Double
    var id: Date { startDate }
    
    static let healthKitTypeIdentifier: HKQuantityTypeIdentifier = .appleStandTime
    static let healthKitUnit: HKUnit = .minute()
    
    static func create(startDate: Date, endDate: Date, value: Double) -> SleepData? {
        return SleepData(startDate: startDate, endDate: endDate, count: Double(value))
    }
}
