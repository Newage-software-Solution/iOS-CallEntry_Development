//
//  DashboardDTO.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class DashboardDTO: NSObject {

}

//MARK:- Get SalesMan List

class GetSalesManListRequest: Codable {
    var userid: String = ""
    var usertoken: String = ""
}

class GetSalesManListResponse: Codable
{
    var statuscode : String = ""
    var statusmessage : String = ""
    
    var salesmanlist: [Salesmanlist] = []
}

class Salesmanlist: Codable {
    var code: String = ""
    var name: String = ""
}

//MARK:- Salesman CounterBoard Record

class SalesmanRecord: NSObject {
    var userid: String = ""
    var score: Int = 0
    var key: String = ""
}

//Mark:- Salesman Today Record

//class SalesmantodayRecord: NSObject
//{
//    var userid: String = ""
//    var todayScore: Int = 0
//    var key: String = ""
//}

//MARK:- LineChart Data Model

class LineChartData: NSObject {
    var chartName: DashboardListSegment = .none
    var weekDays: [WeekDay] = []
}

class WeekDay: NSObject {
    var day: String = ""
    var date: Date = Date()
    var totalCallCount: Int = 0
    var deviationCallCount: Int = 0
    
}

