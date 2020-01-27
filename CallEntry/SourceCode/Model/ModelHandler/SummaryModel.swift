//
//  SummaryModel.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

@objc protocol SummaryModelDelegate {
    
    @objc optional func apiHitFailure()
    @objc optional func apiHitSuccess()
}

class SummaryModel: BaseModel {

    var delegate: SummaryModelDelegate?
    
    func updateSummary(request: UpdateSummaryRequest) {
        
        SummaryDataHandler().updateSummary(request: request, Completion: { (response, error) in
          
            if let responseData = response, responseData.statuscode == "200" {
                
                self.delegate?.apiHitSuccess?()
            } else if let errorData = error {
                
                self.showFailureMessage(error: errorData as NSError)
                self.delegate?.apiHitFailure?()
            }
        })
    }
}
