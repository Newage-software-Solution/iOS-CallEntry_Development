//
//  DashboardModel.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

protocol DashboardModelDelegate {
    func shipmentHistoryReceived()
    func callListOrgalized()
    func apiHitFailure()
}

protocol DashboardSalesManListDelegate {
    func apiHitSuccess()
    func apiHitFailure()
}

class DashboardModel: BaseModel {

    var delegate: DashboardModelDelegate?
    
    var salesmanListDelegate: DashboardSalesManListDelegate?
    
    var pastCalls: [Calllist] = []
    var overDueCalls: [OverDueCallList] = []
    var todayCalls: [Calllist] = []
    var upcomingCalls: [Calllist] = []
    
    var lineChartData: [LineChartData] = []
    var callCount: [Callcount] = []
    var pastWeek: [WeekDay] = []
    var upcomingWeak: [WeekDay] = []
    
    var shipment: Shipment! = Shipment()
    var salesManList: [Salesmanlist] = []
    
    func getSalesManList(request: GetSalesManListRequest) {
        
        
        DashboardDataHandler().getSalesManList(request: request,Completion: { (response,error) in
            if let responseData = response
            {
                self.salesManList = responseData.salesmanlist
                self.salesmanListDelegate?.apiHitSuccess()
            }
            else if let errorData = error
            {
                self.showFailureMessage(error: errorData as NSError)
                self.salesmanListDelegate?.apiHitFailure()
            }
        })
    }
    
    
    func getShipmentList(request: GetShipmentListRequest) {
        CallEntryDataHandler().getShipmentList(request: request, Completion: {(response, error) in
            
            if let errorData = error
            {
                self.showFailureMessage(error: errorData as NSError)
                self.delegate?.apiHitFailure()
            }
            else if let responseData = response
            {                
                if responseData.statuscode == "200"
                {
                    self.shipment = responseData.shipments
                    self.delegate?.shipmentHistoryReceived()
                }
            }
        })
    }
    
