//
//  IZLandingApiCalls.swift
//  ShakerApp
//
//  Created by Nikita Gil on 23.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper


class IZRestLandingApiCalls  {
    
    //--------------------------------------------
    // MARK: - Video List
    //--------------------------------------------
    
    class func videoListCall(skipIds :[Int]?,
                             pageNumber :Int,
                             pageSize   :Int,
                             completed:(responseObject :IZLandingItemsModel?) -> (),
                             failed:(String -> ())  ) {
        
        var params = "?page[number]=\(pageNumber)&page[size]=\(pageSize)"      
        
        if let subCategoryID = skipIds as [Int]? {
            if subCategoryID.count > 0 {
                if let subCategoryIDString = IZHelpConverter.convertSubCategoriesArrayToString(subCategoryID) as String? {
                    params += "&skip_ids=\(subCategoryIDString)"
                }
            }
        }
        
        let url = base_url! + IZRestApiConstant.suffix_video + params
        
        let header : [String: String] = ["X-Device-UUID" : IZDeviceUDID.getUdid()!]
        
        print(IZHelpConverter.URL(url))
    
        defaultManager.request(Method.GET, IZHelpConverter.URL(url), parameters: nil, encoding: ParameterEncoding.URL, headers: header).validate().responseJSON { response in
            
            debugPrint(response)
            
            switch response.result {
            case .Success(let requestResult):
                
                print(requestResult)
                
                let swiftyJsonVar = JSON(response.result.value!)
                if let resultData = swiftyJsonVar["errors"].arrayObject {
                    let arrayResult = resultData as! [[String:AnyObject]]
                    if arrayResult.count == 1 {
                        if let title = arrayResult[0]["title"] as! String? {
                            failed(title)
                        }
                    }
                } else {
                    if let value = response.result.value {
                        print(value)
                        let responseObject = Mapper<IZLandingItemsModel>().map(value)
                        completed(responseObject: responseObject!)
                    }
                }
                
            case .Failure(let error):
                if let info = error.userInfo["NSLocalizedDescription"] as? String {
                    if info != "cancelled" {
                        failed(info)
                    } else {
                        failed("")
                    }
                } else if let info = error.userInfo["NSLocalizedFailureReason"] as? String {
                    if info != "cancelled" {
                        failed(info)
                    } else {
                        failed("")
                    }
                } else {
                    failed(error.description)
                }
            }
        }
    }
    
    //--------------------------------------------
    // MARK: - Random Video
    //--------------------------------------------
    
    class func randomVideoCall(completed:(responseObject :IZLandingModel?, responseStatus : Bool) -> (),
                              failed:(String -> ())  ) {      
        
        let header : [String: String] = ["X-Device-UUID" : IZDeviceUDID.getUdid()!]
        
        var categories = ""
        if IZSelectedFiltersManager.sharedInstance.checkedSubItems?.count > 0 {
            for item in IZSelectedFiltersManager.sharedInstance.checkedSubItems! {
                guard let categId = item.itemIndex else{
                    continue
                }
                if categId == IZSelectedFiltersManager.sharedInstance.checkedSubItems?.last?.itemIndex {
                    categories = categories + String(categId)
                } else {
                    categories = categories + String(categId) + ","
                }
            }
        }
    
        let params = "?filter[categories]=\(categories)"
        
        let url = base_url! + IZRestApiConstant.suffix_random_video + params
        
        print(IZHelpConverter.URL(url))
    
        defaultManager.request(Method.GET, IZHelpConverter.URL(url), parameters: nil, encoding: ParameterEncoding.URL, headers: header).validate().responseJSON { response in
            
            switch response.result {
            case .Success(let requestResult):
                
                print(requestResult)
                
                let swiftyJsonVar = JSON(response.result.value!)
                if let resultData = swiftyJsonVar["errors"].arrayObject {
                    let arrayResult = resultData as! [[String:AnyObject]]
                    if arrayResult.count == 1 {
                        if let title = arrayResult[0]["title"] as! String? {
                            failed(title)
                        }
                    }
                } else {
                    if let value = response.result.value {
                        let responseObject = Mapper<IZLandingRandomItemModel>().map(value)
                        
                        completed(responseObject: responseObject?.item!, responseStatus: true)
                    }
                }
                
            case .Failure(let error):
                if let info = error.userInfo["NSLocalizedDescription"] as? String {
                    if info != "cancelled" {
                        failed(info)
                    } else {
                        failed("")
                    }
                } else if let info = error.userInfo["NSLocalizedFailureReason"] as? String {
                    if info != "cancelled" {
                        failed(info)
                    } else {
                        failed("")
                    }
                } else {
                    failed(error.description)
                }
            }
        }
    }
    
    //--------------------------------------------
    // MARK: - Video filtered List
    //--------------------------------------------
    
    class func filteredVideoListCall(keyword : String?,
                             subCategoryId :[Int]?,
                             pageNumber :Int,
                             pageSize   :Int,
                             completed:(responseObject :IZLandingItemsModel?) -> (),
                             failed:(String -> ())  ) {
        
        var params = "?page[number]=\(pageNumber)&page[size]=\(pageSize)"
        
        
        if let keyWord = keyword as String? {
            params += "&filter[keyword]=\(keyWord)"
        }
        
        if let subCategoryID = subCategoryId as [Int]? {
            if subCategoryID.count > 0 {
                if let subCategoryIDString = IZHelpConverter.convertSubCategoriesArrayToString(subCategoryID) as String? {
                    params += "&filter[categories]=\(subCategoryIDString)"
                }
            }
        }
        
        let url = base_url! + IZRestApiConstant.suffix_filter_video + params
        
        let header : [String: String] = ["X-Device-UUID" : IZDeviceUDID.getUdid()!]
        
        print(IZHelpConverter.URL(url))
        
        defaultManager.request(Method.GET, IZHelpConverter.URL(url), parameters: nil, encoding: ParameterEncoding.URL, headers: header).validate().responseJSON { response in
            
            debugPrint(response)
            
            switch response.result {
            case .Success(let requestResult):
                
                print(requestResult)
                
                let swiftyJsonVar = JSON(response.result.value!)
                if let resultData = swiftyJsonVar["errors"].arrayObject {
                    let arrayResult = resultData as! [[String:AnyObject]]
                    if arrayResult.count == 1 {
                        if let title = arrayResult[0]["title"] as! String? {
                            failed(title)
                        }
                    }
                } else {
                    if let value = response.result.value {
                        print(value)
                        let responseObject = Mapper<IZLandingItemsModel>().map(value)
                        completed(responseObject: responseObject!)
                    }
                }
                
            case .Failure(let error):
                if let info = error.userInfo["NSLocalizedDescription"] as? String {
                    if info != "cancelled" {
                        failed(info)
                    } else {
                        failed("")
                    }
                } else if let info = error.userInfo["NSLocalizedFailureReason"] as? String {
                    if info != "cancelled" {
                        failed(info)
                    } else {
                        failed("")
                    }
                } else {
                    failed(error.description)
                }
            }
        }
    }
}


