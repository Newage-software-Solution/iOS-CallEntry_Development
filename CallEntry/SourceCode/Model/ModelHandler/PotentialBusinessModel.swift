//
//  PotentialBusinessModel.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

protocol PotentialBusinessModelDelegate {
    func apiHitFailure(error: Error)
    func apiHitSuccess(isFrom : String,response : NewPotentialBusinessResponse)
    func apiEditProfileHitSuccess(response : UpdatePotentialBusinessResponse)
}

class PotentialBusinessModel: NSObject {

   
    var delegate: PotentialBusinessModelDelegate?
    
    
    func newPotentialBusiness(request: NewPotentialBusinessRequest) {
        PotentialBusinessDataHandler().newPotentialBusiness(request: request) { (response, error) in
            if response != nil {
                let isFrom = "newPotentialBusiness";
                self.delegate?.apiHitSuccess(isFrom: isFrom,response: response!)
            }
            else if let error = error {
                self.delegate?.apiHitFailure(error: error)
            }
        }
    }
    
    func updatePotentialBusiness(request: UpdatePotentialBusinessRequest) {
        PotentialBusinessDataHandler().updatePotentialBusiness(request: request) { (response, error) in
            if response != nil {
                self.delegate?.apiEditProfileHitSuccess(response: response!)
            }
            else if let error = error {
                self.delegate?.apiHitFailure(error: error)
            }
        }
    }
}
