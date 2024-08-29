//
//  StepCountDetailView.swift
//  BVOY Demo
//
//  Created by Sahil S on 29/08/24.
//

import SwiftUI

struct StepCountDetailView: View {
    let stepCount: StepCount
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Time: \(stepCount.startDate, formatter: itemFormatter)")
            Text("Steps: \(stepCount.count)")
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
        .padding()
    }
}
