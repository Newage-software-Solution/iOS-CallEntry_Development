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

//            let headers: HTTPHeaders = [
//                "Authorization": self.authToken,
//                "Content-Type": "application/x-www-form-urlencoded"
//            ]
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 180
            manager.request(encodeString, method: httpMethod, parameters: body, encoding: URLEncoding.default, headers: headers).authenticate(user: authenticationUserName, password: authenticationPassword).responseJSON(completionHandler: { (response) in

                self.removeLoader()
                switch response.result {

                case .success(let responseValue):
                 //   print("Response: \(responseValue)")
//                    if let requestJson = response.request?.httpBody {
//
//                        print("Request VAlue: \(String(describing: self.nsdataToJSON(data: requestJson)))")
//                    }

                    if let statusCode = (responseValue as? NSDictionary)?["statuscode"] as? String
                    {
                        if statusCode == "401"
                        {
                            AppCacheManager.sharedInstance().authToken = ""
                            //self.showAlert(message: "Session has been expired , please login to continue")
                            //                            NotificationCenter.default.post(name : NSNotification.Name(rawValue : NotificationCenterKey.badToken.rawValue),object : nil)

                            return
                        }
                        else if statusCode == "408"
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
                    responseHandler(nil, error as NSError)
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
//
//    func nsdataToJSON(data: Data) -> Any? {
//        do {
//            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//        } catch let myJSONError {
//            print(myJSONError)
//        }
//        return nil
//    }

//    func nsdataToJSON(data: Data) -> Any? {
//        do {
//            return try JSONEncoder.encode(data)
//        } catch let myJSONError {
//            print(myJSONError)
//        }
//        return nil
//    }
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
              //  SVProgressHUD.dismiss()
    }

    //MARK:- Get Error object

    func getError(statusObject : NSDictionary) -> NSError?
    {
        let statusCode = statusObject["statuscode"] as! String

        if statusCode == "200" {
            return nil
        }

        var messageString = statusObject["statusmessage"] as? String

        if messageString == nil
        {
            let dict = statusObject["meta"] as? NSDictionary
            messageString = dict?["statusmessage"] as? String
        }

        if messageString == nil
        {
            messageString = statusObject["statusmessage"] as? String ?? "Server error. Please try again"
        }

        if messageString!.uppercased().contains("THE OPERATION COULD")
        {
            messageString = "Server is busy. Please try again."
        }

        let dict = NSDictionary(objects: [messageString!], forKeys: [NSLocalizedDescriptionKey as NSCopying])

        return NSError(domain: "", code: Int(statusCode)!, userInfo: dict as? [String : Any])
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


            return NSError(domain: "", code: 600, userInfo: dict as? [String : Any])


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
//
//
// //
// //  WebServiceHandler.swift
// //  LIAD
// //
// //  Created by Jeyaraj on 27/04/15.
// //  Copyright (c) 2015 hakuna. All rights reserved.
// //
//
// import UIKit
// import Alamofire
//
// class BaseServiceHandler: NSObject {
//
//    var showLoader = true
//
//    let viewForLoader = UIView()
//
//    init(showLoader : Bool)
//    {
//        super.init()
//        self.showLoader = showLoader
//        //        return self
//    }
//
//    override init() {
//        super.init()
//    }
//
//    func addLoader() {
//
//        removeLoader()
//
//        //        let appDelegate =  UIApplication.shared.delegate as? AppDelegate
//        //        appDelegate?.window?.addSubview(viewForLoader)
//        //        //        viewForLoader.addSubview(loader)
//        //        viewForLoader.isHidden = false
//        //
//        //        let screenSize = UIScreen.main.bounds
//        //
//        //        let width: CGFloat = 100
//        //        let height: CGFloat = 100
//        //        let x = (screenSize.width / 2) - 50
//        //        let y = (screenSize.height / 2) - 50
//        //
//        //        if let loaderImage = UIImage.gifImageWithName(name: "Rolling") {
//        //            let loader = UIImageView.init(image: loaderImage)
//        //            loader.frame = CGRect.init(x: x, y: y, width: width, height: height)// CGRectMake(x, y, width, height)
//        //            //            loader.center = UIScreen.main
//        //            loader.contentMode = .scaleAspectFit
//        //            loader.clipsToBounds = true
//        //            loader.tag = 1001
//        //            viewForLoader.clipsToBounds = true
//        //            viewForLoader.frame = CGRect.init(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
//        //            viewForLoader.addSubview(loader)
//        //            viewForLoader.isHidden = false
//        //            viewForLoader.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
//        //        }
//    }
//
//    func removeLoader() {
//
//        //        if loader != nil {
//        //            loader.stopAnimating()
//        //            loader.removeFromSuperview()
//        //            loader = nil
//        //        }
//
//        viewForLoader.viewWithTag(1001)?.removeFromSuperview()
//
//        viewForLoader.removeFromSuperview()
//
//    }
// }
//
//
// class WebServiceHandler: BaseServiceHandler {
//
//    private var userInteractionEnabled = false
//
//    var authenticationUserName = ""
//    var authenticationPassword = ""
//
//    override init() {
//        super.init()
//    }
//
//    /// Initialize with Loader
//
//
//
//    func getEncodedString(inputStr : String) -> String {
//
//        if let encodedString = inputStr.addingPercentEncoding(withAllowedCharacters:
//            CharacterSet.urlFragmentAllowed) {
//
//            return encodedString
//
//        }
//
//        return ""
//    }
//
//    func initiateServiceCall(httpMethod: HTTPMethod, url : String, body : Parameters?, Completion responseHandler : @escaping (NSDictionary?, NSError?) -> Void)
//    {
//        URLCache.shared.removeAllCachedResponses()
//
//        //        let cstorage = HTTPCookieStorage.shared
//        //        if let cookies = cstorage.cookies {
//        //            for cookie in cookies {
//        //                cstorage.deleteCookie(cookie)
//        //            }
//        //        }
//        /*let httpCookie = HTTPCookie.init(properties:
//         [HTTPCookiePropertyKey.version : "0",
//         HTTPCookiePropertyKey.name : "incap_ses_459_1270408",
//         HTTPCookiePropertyKey.value : "RD9DaJDA0Fv/hg0asrJeBnV5slkAAAAAeGKXovTFL30XU8BlEiMeOg==",
//         HTTPCookiePropertyKey.expires : "2027-05-13 09:21:23 +0000"])
//         if let cookie = httpCookie {
//         HTTPCookieStorage.shared.setCookie(cookie)
//         }*/
//
//        if let isNetworkError = isReachable()
//        {
//            responseHandler(nil, isNetworkError)
//            return
//        }
//
//        addLoader()
//
//        let urlString = url.replacingOccurrences(of: " ", with: "%20")
//        print("urlString \(urlString)")
//
//        let encodeString = self.getEncodedString(inputStr: urlString)
//
//        if encodeString != ""
//        {
//

//
//            loadCookies()
//
//            let credentialData = "\(APIConstants.userName):\(APIConstants.password)".data(using: String.Encoding.utf8)!
//            let base64Credentials = credentialData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
//            let headers = ["Authorization": "Basic \(base64Credentials)"]
//
//            manager.request(encodeString, method: httpMethod, parameters: body, encoding: JSONEncoding.default, headers: headers).authenticate(user: APIConstants.userName, password: APIConstants.password).responseJSON(completionHandler: { (response) in
//
//                self.saveCookies(response: response)
//
//                self.removeLoader()
//
//                switch response.result {
//
//                case .success(let responseValue):
//                    print("Response: \(responseValue)")
//
//                    if let error = self.getError(statusObject: responseValue as! NSDictionary)
//                    {
//                        responseHandler(nil, error)
//                    }
//                    else
//                    {
//                        responseHandler(responseValue as? Dictionary<String, Any> as NSDictionary?, nil)
//                    }
//
//                case .failure(let error):
//                    print(error)
//                    responseHandler(nil, error as NSError?)
//                }
//            })
//        }
//
//    }
//
//    func initiateServiceCallWithMultiformData(url : String, method: HTTPMethod,params: Parameters, header :  [String : AnyObject]?,  Completion responseHandler : @escaping (NSDictionary?, NSError?) -> Void) {
//
//        let manager = Alamofire.SessionManager.default
//
//        let credentialData = "\(APIConstants.userName):\(APIConstants.password)".data(using: String.Encoding.utf8)!
//        let base64Credentials = credentialData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
//        let headers = ["Authorization": "Basic \(base64Credentials)"]
//
//        addLoader()
//
//        manager.upload(multipartFormData: { (multipartFormData) in
//
//            for (key, value) in params {
//                if JSONSerialization.isValidJSONObject(value) {
//
//                    do {
//                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
//                        multipartFormData.append((NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String).data(using: .utf8)!, withName: key)
//
//                        //                        if let array = value as? [String] {
//                        //
//                        //                            for string in array {
//                        //                                if let stringData = string.data(using: .utf8) {
//                        //                                    multipartFormData.append(stringData, withName: key+"[]")
//                        //                                }
//                        //                            }
//                        //                        }
//                    } catch {
//
//                    }
//
//                } else {
//                    multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
//                }
//            }
//
//
//        }, to: url, method: method, headers: headers) { (response) in
//
//            switch(response) {
//
//            case .success(let request, _ , _ ):
//
//                //                request.responseData(completionHandler: { (data) in
//                //
//                //                })
//                //
//                //                request.responseString(completionHandler: { (response) in
//                //                    print(response)
//                //                })
//
//                request.responseJSON(completionHandler: { (dataResponse) in
//
//                    self.removeLoader()
//
//                    switch dataResponse.result {
//
//
//
//                    case .success(let responseValue):
//                        print("Response: \(responseValue)")
//
//                        if let error = self.getError(statusObject: responseValue as! NSDictionary)
//                        {
//                            responseHandler(nil, error)
//                        }
//                        else
//                        {
//                            responseHandler(responseValue as? Dictionary<String, Any> as NSDictionary?, nil)
//                        }
//
//                    case .failure(let error):
//                        print(error)
//                        responseHandler(nil, error as NSError?)
//                    }
//
//                })
//
//                break
//
//            case .failure(let error):
//
//                print(error)
//                break
//
//            }
//        }
//
//    }
//
//    func loadCookies() {
//        guard let cookieArray = UserDefaults.standard.array(forKey: "savedCookies") as? [[HTTPCookiePropertyKey: Any]] else { return }
//        for cookieProperties in cookieArray {
//            if let cookie = HTTPCookie(properties: cookieProperties) {
//                HTTPCookieStorage.shared.setCookie(cookie)
//            }
//        }
//    }
//
//
//    func saveCookies(response: DataResponse<Any>) {
//
//        if response.response != nil && response.response?.allHeaderFields != nil {
//            let headerFields = response.response?.allHeaderFields as! [String: String]
//            let url = response.response?.url
//            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url!)
//            var cookieArray = [[HTTPCookiePropertyKey: Any]]()
//            for cookie in cookies {
//                cookieArray.append(cookie.properties!)
//            }
//            if cookieArray.count == 0 {
//                return
//            }
//            UserDefaults.standard.set(cookieArray, forKey: "savedCookies")
//            UserDefaults.standard.synchronize()
//        }
//
//    }
//
//
//    //MARK:- Get Error object
//
//    func getError(statusObject : NSDictionary) -> NSError? {
//
//        if let code = statusObject["statuscode"]
//        {
//            if let statuscode = code as? Int ?? Int(code as? String ?? "")
//            {
//                if statuscode == 200 || statuscode == 201 || statuscode == 202 || statuscode == 401 {
//                    return nil
//                }
//
//                var messageString = statusObject["statusmessage"] as? String
//
//                if messageString == nil
//                {
//                    let dict = statusObject["meta"] as? NSDictionary
//                    messageString = dict?["statusmessage"] as? String
//                }
//
//                if messageString == nil
//                {
//                    messageString = statusObject["statusmessage"] as? String ?? "Unable to connect to server.Please try again after sometime."
//                }
//
//                if messageString!.uppercased().contains("THE OPERATION COULD")
//                {
//                    messageString = "Unable to connect to server. Please try again after some time."
//                }
//
//                let dict = NSDictionary(objects: [messageString!], forKeys: [NSLocalizedDescriptionKey as NSCopying])
//
//                return NSError(domain: "", code: statuscode, userInfo: dict as? [String : Any])
//            }
//        }
//
//        return nil
//    }
//
//    //    func addLoader() {
//    //
//    //        let appDelegate =  UIApplication.shared.delegate as? AppDelegate
//    ////        appDelegate?.window?.addSubview(viewForLoader)
//    //
//    //    }
//
//
//    //MARK:- Append Date with url to avoid cached call
//
//
//    func appendDatewithURl(url : String) -> String{
//
//
//        //        let datestring = "" //CodeSnippets.getStringFromLocaleNSDate(NSDate(), dateFormatString: "yyyy,MM,dd,HH,mm,ss")
//        //
//        //        if (url.range(of: )("?", options: NSString.CompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil) {
//        //            return "\(url)&dateLiad=\(datestring)"
//        //        }
//        return url // "\(url)?dateLiad=\(datestring)"
//    }
//
//    func isReachable() -> NSError? {
//
//        if Reachability.isConnectedToNetwork()
//        {
//            return nil
//
//        } else {
//
//            let dict = NSDictionary(objects: ["Internet connection failed"], forKeys: [NSLocalizedDescriptionKey as NSCopying])
//
//            print("Unable to connect internet")
//
//            return NSError(domain: "", code: 600, userInfo: dict as? [String : Any])
//
//        }
//    }
//
// }
//

