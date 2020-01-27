//
//  SummaryDataHandler.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class SummaryDataHandler: NSObject {
    
    func updateSummary(request: UpdateSummaryRequest, Completion handler:@escaping (UpdateSummaryResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.updateSummary {
            
            let url = APIConstants().getdataRequest(urlString: .updateFollowUp)
            let body = request.dictionary
            
            WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken, showLoader: true).initiateServiceCall(httpMethod: .post, url: url, body: body, Completion: { (response, error) in
                
                if response != nil
                {
                    do
                    {
                        let jsonData = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                        let decodedValue = try JSONDecoder().decode(UpdateSummaryResponse.self, from: jsonData)
                        print(decodedValue)
                        handler(decodedValue, nil)
                    }
                    catch (let error)
                    {
                        handler(nil, error)
                    }
                }
                
            })
        }
        else
        {
            if let jsonData = CodeSnippets.getJsonDataForFile(fileName: "") //give exact test data json file name
            {
                do
                {
                    let response = try JSONDecoder().decode(UpdateSummaryResponse.self, from: jsonData)
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
