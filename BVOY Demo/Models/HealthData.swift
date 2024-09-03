//
//  HealthData.swift
//  BVOY Demo
//
//  Created by Sahil S on 31/08/24.
//

import HealthKit
import Charts

protocol HealthData: Identifiable, Codable {
    associatedtype ValueType: Plottable, Numeric
    
    var startDate: Date { get }
    var endDate: Date { get }
    var count: ValueType { get }
    var id: Date { get }
    
    static var healthKitSampleType: HKSampleType { get }
    static var healthKitUnit: HKUnit { get }
    
    static func create(startDate: Date, endDate: Date, value: Double) -> Self?
    static func getRawVal() -> String
}
