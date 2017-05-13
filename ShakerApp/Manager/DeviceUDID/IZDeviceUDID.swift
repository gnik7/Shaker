//
//  IZDeviceUDID.swift
//  ShakerApp
//
//  Created by Nikita Gil on 23.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//


import UIKit

let kApplicationDeviceUDID = "ApplicationDeviceUDID"

class IZDeviceUDID  {
    
    private class func udidDevise() -> String {
        return (UIDevice.currentDevice().identifierForVendor?.UUIDString)!
    }
    
    class func setUdid() {
        let udid = IZDeviceUDID.udidDevise()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(udid, forKey: kApplicationDeviceUDID)
        userDefaults.synchronize()
    }
    
    class func getUdid() -> String? {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        guard let udid = userDefaults.objectForKey(kApplicationDeviceUDID) as! String? else {
            return nil
        }
        
       return udid
    }
}