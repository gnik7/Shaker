//
//  IZVideoApiCalls.swift
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



class IZRestVideoApiCalls {

    //--------------------------------------------
    // MARK: - Video from the same Author
    //--------------------------------------------
 
    class func videoFromTheSameAuthorCall(userId : Int,
                                          currentPage :Int,
                                          pageSize :Int,
                                          skipId :Int,
                                          completed:( responseObject : IZLandingItemsModel) -> (),
                                          failed:(String -> ()) ) {
        
        let params = "\(userId)?page[number]=\(currentPage)&page[size]=\(pageSize)&skip_ids=\(skipId)"
        
        let url = base_url! + IZRestApiConstant.suffix_user_video + params
        
        let header : [String: String] = ["X-Device-UUID" : IZDeviceUDID.getUdid()!]
        
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
    // MARK: - Shake Event
    //--------------------------------------------
    
    class func shakeEventCall(currentVideoId : Int,
                                  followUpId :Int?,
                                    duration : Double,
                              completed:( responseObject : IZLandingModel,responseStatus:Bool) -> (),
                                   failed:(String -> ()) ) {
        
        let url = base_url! + IZRestApiConstant.suffix_video + "/\(currentVideoId)"
        
        let header : [String: String] = ["X-Device-UUID" : IZDeviceUDID.getUdid()!]
        
        var followUPID = ""
        if let fId = followUpId as Int? {
            followUPID = "\(fId)"
            //followUPID = "followup_id=\(fId)"
        }
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
        
        let categoryDictionary: [String:String] = ["categories": categories]
        
        //?length=\(duration)" + followUPID + "&filter=\(categoryDictionary)"
        
        print(IZHelpConverter.URL(url))
        
        let params:[String:AnyObject] = ["length": duration, "followup_id": followUPID,  "filter": categoryDictionary ]
        
        defaultManager.request(Method.POST, IZHelpConverter.URL(url), parameters: params, encoding: ParameterEncoding.URL, headers: header).validate().responseJSON { response in
            
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
                        let responseObject = Mapper<IZLandingRandomItemModel>().map(value)
                        if let item = responseObject?.item as IZLandingModel? {
                            completed(responseObject: item, responseStatus: true)
                        }
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
    // MARK: - Similar videos
    //--------------------------------------------
    
    class func videoSimilarCall(videoId : Int,
                                          currentPage :Int,
                                          pageSize :Int,
                                          completed:( responseObject : IZLandingItemsModel) -> (),
                                          failed:(String -> ()) ) {
        
        let params =  "/" + "\(videoId)/similar?page[number]=\(currentPage)&page[size]=\(pageSize)"
       
        let url = base_url! + IZRestApiConstant.suffix_video + params
        
        let header : [String: String] = ["X-Device-UUID" : IZDeviceUDID.getUdid()!]
        
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
