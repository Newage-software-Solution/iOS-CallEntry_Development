//
//  ProfileDB+CoreDataProperties.swift
//  
//
//  Created by HMSPL on 25/02/19.
//
//

import Foundation
import CoreData


extension ProfileDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileDB> {
        return NSFetchRequest<ProfileDB>(entityName: "ProfileDB")
    }

    @NSManaged public var closuredate: String?
    @NSManaged public var commoditygroup: String?
    @NSManaged public var currentpotential: String?
    @NSManaged public var destination: String?
    @NSManaged public var estimatedrevenue: String?
    @NSManaged public var noofshipments: String?
    @NSManaged public var origin: String?
    @NSManaged public var period: String?
    @NSManaged public var profileid: String?
    @NSManaged public var segment: String?
    @NSManaged public var tos: String?
    @NSManaged public var type: String?
    @NSManaged public var volume: String?

}
