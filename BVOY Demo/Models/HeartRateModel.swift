//
//  HeartRateModel.swift
//  BVOY Demo
//
//  Created by Sahil S on 01/09/24.
//

import Foundation
import HealthKit

struct HeartRateData: HealthData {
    typealias ValueType = Double
    
    let startDate: Date
    let endDate: Date
    let count: Double
    var id: Date { startDate }
    
    static let healthKitTypeIdentifier: HKQuantityTypeIdentifier = .heartRate
    static let healthKitUnit: HKUnit = HKUnit.count().unitDivided(by: .minute())
    
    static func create(startDate: Date, endDate: Date, value: Double) -> HeartRateData? {
        return HeartRateData(startDate: startDate, endDate: endDate, count: Double(value))
    }
}
