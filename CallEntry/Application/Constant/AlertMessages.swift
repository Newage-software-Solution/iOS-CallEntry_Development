//
//  AlertMessages.swift
//  FrieghtSystem
//
//  Created by hms on 27/06/17.
//  Copyright © 2017 Hakunamatata solution (P) Ltd. All rights reserved.
//

import UIKit

class AlertMessages: NSObject {
    
    struct Message {
        
        //Common
        static let checkInternetConnection         = "Please check your internet connection."
        static let serverError           = "Unable to connect to server. Please try again after some time"
        static let noCamera = "Sorry , This Device has no Camera."
        static let comingSoon = ""//"Coming Soon...!"

        //User Account
        static let enterUserName       = "Please enter your UserName"
        static let enterEmailId        = "Please enter your EmailID"
        static let enterPassword       = "Please enter your Password"
        static let invalidEmailId      = "Your EmailID is invalid"
        static let invalidPassword     = "Password must contain atleast 5 characters"
        static let emailIdNotExist     = "EmailID doesn't exist."
        static let unmatchPassword     = "Password does not match"
        static let passwrdChangedSuccess = "Password changed successfully"

        //SideMenu
        static let logout = "Are you sure. Do you want to logout?"
        static let logoutFail = "Logout Failed"
        
        //Dashboard
        
        //Summary
        
        //Call Entry
        static let selectCustomerToViewProfile = "Please select Customer from the suggestion list to View Profile "
        static let selectCustomerToViewLastShipment = "Please select Customer from the suggestion list to View Last Shipments"
        static let selectCustomerToViewCallHistory = "Please select Customer from the suggestion list to View Call History "

        //Customer
        
        //Potential Business
        //Phone No
        static let phoneNoInvalid = "Phone Number is not Valid"
        
        static let preCallPlannerAlert = "Pre Call Planner not available"
        
    }
    
}
