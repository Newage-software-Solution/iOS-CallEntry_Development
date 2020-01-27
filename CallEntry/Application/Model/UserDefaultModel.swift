//
//  UserDefaultExtension.swift
//  FrieghtSystem
//
//  Created by Susena on 28/04/17.
//  Copyright © 2017 Hakunamatata solution (P) Ltd. All rights reserved.
//

import UIKit

class UserDefaultModel: NSObject {

    //Get Logged In User Info
    
    class func getUserInfo() -> Logindetail? {
        
        if let jsonString = UserDefaults.standard.object(forKey: UIConstants.UserDefaultKey.userInfo)
        {
            if let jsonData = (jsonString as! String).data(using: .utf8)
            {
                do
                {
                    let jsonDecoder = JSONDecoder()
                    let loginDetail = try jsonDecoder.decode(Logindetail.self, from: jsonData)
                    return loginDetail
                }
                catch (let error)
                {
                    print(error)
                    return nil
                }
            }
        }
        
        return nil
    }
    
    class func updateUserInfo(loginDetail: Logindetail) {
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted

        do
        {
            let jsonData = try jsonEncoder.encode(loginDetail)
            let jsonString = String(data: jsonData, encoding: .utf8)

            UserDefaults.standard.set(jsonString, forKey: UIConstants.UserDefaultKey.userInfo)
            
            UserDefaults.standard.synchronize()
        }
        catch (let error)
        {
            print(error)
        }
    }
    
    
    //Get Remembered User Info
    
    class func getRememberedUser() -> LoginRequest? {
        
        if let jsonString = UserDefaults.standard.object(forKey: UIConstants.UserDefaultKey.rememberedUserInfo)
        {
            if let jsonData = (jsonString as! String).data(using: .utf8)
            {
                do
                {
                    let jsonDecoder = JSONDecoder()
                    let request = try jsonDecoder.decode(LoginRequest.self, from: jsonData)
                    return request
                }
                catch (let error)
                {
                    print(error)
                    return nil
                }
            }
        }
        
        return nil
    }
    
    class func updateRememberedUser(request: LoginRequest)
    {
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        do
        {
            let jsonData = try jsonEncoder.encode(request)
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            UserDefaults.standard.set(jsonString, forKey: UIConstants.UserDefaultKey.rememberedUserInfo)
            
            UserDefaults.standard.synchronize()
        }
        catch (let error)
        {
            print(error)
        }
    }
    
    class func updateLastModifiedDate() {
        print("\(String(describing: Date().toLocale())) Last modified successfully updated")
        UserDefaults.standard.set(Date().toLocale(), forKey: UIConstants.UserDefaultKey.lastmodifiedDate)
        UserDefaults.standard.synchronize()
    }
    
    class func getLastModifiedDate() -> Date? {
        
        if isUserDefaultHasValue(forKey: UIConstants.UserDefaultKey.lastmodifiedDate) {
        
            return UserDefaults.standard.object(forKey: UIConstants.UserDefaultKey.lastmodifiedDate) as? Date
            
        }
        else {
            return nil
        }
       
        
    }
    
    class func getSalesmanRecord(request: String) -> Int?
    {
        return UserDefaults.standard.integer(forKey: request)
        
    }
    
    class func updateSalesmanRecord(request: SalesmanRecord)
    {
        if request.key == UIConstants.UserDefaultKey.today + request.userid
        {
        UserDefaults.standard.set(request.score, forKey: request.key)
        }
        else
        {
          UserDefaults.standard.set(request.score, forKey: request.userid)
        }
        UserDefaults.standard.synchronize()
    }
    
    class func getDate(request: String) -> Date
    {
        return UserDefaults.standard.object(forKey: request) as! Date
    }
    
    
    class func updateDate(request: SalesmanRecord)
    {
        UserDefaults.standard.set(Date().setTime(hour: 0, min: 0, sec: 0), forKey: UIConstants.UserDefaultKey.date + request.userid)
        UserDefaults.standard.synchronize()
    }
    
    class func removeUserDefaultValue(forKey: String)
    {
        UserDefaults.standard.removeObject(forKey: forKey)
    }
    
    class func isUserDefaultHasValue(forKey: String) -> Bool
    {
        
        if let _ = UserDefaults.standard.value(forKey: forKey)
        {
            return true
        }
        
        return false
    }
    
}

extension UserDefaults {

   
}
