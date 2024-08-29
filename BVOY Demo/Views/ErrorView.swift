//
//  ErrorView.swift
//  BVOY Demo
//
//  Created by Sahil S on 29/08/24.
//

import SwiftUI

struct ErrorView: View {
    let error: Error

    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .foregroundColor(.red)
                .font(.largeTitle)
            Text("An error occurred")
                .font(.headline)
            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
