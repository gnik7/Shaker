//
//  IZRestFilterApiCalls.swift
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



class IZRestFilterApiCalls {
    
    //--------------------------------------------
    // MARK: - Get Filter
    //--------------------------------------------
    
    class func filterCategoryCall(completed:(responseObject :IZFilterModel?, responseStatus:RestStatus) -> (),
                             failed:(String -> ())  ) {
        
        let header : [String: String] = ["X-Device-UUID" : IZDeviceUDID.getUdid()!]
        
        let url = base_url! + IZRestApiConstant.suffix_filter
                
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
                        let responseObject = Mapper<IZFilterModel>().map(value)
                        completed(responseObject: responseObject!, responseStatus: .Success(""))
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
