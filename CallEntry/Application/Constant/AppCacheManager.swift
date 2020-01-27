//
//  FSVLCacheManager.swift
//  FrieghtSystem
//
//  Created by hmspl on 19/05/17.
//  Copyright © 2017 Hakunamatata solution (P) Ltd. All rights reserved.
//

import UIKit

class AppCacheManager: NSObject {

    static var instance: AppCacheManager!

    class func sharedInstance() -> AppCacheManager {
        self.instance = (self.instance ?? AppCacheManager())
        return self.instance
    }
    
    var userId: String = ""
    var authToken: String = ""
    var userDetail: Userdetail = Userdetail()
    var isManager: String = "N"
    var salesmanCode: String = ""
    
    var masterData: Masterdata!
    var portData: Portdata!
    var customerList: [Customerlist]!
    
    var countryList: CountryList!
    
    // counterBoard Label One time shown
    var isShown: Bool = true
    
    // Salesman Record Score
    var todayScore: Int = 0
    
    //Set The Date for Call update follow up
    var followUpData : String = ""
    var reloadDashBoard : Bool = false
}