    func getCallEntryList(request: GetCallEntryListRequest) {
        
        CallEntryDataHandler().getCallEntryList(request: request,Completion:  { (response,error) in
            
            if let response = response
            {
                //Empty the Calls Array
                self.pastCalls = []
                self.overDueCalls = []
                self.todayCalls = []
                self.upcomingCalls = []
                
                let todayDate = Date().setTime(hour: 0, min: 0, sec: 0)
                
                //Create LineChart Object List
                //For OverDueCalls
                
                let overDueChartData = LineChartData()
                overDueChartData.chartName = .overDueCalls
                overDueChartData.weekDays = []
                print("OverDue Calls")

                for i in 0 ..< 7
                {
                    let dayAndDate = self.getWeekDayWithDate(date: todayDate!, dayValue: -(7-i), dateFormat: DateFormatString.serverFormat.rawValue)
                        
                    let weekDay = WeekDay()
                    weekDay.day = dayAndDate.1
                    weekDay.date = dayAndDate.0
                   
                     overDueChartData.weekDays.append(weekDay)
                    print("Date \(dayAndDate.0), day \(dayAndDate.1)")
                }
                
                // past week
                for i in 0 ..< 7
                {
                    let dayAndDate = self.getWeekDayWithDate(date: todayDate!, dayValue: -(7-i), dateFormat: DateFormatString.serverFormat.rawValue)
                    
                    var date: Date? = Date()
                    
                    for callcount in response.callcount
                    {
                        date = DateExtension.dateFromString(dateString: callcount.date, dateFormat: DateFormatString.serverFormat.rawValue)
                        
                        if DateExtension.equalTo(lhs: date!, rhs: dayAndDate.0)
                        {
                            
                            overDueChartData.weekDays[i].totalCallCount = callcount.completedplannedcalls == "" ? 0 : Int(callcount.completedplannedcalls)!
                            overDueChartData.weekDays[i].deviationCallCount = callcount.deviatedcount == "" ? 0 : Int(callcount.deviatedcount)!
                        }
                        
                    }
                }

                
                //For Upcoming Calls
                
                let upcomingChartData = LineChartData()
                upcomingChartData.chartName = .upcomingCalls
                upcomingChartData.weekDays = []
                print("Upcoming Calls")
                
                for i in 0 ..< 7
                {
                    let dayAndDate = self.getWeekDayWithDate(date: todayDate!, dayValue: (i), dateFormat: DateFormatString.serverFormat.rawValue)
                    
                    let weekDay = WeekDay()
                    weekDay.day = dayAndDate.1
                    weekDay.date = dayAndDate.0
                    print("Date \(dayAndDate.0), day \(dayAndDate.1)")

                    upcomingChartData.weekDays.append(weekDay)
                }
                
                
                for i in 0 ..< 7
                {
                    let dayAndDate = self.getWeekDayWithDate(date: todayDate!, dayValue: (i), dateFormat: DateFormatString.serverFormat.rawValue)
                    
                    var date: Date? = Date()
                    
                    for callcount in response.callcount
                    {
                        date = DateExtension.dateFromString(dateString: callcount.date, dateFormat: DateFormatString.serverFormat.rawValue)
                    
                            if DateExtension.equalTo(lhs: date!, rhs: dayAndDate.0)
                            {
                                
                                upcomingChartData.weekDays[i].totalCallCount = callcount.completedplannedcalls == "" ? 0 : Int(callcount.completedplannedcalls)!
                                upcomingChartData.weekDays[i].deviationCallCount = callcount.deviatedcount == "" ? 0 : Int(callcount.deviatedcount)!
                            }
                    
                    }
                }
                
                
                //Iterate CallList to Organize the Past, Today and Upcoming Calls
                // PastCalls(-7)--------------TodayCalls--------------UpcomingCalls(+7)
                for callList in response.calllist
                {
                    if callList.followups.count == 0 || callList.followups[0].followupdate == ""
                    {
                        continue
                    }
                    let dates = self.getDatesFromFollowUps(followUps: callList.followups)
                    print(dates)
                    let maxDate = DateExtension.findMaximumDate(dates)

                    let maxPastDate = DateExtension.generateDateWithGivenDays(date: todayDate!, days: -7)
                    let maxUpcomingDate = DateExtension.generateDateWithGivenDays(date: todayDate!, days: 7)
                    print("maxPastDate \(String(describing: maxPastDate))")
                    print("maxUpcomingDate \(String(describing: maxUpcomingDate))")
                    
                    //Removing call by mismatching a custid
                    
                   if let _ = DataBaseModel.getCustomerDetailForID(cusId: callList.custid)
                   {
                    print("Matching Custid")
                    }
                    else
                   {
                    continue
                    }
                    
                    
                    if DateExtension.equalTo(lhs: maxDate, rhs: todayDate!)
                        //&& callList.followups[0].updateddate == ""
                    {
                        //Today's Calls
                        self.todayCalls.append(callList)
                        // Today call also includes upcoming weeks
                        upcomingChartData.weekDays[0].totalCallCount += 1
                    }
                    else if DateExtension.greaterThan(lhs: todayDate!, rhs: maxDate)
                       // && DateExtension.lesserThan(lhs: maxUpcomingDate!, rhs: maxDate)
                    {
                        //Upcoming Calls
                        self.upcomingCalls.append(callList)
                        
                        //Upcoming Calls Total Call Count Update

//                        for i in 0 ..< upcomingChartData.weekDays.count
//                        {
//                            if DateExtension.equalTo(lhs: maxDate, rhs: upcomingChartData.weekDays[i].date)
//                            {
//                                upcomingChartData.weekDays[i].totalCallCount += 1
//                            }
//                        }
                    }
                    else if DateExtension.lesserThan(lhs: todayDate!, rhs: maxDate)
                      //  && DateExtension.greaterThan(lhs: maxPastDate!, rhs: maxDate)
                    {
                        //Past Calls
                        self.pastCalls.append(callList)
                        
                        //OverDue Calls Total Call Count Update
                        
//                        for i in 0 ..< overDueChartData.weekDays.count
//                        {
//                            if DateExtension.equalTo(lhs: maxDate, rhs: overDueChartData.weekDays[i].date)
//                            {
//                                overDueChartData.weekDays[i].totalCallCount += 1
//                            }
//                        }
                    }
                }
                
                //Iterate Past Calls to Filter OverDue Calls
                for pastCall in self.pastCalls
                {
                    //Check Is Update Date is Empty
                    //Because if the Update Date is Empty means salesman is not yet update the summary of the deal on time.
//                    let filterUpdateDate = pastCall.followups.filter() { $0.updateddate == "" }
//
//                    if filterUpdateDate.count > 0
//                    {
                        let overDueCallList = OverDueCallList()
                        overDueCallList.calllist = pastCall
                        overDueCallList.overDueDaysNo = 0
                        
                        self.overDueCalls.append(overDueCallList)
                        
                        //OverDue Calls Deviation Call Count Update
//                        for i in 0 ..< overDueChartData.weekDays.count
//                        {
//                            let followUpDate = DateExtension.dateFromString(dateString: filterUpdateDate[0].followupdate, dateFormat: DateFormatString.serverFormat.rawValue)
//
//                            if DateExtension.equalTo(lhs: followUpDate!, rhs: overDueChartData.weekDays[i].date)
//                            {
//                                print("\(followUpDate!) isEqualTo \(overDueChartData.weekDays[i].date)")
//                                overDueChartData.weekDays[i].deviationCallCount += 1
//                            }
//                        }
                   // }
                }
                
                for weekday in overDueChartData.weekDays
                {
                    print(weekday.date)
                    print("Total Call Count \(weekday.totalCallCount)")
                    print("Deviation Call Count \(weekday.deviationCallCount)")
                }
                
                //Iterate OverDueCallList to find the over due days count
                for i in 0 ..< self.overDueCalls.count
                {
                    var overDueDaysCount: Int = 0
                    
                    for followUp in self.overDueCalls[i].calllist.followups
                    {
                        if let followUpDate = DateExtension.dateFromString(dateString: followUp.followupdate, dateFormat: DateFormatString.serverFormat.rawValue)
                        {
                         //   if followUp.updateddate == ""
                        //    {
                                overDueDaysCount += DateExtension.findDateDifference(lhs: followUpDate, rhs: todayDate!) ?? 0
                       //     }
                        //    else
                        //    {
//                                if let updatedDate = DateExtension.dateFromString(dateString: followUp.updateddate, dateFormat: DateFormatString.serverFormat.rawValue)
//                                {
//                                    overDueDaysCount += DateExtension.findDateDifference(lhs: followUpDate, rhs: updatedDate) ?? 0
//                                }
                           // }
                        }
                    }
                    
                    self.overDueCalls[i].overDueDaysNo = overDueDaysCount
                }
                
                //Iterate to Sort the Potential Client Calls first
                self.todayCalls = self.todayCalls.sorted(by: { $0.ispotentialclient.uppercased() == "YES" ? true : false && !($1.ispotentialclient.uppercased() == "YES" ? true : false) } )
                self.upcomingCalls = self.upcomingCalls.sorted(by: { $0.ispotentialclient.uppercased() == "YES" ? true : false && !($1.ispotentialclient.uppercased() == "YES" ? true : false) } )
                self.overDueCalls = self.overDueCalls.sorted(by: { $0.calllist.ispotentialclient.uppercased() == "YES" ? true : false && !($1.calllist.ispotentialclient.uppercased() == "YES" ? true : false) } )

                self.lineChartData.append(overDueChartData)
                self.lineChartData.append(upcomingChartData)
                self.delegate?.callListOrgalized()
            }
            else
            {
                self.showFailureMessage(error: (error as NSError?)!)
                self.delegate?.apiHitFailure()
            }
        })
    }
    
    func getWeekDayWithDate(date: Date, dayValue: Int, dateFormat: String) -> (Date, String) {
        
        let date = DateExtension.generateDateWithGivenDays(date: date, days: dayValue)
        
        let weekDay = DateExtension.getWeekDayForDate(date: date!, dateFormat: dateFormat)
        
        return (date!, weekDay)
    }
    
    func getDatesFromFollowUps(followUps: [Followup]) -> [Date] {
    
         let dates = followUps.map({DateExtension.dateFromString(dateString: $0.followupdate, dateFormat: DateFormatString.serverFormat.rawValue)})
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        //formatter.dateFormat = "dd/MM/yy"
        
        //let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        //let yourDate = formatter.date(from: dates[0])
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "yyyy-MM-dd"
        // again convert your date to string
        let myStringafd = formatter.string(from: dates[0]!)
    
        print("followupdate \(myStringafd)")
        //followupdate [Optional(2018-05-03 00:00:00 +0000)]
        if myStringafd == "2018-05-08" {
            
            print("InnerDate \(dates)")
        }
        
        return dates as! [Date]
    }
}
