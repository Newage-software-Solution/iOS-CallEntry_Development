//
//  UserAccountDataHandler.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

class UserAccountDataHandler: BaseDataHandler {
    
    func submitLoginDetails(request: LoginRequest, Completion handler:@escaping (LoginResponse?, Error?) -> Void) {
     
        if UIConstants.ServerApiHitFlag.submitLoginDetails
        {
            let url = APIConstants().getUrl(urlString: .login)
            let body = request.dictionary
            
            WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken , showLoader: true).initiateServiceCall(httpMethod: .post, url: url, body: body
                , Completion: { (response, error) in
                    print(url)
                    if response != nil
                    {
                        do
                        {
                            let jsonData = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                            let decodedValue = try JSONDecoder().decode(LoginResponse.self, from: jsonData)
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
            if isUsersValidtionSuccess(request)
            {
                var fileName = "LoginResponse"
                
                if request.username.uppercased() == "ADMIN"
                {
                    fileName = "LoginResponse-manager"
                }
                
                
                if let jsonData = CodeSnippets.getJsonDataForFile(fileName: fileName)
                {
                    do
                    {
                        let response = try JSONDecoder().decode(LoginResponse.self, from: jsonData)
                        handler(response, nil)
                    }
                    catch (let error)
                    {
                        handler(nil, error)
                    }
                }
            }
            else
            {
                
                let dict = NSDictionary(objects: [AlertMessages.Message.emailIdNotExist], forKeys: [NSLocalizedDescriptionKey as NSCopying])
                
                handler(nil, NSError(domain: "", code: 201, userInfo: dict as? [String : Any]))
            }
            
        }
    }
    
    func isUsersValidtionSuccess(_ request: LoginRequest) -> Bool {
        
        if UIConstants.allowedUsers.contains(request.username.lowercased())
        {
            let indexOfUser = UIConstants.allowedUsers.index(of: request.username.lowercased())
            
            if request.password == UIConstants.usersPassword[indexOfUser!]
            {
                return true
            }
        }
        
        return false
    }
    
    
    func forgotPassword(request: ForgotPasswordRequest, Completion handler:@escaping (ForgotPasswordResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.forgotPassword
        {
            let url = APIConstants().getUrl(urlString: .forgotPassword)
            let body = request.dictionary
            
            WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken , showLoader: true).initiateServiceCall(httpMethod: .post, url: url, body: body
                , Completion: { (response, error) in
                    
                    if response != nil
                    {
                        do
                        {
                            let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                            let decodedValue = try JSONDecoder().decode(ForgotPasswordResponse.self, from: jsonData)
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
                    let response = try JSONDecoder().decode(ForgotPasswordResponse.self, from: jsonData)
                    handler(response, nil)
                }
                catch (let error)
                {
                    handler(nil, error)
                }
            }
        }
    }
    
    func changePassword(request: ChangePasswordRequest, Completion handler:@escaping (ChangePasswordResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.changePassword
        {
            let url = APIConstants().getUrl(urlString: .changePassword)
            let body = request.dictionary
            
            WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken , showLoader: true).initiateServiceCall(httpMethod: .post, url: url, body: body
                , Completion: { (response, error) in
                    
                    if response != nil
                    {
                        do
                        {
                            let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                            let decodedValue = try JSONDecoder().decode(ChangePasswordResponse.self, from: jsonData)
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
                    let response = try JSONDecoder().decode(ChangePasswordResponse.self, from: jsonData)
                    handler(response, nil)
                }
                catch (let error)
                {
                    handler(nil, error)
                }
            }
        }
    }
    
    func getMasterData(request: GetMasterDataRequest, Completion handler:@escaping (GetMasterDataResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.masterData
        {
            let url = APIConstants().getdataRequest(urlString: .getMasterData)
            let body = request.dictionary
            
            WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken , showLoader: true).initiateServiceCall(httpMethod: .get, url: url, body: body
                , Completion: { (response, error) in
                   // print(response!)
                    if response != nil
                    {
                        do
                        {
                            let jsonData = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                            let decodedValue = try JSONDecoder().decode(GetMasterDataResponse.self, from: jsonData)
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
            if let jsonData = CodeSnippets.getJsonDataForFile(fileName: "masterdata")
            {
                do
                {
                    let response = try JSONDecoder().decode(GetMasterDataResponse.self, from: jsonData)
                    handler(response, nil)
                }
                catch (let error)
                {
                    handler(nil, error)
                }
            }
        }
    }
    
    func getPortData(request: GetPortDataRequest, Completion handler:@escaping (GetPortDataResponse?, Error?) -> Void) {
        
        if UIConstants.ServerApiHitFlag.portData
        {
            let url = APIConstants().getdataRequest(urlString: .getPortData)
            let body = request.dictionary
            
            WebServiceHandler(authToken: AppCacheManager.sharedInstance().authToken , showLoader: true).initiateServiceCall(httpMethod: .get, url: url, body: body
                , Completion: { (response, error) in
                    if response != nil
                    {
                        do
                        {
                            let jsonData = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                            let decodedValue = try JSONDecoder().decode(GetPortDataResponse.self, from: jsonData)
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
            if let jsonData = CodeSnippets.getJsonDataForFile(fileName: "portdata") //give exact test data json file name
            {
                do
                {
                    let response = try JSONDecoder().decode(GetPortDataResponse.self, from: jsonData)
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
