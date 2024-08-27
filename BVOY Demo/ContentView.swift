//
//  ContentView.swift
//  BVOY Demo
//
//  Created by Sahil Saiyed on 27/08/24.
//

import SwiftUI
import Charts

struct ContentView: View {
    @StateObject private var viewModel: StepCountViewModel
    @State private var selectedStep: StepCount?
    
    init(repository: StepCountRepository) {
        _viewModel = StateObject(wrappedValue: StepCountViewModel(repository: repository))
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Query 1") { viewModel.fetchStepCounts(for: .query1) }
                Button("Query 2") { viewModel.fetchStepCounts(for: .query2) }
                Button("Query 3") { viewModel.fetchStepCounts(for: .query3) }
                Button("Query 4") { viewModel.fetchStepCounts(for: .query4) }
            }
            .padding()
            
            if viewModel.stepCounts.isEmpty {
                Text("No data available")
                    .foregroundColor(.secondary)
            } else {
                Chart(viewModel.stepCounts) { stepCount in
                    LineMark(
                        x: .value("Time", stepCount.startDate),
                        y: .value("Steps", stepCount.count)
                    )
                    .foregroundStyle(.blue)
                    
                    AreaMark(
                        x: .value("Time", stepCount.startDate),
                        y: .value("Steps", stepCount.count)
                    )
                    .foregroundStyle(.blue.opacity(0.1))
                    
                    if let selectedStep = selectedStep,
                       selectedStep.id == stepCount.id {
                        PointMark(
                            x: .value("Time", selectedStep.startDate),
                            y: .value("Steps", selectedStep.count)
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
                                        updateSelectedStep(at: value.location, proxy: proxy, geometry: geometry)
                                    }
                            )
                            .onTapGesture { location in
                                updateSelectedStep(at: location, proxy: proxy, geometry: geometry)
                            }
                        
                        if let selectedStep = selectedStep {
                            let datePosition = proxy.position(forX: selectedStep.startDate) ?? 0
                            let stepPosition = proxy.position(forY: selectedStep.count) ?? 0
                            
                            Text("\(selectedStep.count)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.blue)
                                .cornerRadius(6)
                                .offset(x: datePosition + 20, y: stepPosition - 30)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchStepCounts(for: .query1)  // Load initial data when view appears
        }
    }
    
    private func updateSelectedStep(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        guard let date: Date = proxy.value(atX: xPosition) else {
            return
        }
        
        let closestStep = viewModel.stepCounts.min(by: {
            abs($0.startDate.timeIntervalSince(date)) < abs($1.startDate.timeIntervalSince(date))
        })
        selectedStep = closestStep
    }
}

enum QueryType {
    case query1, query2, query3, query4
    
    var dateRange: (start: Date, end: Date) {
        let calendar = Calendar.current
        let baseDate = calendar.date(from: DateComponents(year: 2024, month: 7, day: 31))!
        
        switch self {
        case .query1:
            let start = calendar.date(bySettingHour: 6, minute: 0, second: 0, of: baseDate)!
            let end = calendar.date(bySettingHour: 11, minute: 30, second: 0, of: baseDate)!
            return (start, end)
        case .query2:
            let start = calendar.date(byAdding: .day, value: -1, to: baseDate)!
            return (start, baseDate)
        case .query3:
            let start = calendar.date(byAdding: .day, value: -2, to: baseDate)!
            let queryStart = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: start)!
            return (queryStart, start)
        case .query4:
            let start = calendar.date(byAdding: .day, value: -2, to: baseDate)!
            let queryStart = calendar.date(bySettingHour: 16, minute: 0, second: 0, of: start)!
            let queryEnd = calendar.date(bySettingHour: 11, minute: 0, second: 0, of: baseDate)!
            return (queryStart, queryEnd)
        }
    }
}

extension StepCountViewModel {
    func fetchStepCounts(for query: QueryType) async {
        let (start, end) = query.dateRange
        await fetchStepCounts(from: start, to: end)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(repository: StepCountRepository(dataSource: JSONStepCountDataSource()))
    }
}
