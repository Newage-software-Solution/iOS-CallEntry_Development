//
//  CodeSnippets.swift
//  BrothersGas Driver
//
//  Created by Susena on 23/01/17.
//  Copyright © 2017 Hakunamatata solution (P) Ltd. All rights reserved.
//

import UIKit
import CoreLocation

class CodeSnippets: NSObject {
    
    class func convertDateStringToDispayDateString(dateString : String, showTodayYesterdayFormat: Bool, dateFormat: String) -> String {
        
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "dd/MM/yyyy" //"yyyy-MM-dd'T'HH:mm:ss Z"
        
        let date = dateFormatter.date(from: dateString)
        
        if date == nil
        {
            return ""
        }
        
        if showTodayYesterdayFormat
        {
            let dateString = relativeDateStringForDate(date: date!)

            if dateString != ""
            {
                return dateString
            }
            
        }
        
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: date!)
    }

    private class func relativeDateStringForDate(date : Date) -> String {
        
        let todayDate = Date()
        
        let components = Calendar.current.dateComponents([.hour, .day, .month, .year, .weekOfYear], from: date)
        let componentsCurrentDate = Calendar.current.dateComponents([.hour, .day, .month, .year, .weekOfYear], from: todayDate)
        
        if (components.day! + 1) == componentsCurrentDate.day! && components.month! == componentsCurrentDate.month! && components.year! == componentsCurrentDate.year!
        {
            return "YESTERDAY"
        }
        else  if components.day == componentsCurrentDate.day && components.month == componentsCurrentDate.month && components.year == componentsCurrentDate.year
        {
            return "TODAY"
        }
        else
        {
            return ""
        }
    }
    
    class func getImageFromDocumentDirectory(imageName: String) -> UIImage {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(imageName).path
        
        if FileManager.default.fileExists(atPath: fileURL)
        {
            return UIImage(contentsOfFile: fileURL)!
        }
        else
        {
            return UIImage(named: imageName)!
        }
    }
    
    //MARK:- Resize image
    class func squareImageWithImage(image : UIImage, newSize: CGSize) -> UIImage? {
        //        var point = customOverlayView.imgViewCapturedImage.frame.origin.y + 60
        
        let gapX : CGFloat = 0 //(UIScreen.mainScreen().bounds.size.width - newSize.width) / 2
        let gapY : CGFloat = 0 //(UIScreen.mainScreen().bounds.size.height - newSize.height) / 2
        //        if(UIScreen.mainScreen().bounds.size.height < 500 ){
        //            gapY -= 10;
        //        }
        // image size = 1936 X 2592 new size = 294 X 294
        var ratio : CGFloat = 0
        var delta : CGFloat = 0
        var offset = CGPoint.zero
        let sz = CGSize(width: newSize.width, height: newSize.width) //294 X 294
        
        if (image.size.width > image.size.height)
        {
            ratio = newSize.width / image.size.width
            delta = (ratio * image.size.width - ratio * image.size.height)
            offset = CGPoint(x: delta/2 + gapX, y: gapY)
        }
        else
        {
            ratio = newSize.width / image.size.height // 0.1134
            delta = (ratio*image.size.height - ratio*image.size.width) //74.41
            offset = CGPoint(x: gapX, y: gapY) // 0,37.0
        }
        
        var clipRect = CGRect(x: -offset.x, y: -offset.y,
                              width: (ratio * image.size.width) + delta+(gapX * 2),
                              height: (ratio * image.size.height) + delta+60)   //0,0,100,100
        
        if(UIScreen.main.bounds.size.height < 500 )
        {
            clipRect.size.height += 60;
        }
        
        
        if (UIScreen.main.responds(to: Selector("scale")))
        {
            UIGraphicsBeginImageContextWithOptions(sz, true, 0.0)
        }
        else
        {
            UIGraphicsBeginImageContext(sz)
        }
        
        UIRectClip(clipRect)
        image.draw(in: clipRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    

    
    class func convertServerDateStringToDispayDateString(dateString : String, dateFormat : String) -> String {
        
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        let date = dateFormatter.date(from: dateString)
        
        if date == nil
        {
            return ""
        }
        
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: date!)
    }

    class func getEstimatedBubbleViewSize(maxWidth: CGFloat, text: String) -> CGRect {
        
        let size = CGSize(width: maxWidth, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let context = NSStringDrawingContext()
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont(name: AvenirFont.avenirRoman.rawValue, size: 14.0)!], context: context)
        
        return CGRect(x: 0, y: 0, width: estimatedFrame.width + 2.0, height: estimatedFrame.height + 2.0)
    }

    class func getStringFromLocaleDate(date : Date, dateFormatString : String) -> String? {
        
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = dateFormatString
        let gmt = NSTimeZone.default
        dateFormatter.timeZone = gmt
        
        return dateFormatter.string(from: date)
    }
    
    //Super Script at the end of the main string
    class func stringFromSuperString(superScriptString: String, mainString: String) -> NSMutableAttributedString {
        let appendedString = mainString + superScriptString
        let mainStringCount = mainString.characters.count
        let superStringCount = superScriptString.characters.count
        let font:UIFont? = UIFont(name: "Helvetica", size:12)
        let fontSuper:UIFont? = UIFont(name: "Helvetica", size:10)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: appendedString, attributes: [NSFontAttributeName:font!])
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:10], range: NSRange(location:mainStringCount,length:superStringCount))
        return attString
    }
    
    // Date Formate change  From 2015-11-18T13:23:45.035Z to Dec 12 2015 - 12:59 pm
    // yyyy-MM-dd'T'HH:mm:ss.SSSZ     to   mmm dd yyyy - hh:mm a
    class func DateFormateString(datestring: String, CurrentFormat curtFormat: String, ConvertFormat convertFormat: String) -> String
    {
        
        let parsingFormatter: DateFormatter = DateFormatter()
        parsingFormatter.dateFormat = curtFormat
        let date: NSDate = parsingFormatter.date(from: datestring)! as NSDate
        
        let displayingFormatter: DateFormatter = DateFormatter()
        displayingFormatter.dateFormat = convertFormat
        let display: String = displayingFormatter.string(from: date as Date)
        
        return display
    }
    
