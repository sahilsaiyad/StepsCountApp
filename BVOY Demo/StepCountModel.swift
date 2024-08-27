//
//  StepCountModel.swift
//  BVOY Demo
//
//  Created by Sahil Saiyed on 27/08/24.
//

import Foundation

struct StepCount: Identifiable, Codable {
    let startDate: Date
    let endDate: Date
    let count: Int
    
    var id: Date { startDate }
}
