//
//  PotentialBusinessDTO.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class PotentialBusinessDTO: NSObject {

}


//MARK:- New Potential Business
class NewPotentialBusinessRequest: Codable {
    var username: String = ""
    var user_token: String = ""
    var uid: String?
    var cus_code: String = ""
    var segment: String = "" // Air/Fcl/Lcl
    var type: String = "" //import/export
    var period: String = ""
    var origin: String = ""
    var destination: String = ""
    var tos: String = ""
    var commodity: String = ""
    var shpt: String = ""
    var volume: String = ""
    var est_revenue: String = ""
    var busin: String = ""
    var close_date: String = ""
}

class NewPotentialBusinessResponse: Codable {
    var profileid : String = ""
    var statuscode : String = ""
    var statusmessage : String = ""
}

//MARK:- Update Potential Business

class UpdatePotentialBusinessRequest: Codable {
    var username: String = ""
    var user_token: String = ""
    var uid: String = ""
    var cus_code: String = ""
    var segment: String = "" // Air/Fcl/Lcl
    var type: String = "" //import/export
    var period: String = ""
    var origin: String = ""
    var destination: String = ""
    var tos: String = ""
    var commodity: String = ""
    var shpt: String = ""
    var volume: String = ""
    var est_revenue: String = ""
    var busin: String = ""
    var close_date: String = ""
//    var profile: [Profile] = []
}

class UpdatePotentialBusinessResponse: Codable {
      var statuscode : String = ""
    var statusmessage : String = ""
}


