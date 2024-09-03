//
//  DetailsView.swift
//  BVOY Demo
//
//  Created by Sahil S on 01/09/24.
//
import SwiftUI

struct DetailsView: View {
    let healthData: any HealthData
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Time: \(healthData.startDate, formatter: itemFormatter)")
            Text("Value: \(String(describing: healthData.count))")
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
        .padding()
    }
}
