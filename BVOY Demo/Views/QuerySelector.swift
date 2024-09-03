//
//  QuerySelector.swift
//  BVOY Demo
//
//  Created by Sahil S on 29/08/24.
//

import SwiftUI

import SwiftUI

struct QuerySelector: View {
    @Binding var selectedQuery: QueryType
    let onQuerySelect: (QueryType) -> Void
    
    var body: some View {
        Menu {
            ForEach(QueryType.allCases, id: \.self) { queryType in
                Button(action: {
                    selectedQuery = queryType
                    onQuerySelect(queryType)
                }) {
                    HStack {
                        Text(queryType.rawValue)
                        if selectedQuery == queryType {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack {
                Text(selectedQuery.rawValue)
                Image(systemName: "chevron.down")
            }
            .padding(10)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}