//    // email validation
//    class func isValidEmail(emailAddress : String) -> Bool
//    {
//        let regex = try? NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .caseInsensitive)
//        return regex?.firstMatch(in: emailAddress, options: [], range: NSMakeRange(0, emailAddress.characters.count)) != nil
//    }
//    //mobileNumber Validation
//    class func isValidMobileNumber(mobileNo : String) -> Bool
//    {
//        if mobileNo.characters.count >= 8 && mobileNo.characters.count <= 9
//        {
//            return true
//        }
//        return false
//    }
    
    //OTP Validation
    class func isValidOTP(otp : String) -> Bool
    {
        print(otp.characters.count)
        if otp.characters.count == 6
        {
            return true
        }
        return false
    }
    
    //Create superscript from the given String
    class func getAttributedStringWithSuperString(superString: String, fromString : String, size : CGFloat) -> NSAttributedString {
        let range = NSString(string: fromString).range(of: superString)
        let attributedString = NSMutableAttributedString(string: fromString)
        attributedString.setAttributes([NSFontAttributeName : UIFont(name: "Helvetica", size: size)!, NSBaselineOffsetAttributeName : 6], range: range)
        return attributedString
    }
    
    //Convert String to CLLocationCoordinate2D
    class func stringToCLLocationCoordinate2D(strCoordinates: String) -> CLLocationCoordinate2D {
        let latLong = (strCoordinates.replacingOccurrences(of: " ", with: "")).components(separatedBy: ",")
        let lat = Double(latLong.first!)
        let long = Double(latLong.last!)
        let location = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        return location
    }
    
    
    // Get Location Coordinate address
    
    func getAddressLocation(location : CLLocation, Completion Handler : @escaping (String?,String, NSError?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placeMark, error) -> Void in
            if error == nil && placeMark!.count > 0 {
                let placemark = placeMark?.last
                var address = ""
                let thoroughfare = placemark?.thoroughfare
                let locality = placemark?.locality
                let sublocality = placemark?.subLocality
                let adminstrativeArea = placemark?.administrativeArea
                let country = placemark?.country
                if thoroughfare != nil {
                    address += "\(thoroughfare!), "
                }
                if sublocality != nil {
                    address += "\(sublocality!), "
                }
                if locality != nil {
                    address += "\(locality!), "
                }
                
                if adminstrativeArea != nil {
                    address += "\(adminstrativeArea!), "
                }
                if country != nil {
                    address += "\(country!)"
                }
                print(address)
                Handler(address , sublocality ?? locality ?? "",error as NSError?)
            } else {
                
                Handler("","" ,error as NSError?)
            }
            
        })
    }
    
    // Get Lat & Long from given Address
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    
    func getLatLongFromAddress( address : String, responseHandler : @escaping (Double, Double) -> Void){
        
        var addressTemp = removeSpecialCharsFromString(text: address)
        
        addressTemp = addressTemp.replacingOccurrences(of: " ", with: "%20")
        let urlLocation = "http://maps.google.com/maps/api/geocode/json?sensor=false&address=\(addressTemp)"
        
        if  NSURL(string: urlLocation) != nil {
            WebServiceHandler().initiateServiceCall(httpMethod: .get, url: urlLocation, body: nil, Completion: { (response, err) in
                if response != nil{
                    
                    if let results = response?["results"] as? NSArray {
                        if results.count > 0 {
                            if let data = results[0] as? NSDictionary  {
                                let geometry = data["geometry"] as? NSDictionary
                                let location = geometry!["location"] as? NSDictionary
                                let latitude = location!["lat"] as? Double
                                let longitude = location!["lng"] as? Double
                                responseHandler(latitude!, longitude!)
                            } else {
                                responseHandler(0, 0)
                            }
                        } else {
                            responseHandler(0,0)
                        }
                    }else {
                        responseHandler(0, 0)
                    }
                } else {
                    responseHandler(0, 0)
                }
            })
            
        }else {
            responseHandler(0, 0)
        }
    }
    
