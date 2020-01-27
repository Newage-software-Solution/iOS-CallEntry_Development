//
//  CustomerListDB+CoreDataProperties.swift
//  
//
//  Created by HMSPL on 25/02/19.
//
//

import Foundation
import CoreData


extension CustomerListDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomerListDB> {
        return NSFetchRequest<CustomerListDB>(entityName: "CustomerListDB")
    }

    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var contactperson: String?
    @NSManaged public var country: String?
    @NSManaged public var custid: String?
    @NSManaged public var emailid: String?
    @NSManaged public var mobileno: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneno: String?
    @NSManaged public var potentialforclearance: String?
    @NSManaged public var potentialforwarehousing: String?
    @NSManaged public var salesman: String?
    @NSManaged public var territory: String?
    @NSManaged public var callhistory: NSSet?
    @NSManaged public var profile: NSSet?

}

// MARK: Generated accessors for callhistory
extension CustomerListDB {

    @objc(addCallhistoryObject:)
    @NSManaged public func addToCallhistory(_ value: CallHistoryDB)

    @objc(removeCallhistoryObject:)
    @NSManaged public func removeFromCallhistory(_ value: CallHistoryDB)

    @objc(addCallhistory:)
    @NSManaged public func addToCallhistory(_ values: NSSet)

    @objc(removeCallhistory:)
    @NSManaged public func removeFromCallhistory(_ values: NSSet)

}

// MARK: Generated accessors for profile
extension CustomerListDB {

    @objc(addProfileObject:)
    @NSManaged public func addToProfile(_ value: ProfileDB)

    @objc(removeProfileObject:)
    @NSManaged public func removeFromProfile(_ value: ProfileDB)

    @objc(addProfile:)
    @NSManaged public func addToProfile(_ values: NSSet)

    @objc(removeProfile:)
    @NSManaged public func removeFromProfile(_ values: NSSet)

}
