//
//  DashboardDataHandler.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class DashboardDataHandler: NSObject {

    func getSalesManList(request: GetSalesManListRequest, Completion handler:@escaping (GetSalesManListResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.salesManList
        {
            let url = APIConstants().getdataRequest(urlString: .salesmanList)
            let body = request.dictionary
            WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken , showLoader: true).initiateServiceCall(httpMethod: .get, url: url, body: body
                , Completion: { (response, error) in
                    
                    if response != nil
                    {
                        do
                        {
                            let jsonData = try JSONSerialization.data(withJSONObject: response ?? 0, options: .prettyPrinted)
                            let decodedValue = try JSONDecoder().decode(GetSalesManListResponse.self, from: jsonData)
                            print(decodedValue)
                            handler(decodedValue, nil)
                        }
                        catch (let error)
                        {
                            handler(nil, error)
                        }
                        
                    }
                    else
                    {
                        handler(nil, error)
                    }
            })
        }
        else
        {
            if let jsonData = CodeSnippets.getJsonDataForFile(fileName: "salesmanlist") //give exact test data json file name
            {
                do
                {
                    let response = try JSONDecoder().decode(GetSalesManListResponse.self, from: jsonData)
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
