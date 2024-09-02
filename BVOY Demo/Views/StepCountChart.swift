//
//  StepCountChart.swift
//  BVOY Demo
//
//  Created by Sahil S on 29/08/24.
//

//import SwiftUI
//import Charts

//struct StepCountChart: View {
//    let stepCounts: [StepCount]
//    @Binding var selectedStep: StepCount?
//    @Binding var isTouching: Bool
//    
//    var body: some View {
//        Chart(stepCounts) { stepCount in
//            LineMark(
//                x: .value("Time", stepCount.startDate),
//                y: .value("Steps", stepCount.count)
//            )
//            .foregroundStyle(.blue)
//            
//            AreaMark(
//                x: .value("Time", stepCount.startDate),
//                y: .value("Steps", stepCount.count)
//            )
//            .foregroundStyle(.blue.opacity(0.1))
//            
//            if let selectedStep = selectedStep,
//               selectedStep.id == stepCount.id && isTouching {
//                PointMark(
//                    x: .value("Time", selectedStep.startDate),
//                    y: .value("Steps", selectedStep.count)
//                )
//                .foregroundStyle(.red)
//            }
//        }
//        .chartXAxis {
//            AxisMarks(values: .automatic(desiredCount: 5)) { value in
//                AxisGridLine()
//                AxisTick()
//                AxisValueLabel(format: .dateTime.hour())
//            }
//        }
//        .chartYAxis {
//            AxisMarks(position: .leading)
//        }
//        .frame(height: 300)
//        .padding()
//        .chartOverlay { proxy in
//            GeometryReader { geometry in
//                Rectangle().fill(.clear).contentShape(Rectangle())
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                isTouching = true
//                                updateSelectedStep(at: value.location, proxy: proxy, geometry: geometry)
//                            }
//                            .onEnded { _ in
//                                isTouching = false
//                            }
//                    )
//                    .onTapGesture { location in
//                        isTouching = true
//                        updateSelectedStep(at: location, proxy: proxy, geometry: geometry)
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                            isTouching = false
//                        }
//                    }
//                
//                if let selectedStep = selectedStep, isTouching {
//                    let datePosition = proxy.position(forX: selectedStep.startDate) ?? 0
//                    let stepPosition = proxy.position(forY: selectedStep.count) ?? 0
//                    
//                    Text("\(selectedStep.count)")
//                        .font(.caption)
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding(6)
//                        .background(Color.blue)
//                        .cornerRadius(6)
//                        .offset(x: datePosition + 20, y: stepPosition - 20)
//                }
//            }
//        }
//    }
//    
//    private func updateSelectedStep(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
//        let xPosition = location.x - geometry[proxy.plotFrame!].origin.x
//        guard let date: Date = proxy.value(atX: xPosition) else {
//            return
//        }
//        
//        selectedStep = stepCounts.min(by: {
//            abs($0.startDate.timeIntervalSince(date)) < abs($1.startDate.timeIntervalSince(date))
//        })
//    }
//}
