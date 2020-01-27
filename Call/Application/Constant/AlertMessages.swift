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
        
        static let internetAlert         = "Please check your internet connection."
        static let serverError           = "Unable to connect to server. Please try again after some time"
        static let locationAlertMsg      = "Kindly enable your location service"
        static let validEmailAlert       = "Please enter your valid email id"
        static let passwordValidateAlert = "Password must contain atleast 6 characters"
        static let passwordMailedAlert   = "Your password has been mailed to your account"
        static let hblNumberAlert        = "Enter HBL number"
        static let polSelectionAlert     = "Select POL from the list"
        static let destSelectionAlert    = "Select destination from the list"
        static let originSelectionAlert  = "Select origin from the list"
        static let validWeightAlert      = "Enter a valid weight"
        static let validVolumeAlert      = "Enter a valid volume"
        static let weightZeroAlert       = "Weight should be greater than 0."
        static let volZeroAlert          = "Volume should be greater than 0."
        static let validMobileNumber     = "Please enter your valid mobile number"
        
        static let noCamAlert = "Sorry , This Device has no Camera."
    }
    
}
