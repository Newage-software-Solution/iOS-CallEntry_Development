//
//  BaseModel.swift
//  FrieghtSystem
//
//  Created by Susena on 12/04/17.
//  Copyright © 2017 Hakunamatata solution (P) Ltd. All rights reserved.
//

import UIKit

class BaseModel: NSObject {

    func showFailureMessage(error : NSError) {

        if error.code == -1001
        {
            self.showFailureMessageString(message: "Request Time Out")
        }
        else if error.code == -1003 || error.code == 4
        {
            //JsonSearilization failed
            self.showFailureMessageString(message: "Server is busy. Please try again")
        }
        else
        {
            self.showFailureMessageString(message: error.localizedDescription)

        }
        
    }
    
    func showFailureMessageString(message: String) {
        
        DispatchQueue.main.async{
            UIAlertView(title: "", message: message, delegate: self, cancelButtonTitle: "Ok").show()
        }
        
    }
    
    func removeLoader() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NoInternet"), object: nil)
    }
}
