//
//  CustomerListDB.swift
//  CallEntry
//
//  Created by HMSPL on 25/02/19.
//  Copyright © 2019 Gowtham. All rights reserved.
//

import Foundation
import CoreData

extension CustomerListDB {

   class func saveCustomerList(customerList: [Customerlist]) {
    
        guard customerList.count > 0 else {
            print("no new customer list found")
            return
        }

        for customer in customerList {

            let customerDetail = CoreDataHandler.sharedInstance.getEntity(entityName: "CustomerListDB") as! CustomerListDB

             customerDetail.address = customer.address
             customerDetail.city = customer.city
             customerDetail.contactperson = customer.contactperson
             customerDetail.country = customer.country
             customerDetail.custid = customer.custid
             customerDetail.emailid = customer.emailid
             customerDetail.mobileno = customer.mobileno
             customerDetail.name = customer.name
             customerDetail.phoneno = customer.phoneno
             customerDetail.potentialforclearance = customer.potentialforclearance
             customerDetail.potentialforwarehousing = customer.potentialforwarehousing
             customerDetail.territory = customer.territory
             customerDetail.salesman = customer.salesman

            let profileSet: NSMutableSet = NSMutableSet()

            let callHistorySet: NSMutableSet = NSMutableSet()

            for profile in customer.profile {

                let profileEntity = CoreDataHandler.sharedInstance.getEntity(entityName: "ProfileDB") as! ProfileDB

               profileEntity.closuredate = profile.closuredate
               profileEntity.commoditygroup = profile.closuredate
               profileEntity.currentpotential = profile.closuredate
               profileEntity.destination = profile.destination
               profileEntity.estimatedrevenue = profile.estimatedrevenue
               profileEntity.noofshipments = profile.noofshipments
               profileEntity.origin = profile.origin
               profileEntity.period = profile.period
               profileEntity.profileid = profile.profileid
               profileEntity.segment = profile.segment
               profileEntity.tos = profile.tos
               profileEntity.type = profile.type
               profileEntity.volume = profile.volume

                profileSet.add(profileEntity)

                customerDetail.addToProfile(profileSet)

            }

            for history in customer.callhistory {

                let callhistoryEntity = CoreDataHandler.sharedInstance.getEntity(entityName: "CallHistoryDB") as! CallHistoryDB

                callhistoryEntity.calldate = history.calldate
                //callhistoryEntity.mobileno = history.mobileno
                callhistoryEntity.mode = history.mode
               // callhistoryEntity.salesman = history.salesman

                callHistorySet.add(callhistoryEntity)

                customerDetail.addToCallhistory(callHistorySet)

            }
        }
    
        CoreDataHandler.sharedInstance.saveContext()

    }


    class func fetchCustomerList() -> [Customerlist] {
        
        let result = CoreDataHandler.sharedInstance.fetchEntityDetails(entityName: "CustomerListDB", fetchPredicate: nil, sortDescriptor: nil) as! [CustomerListDB]
        
        var customerList: [Customerlist] = []
        
        for customer in result {
            
            let customerDetail = Customerlist()
            
            customerDetail.address = customer.address ?? ""
            customerDetail.city = customer.city ?? ""
            customerDetail.contactperson = customer.contactperson ?? ""
            customerDetail.country = customer.country ?? ""
            customerDetail.custid = customer.custid ?? ""
            customerDetail.emailid = customer.emailid ?? ""
            customerDetail.mobileno = customer.mobileno ?? ""
            customerDetail.name = customer.name ?? ""
            customerDetail.phoneno = customer.phoneno ?? ""
            customerDetail.potentialforclearance = customer.potentialforclearance ?? ""
            customerDetail.potentialforwarehousing = customer.potentialforwarehousing ?? ""
            customerDetail.territory = customer.territory ?? ""
            customerDetail.salesman = customer.salesman ?? ""
            
            let profiles = customer.profile?.allObjects as! [ProfileDB]
            
            var custProfile: [Profile] = []
            
            for profile in profiles {
                
                let prof = Profile()
                
                prof.profileid = profile.profileid ?? ""
                prof.segment = profile.segment ?? ""
                prof.type = profile.type ?? ""
                prof.period = profile.period ?? ""
                prof.origin = profile.origin ?? ""
                prof.destination = profile.destination ?? ""
                prof.tos = profile.tos ?? ""
                prof.commoditygroup = profile.commoditygroup ?? ""
                prof.noofshipments = profile.noofshipments ?? ""
                prof.volume = profile.volume ?? ""
                prof.estimatedrevenue = profile.estimatedrevenue ?? ""
                prof.currentpotential = profile.currentpotential ?? ""
                prof.closuredate = profile.closuredate ?? ""
               
                custProfile.append(prof)
                
            }
            
            var callhist: [Callhistory] = []
            
            let callHistory = customer.callhistory?.allObjects as! [CallHistoryDB]
            
            for history in callHistory {
                
                let hist = Callhistory()
                
                hist.calldate = history.calldate ?? ""
               // hist.mobileno = history.mobileno ?? ""
                hist.mode = history.mode ?? ""
               // hist.salesman = history.salesman ?? ""
                
                callhist.append(hist)
                
            }
            
            customerDetail.profile = custProfile
            customerDetail.callhistory = callhist
            
            customerList.append(customerDetail)
            
        }
        
        return customerList
        
    }
    
    class func isCustomerExist(id: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CustomerListDB")
        fetchRequest.predicate = NSPredicate(format: "custid = %@", id)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let res = try? managedContext.fetch(fetchRequest)
        return ((res?.count) ?? 0) > 0 ? true : false
    }
    
    

}
