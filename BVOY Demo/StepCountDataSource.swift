//
//  StepCountDataSource.swift
//  BVOY Demo
//
//  Created by Sahil Saiyed on 27/08/24.
//

import Foundation

protocol StepCountDataSource {
    func fetchStepCounts(from startDate: Date, to endDate: Date) async throws -> [StepCount]
}
