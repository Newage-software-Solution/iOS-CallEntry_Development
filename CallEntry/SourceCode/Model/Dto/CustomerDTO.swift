//
//  CustomerDTO.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class CustomerDTO: NSObject {

}

//MARK:- New Customer
class NewCustomerRequest: Codable {
    var username: String = ""
    var user_token: String = ""
    var name: String = ""
    var address: String = ""
    var area: String = ""
    var city: String = ""
    var country: String = ""
    var phone: String = ""
    var mobile: String = ""
    var email: String = ""
    var contact: String = ""
    var warehouse: String = "NO"
    var clearance: String = "NO"
  //  var customerdetails: CustomerDetails = CustomerDetails()
}

class NewCustomerResponse: Codable {
      var statuscode : String = ""
    var statusmessage : String = ""
    var customercode: String = ""
}

class CustomerDetails: Codable
{
    var name: String?
    var address: String?
    var area: String?
    var city: String?
    var country: String?
    var phone: String?
    var mobile: String?
    var email: String?
    var contact: String?
    var warehouse: String?
    var clearance: String?
}


class Customerdetails: Codable {
    var name: String = ""
    var Address: String = ""
    var territory: String = ""
    var city: String = ""
    var country: String = ""
    var phoneno: String = ""
    var mobileno: String = ""
    var emailid: String = ""
    var contactperson: String = ""
    var potentialforwarehousing: Bool = false
    var potentialforclearance: Bool = false
   // var profile: [Profile] = []
}

class CountryList: Codable {
    var countryCodeList: [CountryCodeList] = []
}

class CountryCodeList: Codable {
    var countryCode: String = ""
    var countryName: String = ""
}

class Profile: Codable {
    var profileid: String = ""
    var segment: String = "" // Air/Fcl/Lcl
    var type: String = "" //import/export
    var period: String = ""
    var origin: String = ""
    var destination: String = ""
    var tos: String = ""
    var commoditygroup: String = ""
    var noofshipments: String = ""
    var volume: String = ""
    var estimatedrevenue: String = ""
    var currentpotential: String = ""
    var closuredate: String = ""
}


//MARK:- Update Customer
class UpdateCustomerRequest: Codable {
    var username: String = ""
    var user_token: String = ""
    var code: String = ""
    var name: String = ""
    var address: String = ""
    var area: String = ""
    var city: String = ""
    var country: String = ""
    var phone: String = ""
    var mobile: String = ""
    var email: String = ""
    var contact: String = ""
    var warehouse: String = ""
    var clearance: String = ""
   // var customerdetails: Customerdetails = Customerdetails()
}

class UpdateCustomerResponse: Codable {
    var statuscode : String = ""
    var statusmessage : String = ""
}

//MARK:- Customer List

class CustomerListRequest: Codable {
    var userid: String = ""
    var usertoken: String = ""
    var updateddata: String = ""
    var lastmodifieddate: String = ""
}

class EmployeeDetailListRequest: Codable {
    var userid: String = ""
    var usertoken: String = ""
}

class CustomerListResponse: Codable {
    var statuscode : String = ""
    var statusmessage : String = ""
    var customerlist: [Customerlist] = []
}

class EmployeeDetailListResponse: Codable {
    var statuscode : String = ""
    var statusmessage : String = ""
    var employeelist: [EmployeeDetail] = []
}

class Customerlist: Codable {
    var custid: String = ""
    var name: String = ""
    var address: String = ""
    var territory: String = ""
    var city: String = ""
    var country: String = ""
    var phoneno: String = ""
    var mobileno: String = ""
    var emailid: String = ""
    var contactperson: String = ""
    var potentialforwarehousing: String = ""
    var potentialforclearance: String = ""
    var salesman: String = ""
    var profile: [Profile] = []
    var callhistory: [Callhistory] = []
    //var lastshipments: [Lastshipment] = []
    
}

class Lastshipment: Codable {
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

class Callhistory: Codable {
    var calldate: String = ""
    var mode: String = ""
//    var salesman: String = ""
//    var salesmancode: String = ""
//    var mobileno: String = ""
}

class EmployeeDetail: Codable {
    var code: String = ""
    var name: String = ""
}
