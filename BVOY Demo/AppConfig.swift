//
//  AppConfig.swift
//  BVOY Demo
//
//  Created by Sahil Saiyad on 27/08/24.
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
    
    static func getHealthDataSource<T: HealthData>(for type: T.Type) -> any HealthDataSource<T> {
        switch environment {
        case .dev:
            return JSONDataSource<T>()
        case .prod:
            if HKHealthStore.isHealthDataAvailable() {
                return HealthKitDataSource<T>()
            } else {
                print("HealthKit is not available on this device. Falling back to JSON data source.")
                return JSONDataSource<T>()
            }
        }
    }
}
