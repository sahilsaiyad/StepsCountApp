//
//  HealthDataChart.swift
//  BVOY Demo
//
//  Created by Sahil S on 01/09/24.
//

import Foundation
import SwiftUI
import Charts

struct HealthDataChart<T: HealthData>: View {
    let healthData: [T]
    @Binding var selectedData: T?
    @Binding var isTouching: Bool
    
    var body: some View {
        Chart(healthData, id: \.id) { data in
            LineMark(
                x: .value("Time", data.startDate),
                y: .value("Value", data.count)
            )
            .foregroundStyle(.blue)
            
            AreaMark(
                x: .value("Time", data.startDate),
                y: .value("Value", data.count)
            )
            .foregroundStyle(.blue.opacity(0.1))
            
            if let selectedData = selectedData,
               selectedData.id == data.id && isTouching {
                PointMark(
                    x: .value("Time", selectedData.startDate),
                    y: .value("Value", selectedData.count)
                )
                .foregroundStyle(.red)
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 5)) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.hour())
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(height: 300)
        .padding()
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                isTouching = true
                                updateSelectedData(at: value.location, proxy: proxy, geometry: geometry)
                            }
                            .onEnded { _ in
                                isTouching = false
                            }
                    )
                    .onTapGesture { location in
                        isTouching = true
                        updateSelectedData(at: location, proxy: proxy, geometry: geometry)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isTouching = false
                        }
                    }
                if let selectedData = selectedData, isTouching {
                    let datePosition = proxy.position(forX: selectedData.startDate) ?? 0
                    let valuePosition = proxy.position(forY: selectedData.count) ?? 0
                    
                    Text(verbatim: "\(selectedData.count)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.blue)
                        .cornerRadius(6)
                        .offset(x: datePosition + 20, y: valuePosition - 20)
                }
            }
        }
    }
    
    private func updateSelectedData(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        let xPosition = location.x - geometry[proxy.plotFrame!].origin.x
        guard let date: Date = proxy.value(atX: xPosition) else {
            return
        }
        
        selectedData = healthData.min(by: {
            abs($0.startDate.timeIntervalSince(date)) < abs($1.startDate.timeIntervalSince(date))
        })
    }
}
