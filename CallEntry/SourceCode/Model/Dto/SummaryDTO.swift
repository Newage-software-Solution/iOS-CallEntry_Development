//
//  SummaryDTO.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class SummaryDTO: NSObject {

}

//MARK:- Update FollowUp Api

class UpdateSummaryRequest: Codable {
    //var userid: String = ""
    var username: String = ""
    var user_token: String = ""
    
    //var followupupdate: Followupupdate = Followupupdate()
    
    var call_id: String = ""
    var completed: String = ""
    var desc: String = ""
    var follow_date: String = ""
    var follow_action: String = ""
    var call_mode: String = ""
    var run_date: String = ""
}

class UpdateSummaryResponse: Codable {
      var statuscode : String = ""
    var statusmessage : String = ""    
}

class Followupupdate: Codable {
    var callid: String = ""
    var iscompleted: Bool = false
    var desc: String = ""
    var followupdate: String = ""
    var followupaction: String = ""
    var callmode: String = ""
    var updateddate: String = ""
}
