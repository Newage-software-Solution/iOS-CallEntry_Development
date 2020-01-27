//
//  CustomerDataHandler.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class CustomerDataHandler: NSObject {

    func newCustomer(request: NewCustomerRequest, Completion handler:@escaping (NewCustomerResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.newCustomer
        {
            
            let url = APIConstants().getUrl(urlString: .addNewCustomer)
            let body = request.dictionary
            
            print(body ?? 0)
            
    WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken, showLoader: true).initiateServiceCall(httpMethod: .post, url: url, body: body) { (response, error) in
                
                if response != nil {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response ?? 0, options: .prettyPrinted)
                        
                        let decodedValue = try JSONDecoder().decode(NewCustomerResponse.self, from: jsonData)
                        handler(decodedValue,nil)
                    }
                    catch(let error) {
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
                    let response = try JSONDecoder().decode(NewCustomerResponse.self, from: jsonData)
                    handler(response, nil)
                }
                catch (let error)
                {
                    handler(nil, error)
                }
            }
        }
    }
    
    func updateCustomer(request: UpdateCustomerRequest, Completion handler:@escaping (UpdateCustomerResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.updateCustomer
        {
            let url = APIConstants().getUrl(urlString: .updateCustomer)
            let body = request.dictionary
            
            print(body ?? 0)
            
            WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken, showLoader: true).initiateServiceCall(httpMethod: .post, url: url, body: body) { (response, error) in
                
                if response != nil {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response ?? 0, options: .prettyPrinted)
                        let decodedValue = try JSONDecoder().decode(UpdateCustomerResponse.self, from: jsonData)
                        handler(decodedValue,nil)
                    }
                    catch(let error) {
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
                    let response = try JSONDecoder().decode(UpdateCustomerResponse.self, from: jsonData)
                    handler(response, nil)
                }
                catch (let error)
                {
                    handler(nil, error)
                }
            }
        }
    }
    
    func customerList(request: CustomerListRequest, Completion handler:@escaping (CustomerListResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.customerList
        {
            let url = APIConstants().getdataRequest(urlString: .getCustomerList)
            let body = request.dictionary
            
            WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken , showLoader: true).initiateServiceCall(httpMethod: .get, url: url, body: body
                , Completion: { (response, error) in
                  
                    if response != nil
                    {
                        
                        print("Some Error")
                        do
                        {
                            let jsonData = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                            let decodedValue = try JSONDecoder().decode(CustomerListResponse.self, from: jsonData)
                            print(String(data: jsonData, encoding: String.Encoding.utf8) ?? "")
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
            if let jsonData = CodeSnippets.getJsonDataForFile(fileName: "Final Customer List") //give exact test data json file name
            {
                do
                {
                    let response = try JSONDecoder().decode(CustomerListResponse.self, from: jsonData)
                    handler(response, nil)
                }
                catch (let error)
                {
                    handler(nil, error)
                }
            }
        }
    }
    
    func employeeDetail(request: EmployeeDetailListRequest, Completion handler:@escaping (EmployeeDetailListResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.customerList
        {
            let url = APIConstants().getdataRequest(urlString: .getEmployeeDetail)
            let body = request.dictionary
            
            WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken , showLoader: true).initiateServiceCall(httpMethod: .get, url: url, body: body
                , Completion: { (response, error) in
                  
                    if response != nil
                    {
                        
                        print("Some Error")
                        do
                        {
                            let jsonData = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                            let decodedValue = try JSONDecoder().decode(EmployeeDetailListResponse.self, from: jsonData)
                            print(String(data: jsonData, encoding: String.Encoding.utf8) ?? "")
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
            if let jsonData = CodeSnippets.getJsonDataForFile(fileName: "Final Customer List") //give exact test data json file name
            {
                do
                {
                    let response = try JSONDecoder().decode(EmployeeDetailListResponse.self, from: jsonData)
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