/*
    class func getImageDownload(key : NSString, dimensions : Int, sourceType : String) -> String {
        
        var size = "50x50"
        if dimensions == 1 {
            
            size = "50x50"
        } else if dimensions == 2 {
            
            size = "250x250"
        } else if dimensions == 3 {
            
            size = "450x640"
        }
        
        return APIConstants().getFileDownloadURL() + key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! +  "?authorization=" + UserDefaults.standard.string(forKey: "authToken")!.addingPercentEncoding(withAllowedCharacters: .allowedURLCharacterSet)! + "&sourceType=\(sourceType)" + "&dimension=\(size)"
    }
    
    class func getFileDownload(Key : String,sourceType : String) -> String {
        //        print(APIConstants().getFileDownloadURL() + Key.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)! + "?authorization=" + NSUserDefaults.standardUserDefaults().stringForKey("authToken")!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! + "&sourceType=\(sourceType)")
        return APIConstants().getFileDownloadURL() + Key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + "?authorization=" + UserDefaults.standard.string(forKey: "authToken")!.addingPercentEncoding(withAllowedCharacters: .allowedURLCharacterSet)! + "&sourceType=\(sourceType)"
    }*/
}


extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }

//    func isNumber() -> Bool
//    {
//        let regex = try? NSRegularExpression(pattern: "^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$", options: .caseInsensitive)
//        return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
//    }
    
    func chopPrefix(_ count: Int = 1) -> String {
        return substring(from: index(startIndex, offsetBy: count))
    }
    
}



