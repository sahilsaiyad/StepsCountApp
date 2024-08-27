//
//  AppConfig.swift
//  BVOY Demo
//
//  Created by Sahil Saiyed on 27/08/24.
//

import Foundation
import HealthKit

enum Environment {
    case dev
    case prod
}

struct AppConfig {
    static let environment: Environment = {
        #if DEBUG
        return .dev
        #else
        return .prod
        #endif
    }()
    
    static func getStepCountDataSource() -> StepCountDataSource {
        switch environment {
        case .dev:
            return JSONStepCountDataSource()
        case .prod:
            if HKHealthStore.isHealthDataAvailable() {
                return HealthKitStepCountDataSource()
            } else {
                print("HealthKit is not available on this device. Falling back to JSON data source.")
                return JSONStepCountDataSource()
            }
        }
    }
}
