//
//  ReachabilityManager.swift
//  ReachabilityLearn
//
//  Created by hmspl on 23/06/17.
//  Copyright © 2017 hmspl. All rights reserved.
//

import UIKit
//import ReachabilitySwift // 1. Importing the Library - need if use Pod

/// Protocol for listenig network status change
public protocol NetworkStatusDelegate : class {
    func networkStatusDidChange(status: Reachability.NetworkStatus)
}

class ReachabilityManager: NSObject {
    
    static  let shared = ReachabilityManager()  // 2. Shared instance
    
    // 3. Boolean to track network reachability
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .notReachable
    }
    
    // 4. Tracks current NetworkStatus (notReachable, reachableViaWiFi, reachableViaWWAN)
    var reachabilityStatus: Reachability.NetworkStatus = .notReachable
    
    // 5. Reachability instance for Network status monitoring
    let reachability = Reachability()!
    
    // 6. Array of delegates which are interested to listen to network status change
    var delegates = [NetworkStatusDelegate]()
    
    //MARK:- Monitoring the network Status
    
    /// Starts monitoring the network availability status
    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    /// Stops monitoring the network availability status
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: ReachabilityChangedNotification,
                                                  object: reachability)
    }
    
    
    //MARK:- Notification post response
    
    /// Called whenever there is a change in NetworkReachibility Status
    ///
    /// — parameter notification: Notification with the Reachability instance
    func reachabilityChanged(notification: Notification) {
       
        let reachability = notification.object as! Reachability
        switch reachability.currentReachabilityStatus {
        case .notReachable:
            debugPrint("Network became unreachable")
        case .reachableViaWiFi:
            debugPrint("Network reachable through WiFi")
        case .reachableViaWWAN:
            debugPrint("Network reachable through Cellular Data")
        }
        
        // Sending message to each of the delegates
        for delegate in delegates
        {
            delegate.networkStatusDidChange(status: reachability.currentReachabilityStatus)
        }

    }
    
    //MARK:- Validate the delegates

    /// Adds a new listener to the listeners array
    ///
    /// - parameter delegate: a new listener
    func addDelegate(delegate: NetworkStatusDelegate) {

//       Business Case 1.0 - Delegating the network status to more than one controller at a time
        delegates.append(delegate)


    }
    
    /// Removes a listener from listeners array
    ///
    /// - parameter delegate: the listener which is to be removed
    func removeDelegate(delegate: NetworkStatusDelegate) {
        
//       Business Case 1.0 - To delegate the network status to more than one controller at a time
        delegates = delegates.filter{ $0 !== delegate}
        

    }
}
