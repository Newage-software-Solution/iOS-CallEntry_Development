//
//  SideMenuDataHandler.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class SideMenuDataHandler: NSObject {

    func logoutAccount(request: LogoutRequest, Completion handler:@escaping (LogoutResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.logout
        {
            let url = APIConstants().getdataRequest(urlString: .logout)
            let body = request.dictionary
            
            WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken, showLoader: true).initiateServiceCall(httpMethod: .get, url: url, body: body, Completion: { (response, error) in
                
                if response != nil
                {
                    do
                    {
                        let jsonData = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                        let decodedValue = try JSONDecoder().decode(LogoutResponse.self, from: jsonData)
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
                    let response = try JSONDecoder().decode(LogoutResponse.self, from: jsonData)
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
