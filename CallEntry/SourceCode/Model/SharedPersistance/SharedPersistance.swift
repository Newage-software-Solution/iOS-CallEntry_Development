//
//  SharedPersistance.swift
//  CallEntry
//
//  Created by Sivamoorthy on 03/05/18.
//  Copyright © 2017 Hakunamatata. All rights reserved.
//

import Foundation
import UIKit

class SharedPersistance: NSObject {
    
    //Properties 
    
    let defaults = UserDefaults.standard
    
    
    func setWishesData(data : String) {
        
        defaults.set(data, forKey: "wishesdata")
    }
    
    func getWishesData() -> String {
        
        return (defaults.object(forKey: "wishesdata") as? String ?? "")
    }
    
    func setBreakPreviousRecord(data : String) {
        
        defaults.set(data, forKey: "previousrecord")
    }
    
    func getBreakPreviousRecord() -> String {
        
        return (defaults.object(forKey: "previousrecord") as? String ?? "")
    }
    
    func setOverDueTodayCallsCompleted(data : String) {
        
        defaults.set(data, forKey: "todaycalldone")
    }
    
    func getOverDueTodayCallsCompleted() -> String {
        
        return (defaults.object(forKey: "todaycalldone") as? String ?? "")
    }
    
    
    func setTakeUpCommingCall(data : String) {
        
        defaults.set(data, forKey: "takeUpcomingcall")
    }
    
    func getTakeUpCommingCall() -> String {
        
        return (defaults.object(forKey: "takeUpcomingcall") as? String ?? "")
    }
    
    
    func setThreeMoreCallBreakRecord(data : String) {
        
        defaults.set(data, forKey: "threemorecallbreakrecord")
    }
    
    func getThreeMoreCallBreakRecord() -> String {
        
        return (defaults.object(forKey: "threemorecallbreakrecord") as? String ?? "")
    }
    
    
    func setThreeMoreCallToCompleteToday(data : String) {
        
        defaults.set(data, forKey: "3morecallcompletetoday")
    }
    
    func getThreeMoreCallToCompleteToday() -> String {
        
        return (defaults.object(forKey: "3morecallcompletetoday") as? String ?? "")
    }

    func setCustomerQuerySuccess(name : String) {
        
        defaults.set(name, forKey: "CustomerQuerySuccess")
    }
    
    func getCustomerQuerySuccess() -> String {
        
        return (defaults.object(forKey: "CustomerQuerySuccess") as? String ?? "")
    }
    
    func setFirstTimeAndTodayAllCallCompleted(todayCallCompleted : String) {
        
        defaults.set(todayCallCompleted, forKey: "FirstTimeAndTodayAllCallCompleted")
    }
    
    func getFirstTimeAndTodayAllCallCompleted() -> String {
        
        return (defaults.object(forKey: "FirstTimeAndTodayAllCallCompleted") as? String ?? "")
    }
    
    func setCustomerId(custId: String) {
        defaults.set(custId, forKey: "setCustomerId")
    }
    
    func getCustomerId() -> String {
        return (defaults.object(forKey: "setCustomerId") as? String ?? "")
    }

}


