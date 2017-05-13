//
//  IZRestFavoriteApiCalls.swift
//  ShakerApp
//
//  Created by Nikita Gil on 06.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON
import ObjectMapper

class IZRestFavoriteApiCalls {
    
    //--------------------------------------------
    // MARK: - Favorite List
    //--------------------------------------------
    
    class func favoriteVideoListCall(pageNumber :Int,
                                     pageSize   :Int,
                                     completed:(responseObject :IZLandingItemsModel?) -> (),
                                     failed:(String -> ())  ) {
        
        let header : [String: String] = ["X-Device-UUID" : IZDeviceUDID.getUdid()!]
        
        let params = "?page[number]=\(pageNumber)&page[size]=\(pageSize)"
        
        let url = base_url! + IZRestApiConstant.suffix_favorite_video + params
        
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
    // MARK: - Add to Favorite
    //--------------------------------------------
    
    class func addToFavoriteVideoCall(videoId :Int,
                                     completed:(responseStatus :RestStatus) -> (),
                                     failed:(String -> ())  ) {
        
        let header : [String: String] = ["X-Device-UUID" : IZDeviceUDID.getUdid()!]
        let params = "\(videoId)"
        
        let url = base_url! + IZRestApiConstant.suffix_add_favorite_video + params
        
        print(IZHelpConverter.URL(url))

        defaultManager.request(Method.POST, IZHelpConverter.URL(url), parameters: nil, encoding: ParameterEncoding.URL, headers: header).validate()
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(response.result.value)")
                if let httpError = response.result.error {
                    let statusCode = httpError.code
                    print(statusCode)
                    let strError = httpError.localizedDescription
                    failed(strError)
                } else { //no errors
                    let statusCode = (response.response?.statusCode)!
                    if String(statusCode) == IZRestApiConstant.statusCode201 {
                       completed(responseStatus: RestStatus.Success(""))
                    }
                    print(statusCode)                    
                }
            }
    }
    
    //--------------------------------------------
    // MARK: - Remove from Favorite
    //--------------------------------------------
    
    class func removeFromFavoriteVideoCall(videoId :Int,
                                      completed:(responseStatus :RestStatus) -> (),
                                      failed:(String -> ())  ) {
        
        let header : [String: String] = ["X-Device-UUID" : IZDeviceUDID.getUdid()!]
        let params = "\(videoId)"
        
        let url = base_url! + IZRestApiConstant.suffix_add_favorite_video + params
        
        print(IZHelpConverter.URL(url))

        defaultManager.request(Method.DELETE, IZHelpConverter.URL(url), parameters: nil, encoding: ParameterEncoding.URL, headers: header).validate()
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(response.result.value)")
                if let httpError = response.result.error {
                    let statusCode = httpError.code
                    print(statusCode)
                    let strError = httpError.localizedDescription
                    failed(strError)
                    completed(responseStatus: RestStatus.Failure)
                } else { //no errors
                    let statusCode = (response.response?.statusCode)!
                    if String(statusCode) == IZRestApiConstant.statusCode204 {
                        completed(responseStatus: RestStatus.Success(""))
                    }
                    print(statusCode)
                }
        }
    }
}