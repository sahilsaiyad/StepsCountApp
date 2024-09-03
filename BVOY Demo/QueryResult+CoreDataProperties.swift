//
//  QueryResult+CoreDataProperties.swift
//  BVOY Demo
//
//  Created by Sahil S on 03/09/24.
//
//

import Foundation
import CoreData


extension QueryResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QueryResult> {
        return NSFetchRequest<QueryResult>(entityName: "QueryResult")
    }

    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date
    @NSManaged public var type: String
    @NSManaged public var data: Data

}

extension QueryResult : Identifiable {

}
