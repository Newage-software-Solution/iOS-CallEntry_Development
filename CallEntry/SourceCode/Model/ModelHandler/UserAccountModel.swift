//
//  UserAccountModel.swift
//  CallEntry
//
//  Created by Rajesh on 07/02/18.
//  Copyright © 2018 Gowtham. All rights reserved.
//

import UIKit

protocol UserAccountModelDelegate {
    func masterDataReceived()
    func portDataReceived()
    func customerListReceived()
    func employeeListReceived(response: [EmployeeDetail])
    func loginSuccess(response: LoginResponse)
    func apiHitFailure()
    func changePassword(message: String)
}

class UserAccountModel: BaseModel {

    var delegate: UserAccountModelDelegate?
    
    
    
    func submitLoginDetails(request: LoginRequest) {
        
        UserAccountDataHandler().submitLoginDetails(request: request, Completion: {(response, error) in
            
            if let errorData = error
            {
                self.showFailureMessage(error: errorData as NSError)
                self.delegate?.apiHitFailure()
            }
            else if let responseData = response
            {
                if responseData.statuscode == "200"
                {
                    AppCacheManager.sharedInstance().userId = responseData.logindetail.userid
                    AppCacheManager.sharedInstance().authToken = responseData.logindetail.usertoken
                    AppCacheManager.sharedInstance().userDetail = responseData.logindetail.userdetail
                   // AppCacheManager.sharedInstance().isManager = responseData.logindetail.ismanager
                    AppCacheManager.sharedInstance().salesmanCode = responseData.logindetail.empcode
                    AppCacheManager.sharedInstance().isManager = ""
                    

                    UserDefaultModel.updateUserInfo(loginDetail: responseData.logindetail)
                    
                    self.delegate?.loginSuccess(response: responseData)
                }
            }
        })
    }
    
    func forgotPassword(request: ForgotPasswordRequest) {
        
        UserAccountDataHandler().forgotPassword(request: request, Completion: {(response, error) in
            
            if let errorData = error
            {
                self.showFailureMessage(error: errorData as NSError)
                self.delegate?.apiHitFailure()
            }
            else if let responseData = response
            {
                
                if responseData.statuscode == "200"
                {
                    
                    self.delegate?.changePassword(message: response?.statusmessage ?? "Success")
                }
            }
        })
        
        
    }
    
    func getMasterData(request: GetMasterDataRequest) {
        
        UserAccountDataHandler().getMasterData(request: request, Completion: {(response, error) in
            
            if let errorData = error
            {
                self.showFailureMessage(error: errorData as NSError)
                self.delegate?.apiHitFailure()
            }
            else if let responseData = response
            {
                
                if responseData.statuscode == "200"
                {
                    AppCacheManager.sharedInstance().masterData = responseData.masterdata
                    self.delegate?.masterDataReceived()
                }
            }
        })
    }
    
    
    func getPortData(request: GetPortDataRequest) {
        
        UserAccountDataHandler().getPortData(request: request, Completion: {(response, error) in
            
            if let errorData = error
            {
                self.showFailureMessage(error: errorData as NSError)
                self.delegate?.apiHitFailure()
            }
            else if let responseData = response
            {
                if responseData.statuscode == "200"
                {
                    AppCacheManager.sharedInstance().portData = responseData.masterdata
                    self.delegate?.portDataReceived()
                }
            }
        })
    }
    
    func getCustomerList(request: CustomerListRequest) {
        
        CustomerDataHandler().customerList(request: request, Completion: {(response, error) in
            
            if let errorData = error
            {
                self.showFailureMessage(error: errorData as NSError)
                self.delegate?.apiHitFailure()
            }
            else if let responseData = response
            {
                if responseData.statuscode == "200"
                {
                    
                    var customerList: [Customerlist] = []
                    
                    if request.updateddata == "N" {
                    
                        CustomerListDB.saveCustomerList(customerList: responseData.customerlist)
                    
                    }
                    else {
                       
                        for cust in responseData.customerlist {
                            
                            if CustomerListDB.isCustomerExist(id: cust.custid) {
                                print("Customer Id already exist")
                            }
                            else {
                                print("customer not exist")
                                customerList.append(cust)
                            }
                        }
                        
                        CustomerListDB.saveCustomerList(customerList: customerList)
                        
                    }
                    
                    AppCacheManager.sharedInstance().customerList = CustomerListDB.fetchCustomerList()
                    
                    self.delegate?.customerListReceived()
                }
            }
        })
    }
    
    func getEmployeeDetailList(request: EmployeeDetailListRequest) {
        
        CustomerDataHandler().employeeDetail(request: request, Completion: {(response, error) in
            
            if let errorData = error
            {
                self.showFailureMessage(error: errorData as NSError)
                self.delegate?.apiHitFailure()
            }
            else if let responseData = response
            {
                if responseData.statuscode == "200"
                {
                    
                    var employeeList: [EmployeeDetail] = []
                    
                    
                        //CustomerListDB.saveCustomerList(customerList: responseData.employeelist)
                    
                       
                        for cust in responseData.employeelist {
                            
//                            if CustomerListDB.isCustomerExist(id: cust.custid) {
//                                print("Customer Id already exist")
//                            }
//                            else {
                                print("customer not exist")
                                employeeList.append(cust)
//                            }
                        }
                        
                        //CustomerListDB.saveCustomerList(customerList: customerList)
                        
                    //}
                    
                    //AppCacheManager.sharedInstance().customerList = CustomerListDB.fetchCustomerList()
                    
                    self.delegate?.employeeListReceived(response: employeeList)
                }
            }
        })
    }
    
    func changeUserPasswordRequest(request: ChangePasswordRequest) {
        
        UserAccountDataHandler().changePassword(request: request) { (response, error) in
            if let errorData = error
            {
                self.showFailureMessage(error: errorData as NSError)
                self.delegate?.apiHitFailure()
            }
            else if let responseData = response
            {
                if responseData.statuscode == "200"
                {
                    self.delegate?.changePassword(message: responseData.statusmessage)
                }
            }
        }
        
    }
}

