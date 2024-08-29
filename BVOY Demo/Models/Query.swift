//
//  Query.swift
//  BVOY Demo
//
//  Created by Sahil S on 29/08/24.
//

import Foundation

enum QueryType: String, CaseIterable {
    case query1 = "Query 1"
    case query2 = "Query 2"
    case query3 = "Query 3"
    case query4 = "Query 4"

    var dateRange: (start: Date, end: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")

        switch self {
        case .query1:
            let start = formatter.date(from: "2024-07-31 06:00:00")!
            let end = formatter.date(from: "2024-07-31 11:30:00")!
            return (start, end)
        case .query2:
            let start = formatter.date(from: "2024-07-30 00:00:00")!
            let end = formatter.date(from: "2024-07-31 23:59:59")!
            return (start, end)
        case .query3:
            let start = formatter.date(from: "2024-07-29 12:00:00")!
            let end = formatter.date(from: "2024-07-29 23:59:59")!
            return (start, end)
        case .query4:
            let start = formatter.date(from: "2024-07-29 16:00:00")!
            let end = formatter.date(from: "2024-07-31 11:00:00")!
            return (start, end)
        }
    }
    
    var description: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        
        let (start, end) = dateRange
        
        return "\(formatter.string(from: start)) \(timeFormatter.string(from: start)) - \(formatter.string(from: end)) \(timeFormatter.string(from: end))"
    }
}
