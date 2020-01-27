//
//  CustomerModel.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

@objc protocol CustomerModelDelegate {
    @objc func apiHitFailure(error: Error)
    @objc func apiHitSuccess(key: String)
    @objc optional func customerlistUpdatedSuccessfully()
}

class CustomerModel: NSObject {

    var delegate: CustomerModelDelegate?
    
   

    func newCustomer(request: NewCustomerRequest) {
        
        CustomerDataHandler().newCustomer(request: request) { (response, error) in
            
            if let customerResponse = response {
                self.delegate?.apiHitSuccess(key: customerResponse.customercode)
            }
            else if let errorData = error {
                self.delegate?.apiHitFailure(error: errorData)
            }
            
        }
    }
    
    func updateCustomer(request: UpdateCustomerRequest) {
        CustomerDataHandler().updateCustomer(request: request) { (response, error) in
            
            if  response != nil {
                if let delegate = self.delegate?.customerlistUpdatedSuccessfully {
                    delegate()
                }
            }
            else if let errorData = error {
                self.delegate?.apiHitFailure(error: errorData)
            }
            
        }
    }
    
    func customerList(isNewCustomerList: Bool, request: CustomerListRequest) {
        
    }
    
  
}
