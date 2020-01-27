//
//  SideMenuDTO.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class SideMenuDTO: NSObject {

}



//MARK:- Logout

class LogoutRequest: Codable {
    var userid : String = ""
    var usertoken : String = ""
}

class LogoutResponse: Codable {
    var statuscode : String = ""
    var statusmessage : String = ""
}


//Side Menu
class SelectedMenu: NSObject {
    
    var name: String = ""
    var index: Int = 0
    var image: String = ""
}
