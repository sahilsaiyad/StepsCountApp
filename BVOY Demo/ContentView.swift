//
//  ContentView.swift
//  BVOY Demo
//
//  Created by Sahil Saiyed on 27/08/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: TabTypes = .steps

    var body: some View {
        TabView(selection: $selectedTab) {
            HealthDataView<StepCount>()
            .tabItem {
                Label("Steps", systemImage: "figure.walk")
            }
            .tag(TabTypes.steps)

            HealthDataView<SleepData>()
            .tabItem {
                Label("Sleep", systemImage: "bed.double.fill")
            }
            .tag(TabTypes.sleep)

            HealthDataView<HeartRateData>()
            .tabItem {
                Label("Heart Rate", systemImage: "heart.fill")
            }
            .tag(TabTypes.heartRate)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum TabTypes {
    case steps, sleep, heartRate
}
