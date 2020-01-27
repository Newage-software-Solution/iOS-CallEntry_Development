//
//  DateExtension.swift
//  CallEntry
//
//  Created by Rajesh on 15/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class DateExtension: NSObject {

    static let weekdays = [
        "Sun",
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat"
    ]
    
    class func getCurrentDateComponents() -> DateComponents {
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        return components
    }
    
    class func calcAge(birthday : NSDate) -> String {
        
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let calcAge = calendar.components(.year, from: birthday as Date, to: Date(), options: [])
        let age = calcAge.year
        return String(age!)
    }
    
    //Date Comparision
    class func greaterThan(lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == ComparisonResult.orderedAscending
    }
    
    class func lesserThan(lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == ComparisonResult.orderedDescending
    }
    
    class func equalTo(lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == ComparisonResult.orderedSame
    }
    
    //Find Maximum Date
    class func findMaximumDate(_ dates: [Date]) -> Date {
        
        let date = dates.reduce(dates[0], {self.greaterThan(lhs: $0, rhs: $1) ? $1 : $0})
        return date
    }
    
    //Find Minimum Date
    class func findMinimumDate(_ dates: [Date]) -> Date {
        
        let date = dates.reduce(dates[0], {self.lesserThan(lhs: $0, rhs: $1) ? $1 : $0})
        return date
        
    }
    
    //String to Date
    class func dateFromString(dateString: String, dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        let datestring = "05/11/2019"
        dateFormatter.dateFormat = "dd-MMM-yy"
        var tempRequiredFormat = dateFormatter.date(from: datestring)
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        // Eric D's suggestion, forcing locale to en_EN
        dateFormatter.locale = Locale(identifier: "en_EN")
         tempRequiredFormat = dateFormatter.date(from: datestring)
        
        return dateFormatter.date(from: self.stringFromDate(date: tempRequiredFormat!, dateFormat: dateFormat)!)
    }
    
    //Date To String
    class func stringFromDate(date : Date, dateFormat : String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_EN")
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        return dateFormatter.string(from: date)
    }
    
    //Date by Adding and Subtracting days
    class func generateDateWithGivenDays(date: Date, days:Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: date)
    }
    
    //Find difference between two dates
    class func findDateDifference(lhs: Date, rhs: Date) -> Int? {
    
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: lhs)
        let date2 = calendar.startOfDay(for: rhs)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return components.day
    }

    //Get Future One Week List From Tomorrow
    class func getFutureOneWeekList() -> [Int] {
        var weekDayIndex = Calendar.current.component(.weekday, from: Date())
        
        var dayIndex: [Int] = []
        
        for _ in 0 ..< 7
        {
            
            if weekDayIndex == 7
            {
                weekDayIndex = 0
            }
            
            weekDayIndex += 1
            dayIndex.append(weekDayIndex - 1)
        }
        
        return dayIndex
    }
    
   
   class func DateFormateString(datestring: String, CurrentFormat curtFormat: String, ConvertFormat convertFormat: String) -> String?
    {
        
        let parsingFormatter: DateFormatter = DateFormatter()
        parsingFormatter.dateFormat = curtFormat
        guard let date = parsingFormatter.date(from: datestring) else { return nil }
        
        
        
        let displayingFormatter: DateFormatter = DateFormatter()
        displayingFormatter.dateFormat = convertFormat
        let display: String = displayingFormatter.string(from: date as Date)
        
        return display
    }
    
    //Get Past One Week List From Yesterday
    
    func getPastOneWeekList() -> [Int] {
        var weekDayIndex = Calendar.current.component(.weekday, from: Date())
        
        var dayIndex: [Int] = []
        
        for _ in 0 ..< 7
        {
            dayIndex.append(weekDayIndex - 1)
            
            if weekDayIndex == 7
            {
                weekDayIndex = 0
            }
            
            weekDayIndex += 1
        }
        
        return dayIndex
    }
    
    //Get WeekDay For Date
    class func getWeekDayForDate(date: Date, dateFormat: String) -> String {

//        let calendar = Calendar(identifier: .gregorian)
        let dateComponent = Calendar.current.component(.weekday, from: date)
        
        return self.weekdays[dateComponent - 1]
    }
    
    //Get Relative Date String from Date
    class func relativeDateStringForDate(date : Date) -> String {
        
        let todayDate = Date()
        
        let components = Calendar.current.dateComponents([.hour, .day, .month, .year, .weekOfYear], from: date)
        let componentsCurrentDate = Calendar.current.dateComponents([.hour, .day, .month, .year, .weekOfYear], from: todayDate)
        
        if (components.day! + 1) == componentsCurrentDate.day! && components.month! == componentsCurrentDate.month! && components.year! == componentsCurrentDate.year!
        {
            return "YESTERDAY"
        }
        else  if components.day == componentsCurrentDate.day && components.month == componentsCurrentDate.month && components.year == componentsCurrentDate.year
        {
            return "TODAY"
        }
        else
        {
            return ""
        }
    }

}


extension Date {
    func setTime(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String = "UTC") -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)
        
        components.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
        components.hour = hour
        components.minute = min
        components.second = sec
        
        return cal.date(from: components)
    }
   
}

struct DateFormatConstant {
    static let regularFormat = "dd-MMM-yy"
}

extension Date {
    func dateToString(outputFormat: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormat
        dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        
        return dateFormatter.string(from:self)
        
    }
    
    ///This function is used for adding components to date.
    func addComponentsToDate(seconds sec: Int, minutes min: Int, hours hrs: Int, days d: Int, weeks wks: Int, months mts: Int, years yrs: Int) -> Date {
        
        var dc = DateComponents()
        dc.second = sec
        dc.minute = min
        dc.hour = hrs
        dc.day = d
        dc.weekOfYear = wks
        dc.month = mts
        dc.year = yrs
        
        return Calendar.current.date(byAdding: dc, to: self)!
    }
    
    ///This function is used for converting self to Locale.
    func toLocale() -> Date {
        
        return self.addComponentsToDate(seconds: 0, minutes: +Int(30), hours: +Int(5), days: 0, weeks: 0, months: 0, years: 0)
    }
    
    
}
