//
//  DataExtension.swift
//  FrieghtSystem
//
//  Created by hmspl on 19/05/17.
//  Copyright © 2017 Hakunamatata solution (P) Ltd. All rights reserved.
//

import UIKit

class DataExtension: NSObject {

    func getCurrentDateComponents() -> DateComponents {
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        return components
    }
    
    func calcAge(birthday : NSDate) -> String {
        
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let calcAge = calendar.components(.year, from: birthday as Date, to: Date(), options: [])
        let age = calcAge.year
        return String(age!)
    }
}


extension NameDTO {
    
    var getName : String {
        
        get {
            
            if firstName != ""
            {
                if lastName != ""
                {
                    return firstName.trim() + " " + lastName.trim()
                }
                
                return firstName.trim()
            }
            else if lastName != ""
            {
                return lastName.trim()
            }
            
            return ""
        }
        
    }

}


