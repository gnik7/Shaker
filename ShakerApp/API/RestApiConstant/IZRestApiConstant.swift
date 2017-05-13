//
//  IZRestApiConstant.swift
//  ShakerApp
//
//  Created by Nikita Gil on 18.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation

/**
 Rest Status
 - Success: result success
 - Failure: result failure
 */

enum RestStatus {
    case Success(String)
    case Failure
}


// Go to info.plist
let base_url = NSDictionary(dictionary: NSBundle.mainBundle().infoDictionary!).objectForKey("API_Url") as? String
let site_url = NSDictionary(dictionary: NSBundle.mainBundle().infoDictionary!).objectForKey("Site_Url") as? String

struct IZRestApiConstant {
    
    //Status Code 200
    static let statusCode200 = "200"
    static let statusCode201 = "201"
    static let statusCode204 = "204"  // delete
   
    //video
    static let suffix_video                 = "video"
    static let suffix_filter_video          = "video/filter"
    static let suffix_favorite_video        = "video/favorites"
    static let suffix_add_favorite_video    = "video/favorites/"
    static let suffix_random_video          = "video/random"
    static let suffix_user_video            = "video/university/"
    
    
    //statistic
    static let suffix_statistic    = "statistic"
    
    //filter
    static let suffix_filter        = "category"
    
    
    static let kTestUrl   = "http://walterebert.com/playground/video/hls/sintel-trailer.m3u8"
}
