//
//  UserAccountDTO.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class UserAccountDTO: NSObject {

}


//MARK:- Login

class LoginRequest: Codable {
    
//    //Device Information
//    var device = Device()
//
//    //App Information
//    var appVersion: String = "1.0"
    
    var username : String = ""
    var password : String = ""
}

class Device: Codable {
    
    var mode : String = "IOS"
    var deviceId : String = (UIDevice.current.identifierForVendor?.uuidString)!
    var deviceToken : String = ""
    var model : String = ""
    var version : String = ""
}


class LoginResponse: Codable {
    var statuscode : String = ""
    var statusmessage : String = ""
    var logindetail: Logindetail =  Logindetail()
}

class Logindetail: Codable {
    var userid : String = ""
    var usertoken : String = ""
    var ismanager : String = ""
    var empcode   : String = ""
    var userdetail : Userdetail = Userdetail()
}

class Userdetail: Codable {
    
    var name : String = ""
    var emailid : String = ""
    var phoneno : String = ""
    var picture : String = ""
}

//MARK:- Forgot Password

class ForgotPasswordRequest: Codable {
    var username: String = ""
}

class ForgotPasswordResponse: Codable {
    var statuscode : String = ""
    var statusmessage : String = ""
}

//MARK:- Change Password

class ChangePasswordRequest: Codable {
    var username : String = ""
    var user_token : String = ""
    var new_password : String = ""
}

class ChangePasswordResponse: Codable {
    var statuscode : String = ""
    var statusmessage : String = ""
}


//MARK:- Get Master Data

class GetMasterDataRequest: Codable {
    var userid : String = ""
    var usertoken : String = ""
}

class GetMasterDataResponse: Codable {
    var statuscode : String = ""
    var statusmessage : String = ""
    var masterdata : Masterdata = Masterdata()
}

class Masterdata: Codable  {
    var calltype: [Calltype] = []
    var followupaction : [Id] = []
    var callmode : [Name] = []
    var period : [Id] = []
   // var types : [String] = []
    var tos : [Id] = []
    var commoditygroup : [Id] = []
}
class Name: Codable {
    var name: String = ""
}
class Calltype: Codable {
    var categorycode : String = "" // New, Existing
    var categoryname : String = ""
    var subcategory : [Id] = []
}

class Id: Codable {
    var code: String = ""
    var name: String = ""
}
//MARK:- Get Port Data

class GetPortDataRequest: Codable {
    var userid : String = ""
    var usertoken : String = ""
}

class GetPortDataResponse: Codable {
    var statuscode : String = ""
    var statusmessage : String = ""
    var masterdata : Portdata = Portdata()
}

class Portdata: Codable {
    var segments : [Id] = []
    var port : [Port] = []
}

class Port: Codable {
    var code: String = ""
    var name: String = ""
    var transportmode: String = ""
}

