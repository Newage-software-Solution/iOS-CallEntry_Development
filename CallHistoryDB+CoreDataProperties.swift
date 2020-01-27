//
//  CallHistoryDB+CoreDataProperties.swift
//  
//
//  Created by HMSPL on 25/02/19.
//
//

import Foundation
import CoreData


extension CallHistoryDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CallHistoryDB> {
        return NSFetchRequest<CallHistoryDB>(entityName: "CallHistoryDB")
    }

    @NSManaged public var calldate: String?
    @NSManaged public var mobileno: String?
    @NSManaged public var mode: String?
    @NSManaged public var salesman: String?

}
