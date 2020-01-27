//
//  SideMenuModel.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

 protocol SideMenuModelDelegate {
      func apiHitFailure()
      func apiHitSuccess()
}

class SideMenuModel: NSObject {

    var delegate: SideMenuModelDelegate?
    
    
    func logoutAccount(request: LogoutRequest)
    {
        SideMenuDataHandler().logoutAccount(request: request) { (response, error) in
            if let _ = response
            {
                self.delegate?.apiHitSuccess()
            }
            else
            {
                self.delegate?.apiHitFailure()
            }
        }
    }
}
