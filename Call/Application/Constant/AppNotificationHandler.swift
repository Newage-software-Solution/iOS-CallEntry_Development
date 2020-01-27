//
//  AppNitificationHandler.swift
//  MyCheerTribe
//
//  Created by hmspl on 24/07/17.
//  Copyright © 2017 hmspl. All rights reserved.
//

import UIKit

class AppNotificationHandler: NSObject {

    static var instance: AppNotificationHandler!
    
    class func sharedInstance() -> AppNotificationHandler {
        self.instance = (self.instance ?? AppNotificationHandler())
        return self.instance
    }
    
    func notificationReceived(notificationInfo : [AnyHashable: Any],viewController : UIViewController)
    {
//        if let aps = userInfo["aps"] as? NSDictionary
//        {
//            if let alert = aps["category"] as? NSString
//            {
//                if alert == "track"
//                {
//                    var storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let navigationController = self.window?.rootViewController as? UINavigationController
//                    let destinationController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
//                    navigationController?.pushViewController(destinationController!, animated: false)
//                    storyboard = UIStoryboard(name: "TrackAndTrace", bundle: nil)
//                    let destinationController2 = storyboard.instantiateViewController(withIdentifier: "TrackAndTraceSearchViewController") as? TrackAndTraceSearchViewController
//                    navigationController?.pushViewController(destinationController2!, animated: false)
//                }
//            }
//        }
    }

}
