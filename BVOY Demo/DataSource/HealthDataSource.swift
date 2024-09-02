//
//  HealthDataSource.swift
//  BVOY Demo
//
//  Created by Sahil S on 01/09/24.
//

import Foundation

protocol HealthDataSource<DataType> {
    associatedtype DataType: HealthData
    func fetchData(from startDate: Date, to endDate: Date) async throws -> [DataType]
}
