//
//  PotentialBusinessDataHandler.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class PotentialBusinessDataHandler: NSObject {

    func newPotentialBusiness(request: NewPotentialBusinessRequest, Completion handler:@escaping (NewPotentialBusinessResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.newPotentialBusiness
        {
            let url = APIConstants().getUrl(urlString: .newProfile)
            let body = request.dictionary
            
            WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken, showLoader: true).initiateServiceCall(httpMethod: .post, url: url, body: body) { (response, error) in
                if response != nil {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response ?? 0, options: .prettyPrinted)
                        let decodedValue = try JSONDecoder().decode(NewPotentialBusinessResponse.self, from: jsonData)
                        handler(decodedValue,nil)
                    }
                    catch (let error) {
                        handler(nil,error)
                    }
                }
                else {
                    handler(nil,error)
                }
            }
        }
        else
        {
            if let jsonData = CodeSnippets.getJsonDataForFile(fileName: "") //give exact test data json file name
            {
                do
                {
                    let response = try JSONDecoder().decode(NewPotentialBusinessResponse.self, from: jsonData)
                    handler(response, nil)
                }
                catch (let error)
                {
                    handler(nil, error)
                }
            }
        }
    }
    
    func updatePotentialBusiness(request: UpdatePotentialBusinessRequest, Completion handler:@escaping (UpdatePotentialBusinessResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.updatePotentialBusiness
        {
            let url = APIConstants().getUrl(urlString: .updateProfile)
            let body = request.dictionary
            
            WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken, showLoader: true).initiateServiceCall(httpMethod: .post, url: url, body: body) { (response, error) in
                if response != nil {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response ?? 0, options: .prettyPrinted)
                        let decodedValue = try JSONDecoder().decode(UpdatePotentialBusinessResponse.self, from: jsonData)
                        handler(decodedValue,nil)
                    }
                    catch (let error) {
                        handler(nil,error)
                    }
                }
                else {
                    handler(nil,error)
                }
            }
        }
        else
        {
            if let jsonData = CodeSnippets.getJsonDataForFile(fileName: "") //give exact test data json file name
            {
                do
                {
                    let response = try JSONDecoder().decode(UpdatePotentialBusinessResponse.self, from: jsonData)
                    handler(response, nil)
                }
                catch (let error)
                {
                    handler(nil, error)
                }
            }
        }
    }
}
