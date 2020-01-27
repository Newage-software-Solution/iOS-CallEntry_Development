 //
 //  WebServiceHandler.swift
 //  LIAD
 //
 //  Created by Jeyaraj on 27/04/15.
 //  Copyright (c) 2015 hakuna. All rights reserved.
 //
 
 import UIKit
 import Alamofire
 
 
 class WebServiceHandler: NSObject {
    
//    var basecontrollerObj = BaseViewController()
    private var showLoader = true
    private var authToken = ""
    
    private var userInteractionEnabled = false
    
    var authenticationUserName = ""
    var authenticationPassword = ""
    
    override init() {
        super.init()
    }
    
    init(interaction : Bool) {
        super.init()
        userInteractionEnabled = interaction
        self.showLoader = !userInteractionEnabled
    }
    
    init(authToken: String, showLoader : Bool)
    {
        super.init()
        self.showLoader = showLoader
        self.authToken = authToken
        //        return self
    }
    
    func getEncodedString(inputStr : String) -> String {
        
        if let encodedString = inputStr.addingPercentEncoding(withAllowedCharacters:
            CharacterSet.urlFragmentAllowed) {
            
            return encodedString
            
        }
        
        return ""
    }
    
    
    func initiateServiceCall(httpMethod: HTTPMethod, url : String, body : Parameters?, Completion responseHandler : @escaping (NSDictionary?, NSError?) -> Void)
    {
        URLCache.shared.removeAllCachedResponses()
        
        print("RequestedURL: \(url)")
        print("Method: \(httpMethod)")
        
        if let isNetworkError = isReachable()
        {
            responseHandler(nil, isNetworkError)
            return
        }
        else
        {
            
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body ?? [:], options: .prettyPrinted)
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            if let jsonValue = decoded as? [String:String] {
                print("RequestJSON: \(jsonValue)")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        if showLoader
        {
            addloader();
        }
        
        let urlString = url
        var encodeString = self.getEncodedString(inputStr: url)
        
        print("RequestedURL: \(encodeString)")
        
        if encodeString != ""
        {
            
            if encodeString.contains("maps.googleapis.com") || encodeString.contains("maps.google.com")
            {
                encodeString = urlString
            }
            
            let headers: HTTPHeaders = [
                "Authorization": self.authToken,
                "Accept": "application/json"
            ]
            
            Alamofire.request(encodeString, method: httpMethod, parameters: body, encoding: JSONEncoding.default, headers: headers).authenticate(user: authenticationUserName, password: authenticationPassword).responseJSON(completionHandler: { (response) in
                
                self.removeLoader()
                
                switch response.result {
                    
                case .success(let responseValue):
                    print("Response: \(responseValue)")
                    if let requestJson = response.request?.httpBody {
                        
                        print("Request VAlue: \(String(describing: self.nsdataToJSON(data: requestJson)))")
                    }
                    
                    if let statusCode = (responseValue as? NSDictionary)?["statusCode"] as? Int
                    {
                        if statusCode == 401
                        {
                            AppCacheManager.sharedInstance().authToken = ""
                            //self.showAlert(message: "Session has been expired , please login to continue")
                            //                            NotificationCenter.default.post(name : NSNotification.Name(rawValue : NotificationCenterKey.badToken.rawValue),object : nil)
                            
                            return
                        }
                        else if statusCode == 408
                        {
                            AppCacheManager.sharedInstance().authToken = ""
                            //self.showAlert(message: "User account is inactive")
                            //                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenterKey.accountInactive.rawValue), object: nil)
                            return
                        }
                    }
                    
                    if responseValue is NSMutableArray || responseValue is NSArray  || (responseValue as AnyObject).count == 0
                    {
                        let distData = ["suburbSearch":responseValue]
                        responseHandler(distData as NSDictionary? , nil)//as? Dictionary<String, Any> as NSDictionary?
                    }
                    else
                    {
                        if let error = self.getError(statusObject: responseValue as! NSDictionary)
                        {
                            responseHandler(nil, error)
                        }
                        else
                        {
                            responseHandler(responseValue as? Dictionary<String, Any> as NSDictionary?, nil)
                        }
                    }
                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                    
                    if error.localizedDescription == "The request timed out"
                    {
                        //  self.showAlert(message: error.localizedDescription)
                    }
                    else
                    {
                        //  self.showAlert(message: "internal server error")
                    }
                }
            })
        }
    }
    
    func nsdataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    func UploadWithAlamofire(url : String, image : Data, parameters: Parameters, header :  [String : AnyObject]?, filename : String, mimeType : String,  Completion responseHandler : @escaping (NSDictionary?, NSError?) -> Void) {
        if let isNetworkError = isReachable()
        {
            responseHandler(nil, isNetworkError)
            return
        }
        
        if showLoader
        {
            addloader()
        }
        
        let headers: HTTPHeaders = [
            "authorization": self.authToken,
            "Accept": "application/json"
        ]
        let URL = try! URLRequest(url: url, method: .post, headers: headers)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            
            multipartFormData.append(image, withName: filename, fileName: filename, mimeType: "text/plain")
            
            
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, with: URL, encodingCompletion: { (result) in
            
            
            self.removeLoader()
            
            switch result {
                
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    switch response.result {
                        
                    case .success(let responseValue):
                        print("Response: \(responseValue)")
                        
                        if let statusCode = (responseValue as? NSDictionary)?["statusCode"] as? Int
                        {
                            if statusCode == 401
                            {
                                AppCacheManager.sharedInstance().authToken = ""
                                // self.showAlert(message: "Session has been expired , please login to continue")
                                //                                NotificationCenter.default.post(name : NSNotification.Name(rawValue : NotificationCenterKey.badToken.rawValue),object : nil)
                                return
                            } else if statusCode == 408 || statusCode == 410 {
                                
                                AppCacheManager.sharedInstance().authToken = ""
                                //  self.showAlert(message: "User account is inactive")
                                //                                NotificationCenter.default.post(name : NSNotification.Name(rawValue : NotificationCenterKey.accountInactive.rawValue),object : nil)
                                return
                            }
                        }
                        
                        if let error = self.getError(statusObject: responseValue as! NSDictionary)
                        {
                            responseHandler(nil, error)
                        }
                        else
                        {
                            responseHandler(responseValue as? Dictionary<String, Any> as NSDictionary?, nil)
                        }
                        
                    case .failure(let error):
                        
                        if error.localizedDescription == "The request timed out"
                        {
                            self.showalertmessage(message: error.localizedDescription)
                        }
                        else
                        {
                            self.showalertmessage(message: "internal server error")
                        }
                        
                    }
                }
                
                
            case .failure(let encodingError):
                
                print(encodingError)
                
            }
            
        })
        
    }
    
    func addloader()
    {
        
        //        removeLoader()
        //        SVProgressHUD.setDefaultMaskType(.gradient)
        //
        //        SVProgressHUD.setBackgroundColor(UIColor(red: 108/255, green: 178/255, blue: 67/255, alpha: 1.0 ))
        //        SVProgressHUD.setRingThickness(4.0)
        //        SVProgressHUD.setForegroundColor(UIColor.white)
        //        SVProgressHUD.show()
    }
    
    func removeLoader()
    {
        //        SVProgressHUD.dismiss()
    }
    
    //MARK:- Get Error object
    
    func getError(statusObject : NSDictionary) -> NSError?
    {
        let statusCode = statusObject["statusCode"] as! Int
        
        if statusCode == 200 {
            return nil
        }
        
        var messageString = statusObject["message"] as? String
        
        if messageString == nil
        {
            let dict = statusObject["meta"] as? NSDictionary
            messageString = dict?["message"] as? String
        }
        
        if messageString == nil
        {
            messageString = statusObject["message"] as? String ?? "Server error. Please try again"
        }
        
        if messageString!.uppercased().contains("THE OPERATION COULD")
        {
            messageString = "Server is busy. Please try again."
        }
        
        let dict = NSDictionary(objects: [messageString!], forKeys: [NSLocalizedDescriptionKey as NSCopying])
        
        return NSError(domain: "", code: statusCode, userInfo: dict as [NSObject : AnyObject])
    }
    
    
    
    //MARK:- Append Date with url to avoid cached call
    
    
    func appendDatewithURl(url : String) -> String{
        
        return url
    }
    
    func isReachable() -> NSError? {
        
        if Reachability.isConnectedToNetwork()
        {
            
            return nil
            
            
        } else {
            
            
            let dict = NSDictionary(objects: ["Please check your internet connection"], forKeys: [NSLocalizedDescriptionKey as NSCopying])
            
            
            return NSError(domain: "", code: 600, userInfo: dict as [NSObject : AnyObject])
            
            
        }
    }
    
    
    func showalertmessage(message : String) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let retry = UIAlertAction(title: "ok", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        alertController.addAction(retry)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
 }
