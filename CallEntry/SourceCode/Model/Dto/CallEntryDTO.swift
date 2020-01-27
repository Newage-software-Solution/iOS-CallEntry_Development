//
//  CallEntryDTO.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class CallEntryDTO: NSObject {

}

//MARK:- Get CallEntry List

class GetCallEntryListRequest: Codable {
    //var userid: String = ""
    var username: String = ""
    var user_token: String = ""
    var Salesmancode: String = ""
}

class CallhistoryRequest: Codable {
    var username: String = ""
    var user_token: String = ""
    var customer_code: String = ""
}

// MARK: - CallhistoryResponse
class CallhistoryResponse: Codable {
    var statuscode: String = ""
    var statusmessage: String = ""
    var customerlist: [customerlist] = []
}

// MARK: - Customerlist
class customerlist: Codable {
    var custid: String = ""
    var name: String = ""
    var callhistory: [Callhistory] = []
}

class GetCallEntryListResponse: Codable {
    var statuscode : String = ""
    var statusmessage : String = ""
    var calllist: [Calllist] = []
    var callcount: [Callcount] = []
}

class Calllist: Codable {
    var callid: String = ""
    var createddate: String = ""
    var type: String = ""
    var subtype: String = ""
    var custid: String = ""
    var ispotentialclient: String = ""
    var followups: [Followup] = []
}

class Callcount: Codable {
    var date: String = ""
    var deviatedcount: String = ""
    var completedplannedcalls: String = ""
}

class OverDueCallList: Codable {
    var calllist: Calllist = Calllist()
    var overDueDaysNo: Int = 0
}

class Followup: Codable {
    var updateddate: String = ""
    var followupdate: String = ""
    var action: String = ""
    var desc: String = ""
    var mode: String = ""
}


//MARK:- New CallEntry

class NewCallEntryRequest: Codable {
    
    //var userid: String = ""
    var user_token: String = ""
    var username : String = ""
    var cus_code : String = ""
    var call_type: String = ""
    var sub_type: String = ""
    var call_mode: String = ""
    var desc: String = ""
    var follow_date: String = ""
    var follow_action: String = ""
    var create_date: String = ""
    var jointcalls: String = ""
    //var newcallentry: NewcallentryDatas = NewcallentryDatas()
}

class NewCallEntryResponse: Codable {
      var statuscode : String = ""
      var statusmessage : String = ""
}

class Newcallentry: Codable {
    var custid: String = ""
    var calltype: String = ""
    var subtype: String = ""
    var callmode: String = ""
    var desc: String = ""
    var followupdate: String = ""
    var followupaction: String = ""
    var createddate: String = ""
}

class NewcallentryDatas: Codable {
    
    var custid: String = ""
    var call_type: String = ""
    var sub_type: String = ""
    var call_mode: String = ""
    var desc: String = ""
    var follow_date: String = ""
    var follow_action: String = ""
    var create_date: String = ""
}

//MARK:- Update CallEntry

class UpdateCallEntryRequest: Codable {
    var userid: String = ""
    var usertoken: String = ""
    var callupdate: Newcallentry = Newcallentry()
}

class UpdateCallEntryResponse: Codable {
      var statuscode : String = ""
    var statusmessage : String = ""
}

class Callupdate: Codable {
    var callid: String = ""
    var calltype: String = ""
    var subtype: String = ""
    var desc: String = ""
    var callmode: String = ""
}

//MARK:- Pre Call Planner List
class PreCallPlannerListRequest: Codable {
    var userid: String = ""
    var usertoken: String = ""
}

class PreCallPlannerListResponse: Codable {
      var statuscode : String = ""
    var statusmessage : String = ""
    var calllist: [Calllist] = []
}


//MARK:- Shipment List

class GetShipmentListRequest: Codable {
    var username: String = ""
    var user_token: String = ""
    var code: String = ""
}

class GetShipmentListResponse: Codable {
      var statuscode : String = ""
    var statusmessage : String = ""
    var shipments: Shipment = Shipment()
}

class Shipment: Codable {
    var custid: String = ""
    var history: [History] = []
}

class History: Codable {
    var shipmentno: String = ""
    var date: String = ""
    var segment: String = "" //Air/Fcl/Lcl
    var type: String = "" //import/export
    var origin: String = ""
    var destination: String = ""
    var etd: String = ""
    var eta: String = ""
    var bookingperson: String = ""
    var update: String = ""
}

