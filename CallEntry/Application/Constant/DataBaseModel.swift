//
//  DataBaseModel.swift
//  CallEntry
//
//  Created by Rajesh on 15/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class DataBaseModel: NSObject {
    
    class func getCustomerDetailForID(cusId: String) -> Customerlist? {
        
        let customers = AppCacheManager.sharedInstance().customerList.filter() { $0.custid == cusId}
        
        if customers.count > 0
        {
            return customers[0]
        }
        
        return nil
    }
}
