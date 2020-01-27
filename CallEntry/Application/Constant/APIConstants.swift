//
//  APIConstants.swift
//  FrieghtSystem
//
//  Created by Susena on 12/04/17.
//  Copyright © 2017 Hakunamatata solution (P) Ltd. All rights reserved.
//

import UIKit

class APIConstants: NSObject {
    
    static let userName: String = "spitex"
    static let password: String = "1q2w3e"
    
    enum urlContstant : String {
        
        //User Account
        case login = "login"
        case logout = "logout"
        case changePassword = "changepassword"
        case forgotPassword = "forgotpassword"
        
        //Common
        case getMasterData = "master"
        case getPortData = "port"
        
        //Dashboard
        
        //Summary
        
        //Call Entry
        case calllist = "calllist"
        //NewCustomer
        case addNewCustomer = "newcustomer"
        case updateCustomer = "updatecustomer"
        
        //Customer
        case getCustomerList = "customer"
        
        //Potential Business
        case updateProfile = "updateprofile"
        case newProfile     = "newprofile"
        
        //User Accounts
        //Salesman
        case salesmanList = "salesman"
        
        //New Call
        case newcall = "newcall"
        
        //Update Call
        case updateCall = "updatecall"
        
        //updatefollowup
        case updateFollowUp = "updatefollowup"
        
        //Shipment History
        case shipmentHistory = "shipmenthistory"
        
        case callHistory = "callhistory"
        
        case getEmployeeDetail = "employeedetail"
        
    }
    
    
    // Stage Server
    // let baseUrl = "http://efreightsuite.com/callentry_api/webservice.asmx/"
    //let baseUrl = "http://114.143.208.29:8081/Callentry_api_test/WebService.asmx/"
    //let baseUrl = "http://www.efreightsuite.com/callentry_S1NTR/webservice.asmx/"
    
    
    let baseUrl = "http://efreightsuite.com/callentry_api/webservice.asmx/"
    
   // let baseUrl = "http://efreightsuite.com/callentry_s1ntr/webservice.asmx/"
    // Live Server
    // let baseUrl =
    
    func getBaseUrl() -> String {
        return "\(baseUrl)"
    }
    
    func getUrl(urlString : urlContstant) -> String {
        return "\(baseUrl)\(urlString.rawValue)"
    }
    
    func getdataRequest(urlString: APIConstants.urlContstant) -> String
    {
        return  "\(getUrl(urlString: urlString))?username=\(AppCacheManager.sharedInstance().userId)&user_token=\(AppCacheManager.sharedInstance().authToken)"
    }
    
    
}


