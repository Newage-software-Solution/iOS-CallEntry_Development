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
    
    var authToken: String = ""
    var userInfo: UserDTO = UserDTO()

}
