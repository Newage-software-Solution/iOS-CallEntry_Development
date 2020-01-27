//
//  UserDefaultExtension.swift
//  FrieghtSystem
//
//  Created by Susena on 28/04/17.
//  Copyright © 2017 Hakunamatata solution (P) Ltd. All rights reserved.
//

import UIKit

class UserDefaultModel: NSObject {

    //Recent HBL Number
    
//    func getRecentHBLNo() -> [String] {
//        
//        if UserDefaults.standard.recentHBLNo != ""
//        {
//            let recentHblNoList = UserDefaults.standard.recentHBLNo.components(separatedBy: ",")
//            
//            return recentHblNoList
//        }
//        
//        return []
//    }
//    
//    func updateRecentHblNo(recentHblNo: [String]) {
//        
//        UserDefaults.standard.recentHBLNo = recentHblNo.joined(separator: ",")
//        
//    }
    
    //Get User Info
    
    func getUserInfo() -> UserDTO? {
        
        if let data = UserDefaults.standard.object(forKey: UIConstants.UserDefault.userInfo)
        {
            if let userInfo = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? UserDTO
            {
                return userInfo
            }
        }
        
        return nil
    }
    
    func updateUserInfo(user: UserDTO) {
        
        let archivedObject = NSKeyedArchiver.archivedData(withRootObject: user)
        
        UserDefaults.standard.set(archivedObject, forKey: UIConstants.UserDefault.userInfo)
        
        UserDefaults.standard.synchronize()
        
    }
    
    func removeUserDefaultValue(forKey: String) {
        
        UserDefaults.standard.removeObject(forKey: forKey)
    }
    
    func isUserDefaultHasValue(forKey: String) -> Bool {
        
        if let _ = UserDefaults.standard.value(forKey: forKey)
        {
            return true
        }
        
        return false
    }
    
}

extension UserDefaults {
    

    
//    var userToken : String {
//        
//        get {
//            return UserDefaults.standard.string(forKey: UIConstants.UserDefault.userToken) ?? ""
//        }
//        
//        set  {
//            UserDefaults.standard.set(newValue, forKey: UIConstants.UserDefault.userToken)
//        }
//    }
//    
//    var isUserLoggedIn: Bool {
//        
//        get
//        {
//            return UserDefaults.standard.bool(forKey: UIConstants.UserDefault.isLoggedIn)
//        }
//        set
//        {
//            UserDefaults.standard.set(newValue, forKey: UIConstants.UserDefault.isLoggedIn)
//        }
//    }
//    

    
}
