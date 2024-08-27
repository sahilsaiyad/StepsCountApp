//
//  BVOY_DemoApp.swift
//  BVOY Demo
//
//  Created by Sahil Saiyed on 27/08/24.
//

import SwiftUI

@main
struct BVOY_DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(repository: StepCountRepository(dataSource: AppConfig.getStepCountDataSource()))
        }
    }
}
