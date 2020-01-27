//
//  CallEntryDataHandler.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class CallEntryDataHandler: NSObject {

    func getCallEntryList(request: GetCallEntryListRequest, Completion handler:@escaping (GetCallEntryListResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.callEntryList
        {
            let url = APIConstants().getUrl(urlString: .calllist)
            let body = request.dictionary
            WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken , showLoader: true).initiateServiceCall(httpMethod: .get, url: url, body: body
                , Completion: { (response, error) in
                    
                    if response != nil
                    {
                        do
                        {
                            let jsonData = try JSONSerialization.data(withJSONObject: response ?? 0, options: .prettyPrinted)
                            let decodedValue = try JSONDecoder().decode(GetCallEntryListResponse.self, from: jsonData)
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
            if let jsonData = CodeSnippets.getJsonDataForFile(fileName: "final Calllist") //give exact test data json file name
            {
                do
                {
                    let response = try JSONDecoder().decode(GetCallEntryListResponse.self, from: jsonData)
                    handler(response, nil)
                }
                catch (let error)
                {
                    handler(nil, error)
                }
            }
        }
    }
    
    func getCallhistoryList(request: CallhistoryRequest, Completion handler:@escaping (CallhistoryResponse?, Error?) -> Void) {
        
         let url = APIConstants().getUrl(urlString: .callHistory)
            let body = request.dictionary
        
            WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken , showLoader: true).initiateServiceCall(httpMethod: .get, url: url, body: body
                , Completion: { (response, error) in
                    
                    if response != nil
                    {
                        do
                        {
                            let jsonData = try JSONSerialization.data(withJSONObject: response ?? 0, options: .prettyPrinted)
                            let decodedValue = try JSONDecoder().decode(CallhistoryResponse.self, from: jsonData)
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
    
    func newCallEntry(request: NewCallEntryRequest, Completion handler:@escaping (NewCallEntryResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.newCallEntry {
            
            let url = APIConstants().getUrl(urlString: .newcall)
            let body = request.dictionary
            print(body!)
            WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken , showLoader: true).initiateServiceCall(httpMethod: .post, url: url, body: body
                , Completion: { (response, error) in
                    
                    if response != nil
                    {
                        do
                        {
                            let jsonData = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                            let decodedValue = try JSONDecoder().decode(NewCallEntryResponse.self, from: jsonData)
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
            if let jsonData = CodeSnippets.getJsonDataForFile(fileName: "") //give exact test data json file name
            {
                do
                {
                    let response = try JSONDecoder().decode(NewCallEntryResponse.self, from: jsonData)
                    handler(response, nil)
                }
                catch (let error)
                {
                    handler(nil, error)
                }
            }
        }
    }
    
    func updateCallEntry(request: UpdateCallEntryRequest, Completion handler:@escaping (UpdateCallEntryResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.updateCallEntry
        {
        }
        else
        {
            if let jsonData = CodeSnippets.getJsonDataForFile(fileName: "") //give exact test data json file name
            {
                do
                {
                    let response = try JSONDecoder().decode(UpdateCallEntryResponse.self, from: jsonData)
                    handler(response, nil)
                }
                catch (let error)
                {
                    handler(nil, error)
                }
            }
        }
    }
    
    func preCallPlannerList(request: PreCallPlannerListRequest, Completion handler:@escaping (PreCallPlannerListResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.preCallPlannerList
        {
        }
        else
        {
            if let jsonData = CodeSnippets.getJsonDataForFile(fileName: "Pre Call Planner") //give exact test data json file name
            {
                do
                {
                    let response = try JSONDecoder().decode(PreCallPlannerListResponse.self, from: jsonData)
                    handler(response, nil)
                }
                catch (let error)
                {
                    handler(nil, error)
                }
            }
        }
    }
    
    func getShipmentList(request: GetShipmentListRequest, Completion handler:@escaping (GetShipmentListResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.shipmentList
        {
            let url = APIConstants().getUrl(urlString: .shipmentHistory)
            let body = request.dictionary
            
            WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken , showLoader: true).initiateServiceCall(httpMethod: .get, url: url, body: body
                , Completion: { (response, error) in
                    
                    if response != nil
                    {
                        do
                        {
                            let jsonData = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                            let decodedValue = try JSONDecoder().decode(GetShipmentListResponse.self, from: jsonData)
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
            
           

            if let jsonData = CodeSnippets.getJsonDataForFile(fileName: "") //give exact test data json file name
            {
                do
                {
                    let response = try JSONDecoder().decode(GetShipmentListResponse.self, from: jsonData)
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
