//
//  BVOY_DemoApp.swift
//  BVOY Demo
//
//  Created by Sahil Saiyad on 27/08/24.
//

import SwiftUI

@main
struct BVOY_DemoApp: App {
    let persistentContainer = CDManager.shared.persistentContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
