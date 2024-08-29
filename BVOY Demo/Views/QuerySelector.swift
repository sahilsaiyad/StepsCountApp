//
//  QuerySelector.swift
//  BVOY Demo
//
//  Created by Sahil S on 29/08/24.
//

import SwiftUI

struct QuerySelector: View {
    @Binding var selectedQuery: QueryType
    let onQuerySelect: (QueryType) -> Void

    var body: some View {
        HStack {
            ForEach(QueryType.allCases, id: \.self) { queryType in
                Button(action: {
                    selectedQuery = queryType
                    onQuerySelect(queryType)
                }) {
                    Text(queryType.rawValue)
                        .padding(8)
                        .background(selectedQuery == queryType ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }
}
