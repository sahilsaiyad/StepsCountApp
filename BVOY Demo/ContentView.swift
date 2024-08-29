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
    @State private var isTouching: Bool = false
    @State private var selectedQuery: QueryType = .query1

    init(repository: StepCountRepository) {
        _viewModel = StateObject(wrappedValue: StepCountViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                QuerySelector(selectedQuery: $selectedQuery, onQuerySelect: { query in
                    viewModel.fetchStepCounts(from: query.dateRange.start, to: query.dateRange.end)
                })
                
                Text(selectedQuery.description)
                    .font(.caption)
                    .foregroundColor(.secondary)

                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    ErrorView(error: error)
                } else if viewModel.stepCounts.isEmpty {
                    Text("No data available")
                        .foregroundColor(.secondary)
                } else {
                    StepCountChart(stepCounts: viewModel.stepCounts, selectedStep: $selectedStep, isTouching: $isTouching)
                }

                if let selectedStep = selectedStep, isTouching {
                    StepCountDetailView(stepCount: selectedStep)
                }

                Spacer()
            }
            .padding(.top, 20)
            .navigationTitle("Step Count")
        }
        .onAppear {
            viewModel.fetchStepCounts(for: selectedQuery)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(repository: StepCountRepository(dataSource: JSONStepCountDataSource()))
    }
}
