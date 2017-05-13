//
//  IZReachabilityManager.swift
//  ShakerApp
//
//  Created by Nikita Gil on 14.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import Alamofire

class IZReachabilityManager: NSObject {
    
    let networkManager = NetworkReachabilityManager()!
    
    class func sharedManager() -> IZReachabilityManager {
        struct wrapper {
            static var sharedInstance: IZReachabilityManager? = nil
            static var token : dispatch_once_t = 0
        }
        
        dispatch_once(&wrapper.token, {
            wrapper.sharedInstance = IZReachabilityManager()
        })
        return wrapper.sharedInstance!
    }
    
    func checkInternetConnection() -> Bool {
        
        switch networkManager.networkReachabilityStatus {
        case NetworkReachabilityManager.NetworkReachabilityStatus.NotReachable,
             NetworkReachabilityManager.NetworkReachabilityStatus.Unknown:
            return false
        default: return true
        }
    }
}

let NetworkStatusChanged = "NetworkStatusChanged"
let NetworkStatusChangedReachable = "NetworkStatusChangedReachable"
let NetworkStatusChangedNotReachable = "NetworkStatusChangedNotReachable"

class IZReachabilityStatusManager {
    
    let manager = NetworkReachabilityManager(host: "www.apple.com")
    
    init(){
        
        manager?.listener = { status in
            print("Network Status Changed: \(status)")
            var statusChanged = ""
            switch status {
            case .NotReachable:
                print("Not Reachable")
                statusChanged = NetworkStatusChangedNotReachable
            //Show error state
            case .Reachable(_), .Unknown:
                print("Reachable")
                statusChanged = NetworkStatusChangedReachable
            }
          let dict : Dictionary<String, String> = ["Info" :  statusChanged]
          NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: NetworkStatusChanged, object: dict))
        }
        
        manager?.startListening()
        
    }
    
    
}

