//
//  IZRestBaseApiCall.swift
//  ShakerApp
//
//  Created by Nikita Gil on 8/11/16.
//  Copyright © 2016 Inteza. All rights reserved.
//


import Alamofire
import AlamofireObjectMapper



let defaultManager: Alamofire.Manager = {
    let serverTrustPolicies: [String: ServerTrustPolicy] = [
        "api.study-shaker.de": .DisableEvaluation
    ]
    
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    configuration.HTTPAdditionalHeaders = [
        "Accept": "application/x.shakerapp.v1+json"]
    
    return Alamofire.Manager(
        configuration: configuration,
        serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
    )
}()
