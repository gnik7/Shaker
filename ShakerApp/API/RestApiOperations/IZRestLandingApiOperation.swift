//
//  IZLandingApiOperation.swift
//  ShakerApp
//
//  Created by Nikita Gil on 23.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation

class IZRestLandingApiOperation {

//--------------------------------------------
// MARK: - Video List
//--------------------------------------------

    class func videoListCall(skipIds :[Int]?,
                             pageNumber :Int,
                             pageSize   :Int,
                             completed:(responseObject :IZLandingItemsModel?, response:Bool) -> ()) {
        
        LoaderManager.sharedInstance.showView()
        IZRestLandingApiCalls.videoListCall(skipIds, pageNumber: pageNumber, pageSize: pageSize, completed: { (responseObject) in
            
            LoaderManager.sharedInstance.hideView()
            completed(responseObject: responseObject, response: true)
            
            }, failed: { (errorMessage) in
                
                if !errorMessage.isEmpty {
                    IZAlert.showAlertError(IZRouter.topViewController(), message: errorMessage, done: nil)
                }
                LoaderManager.sharedInstance.hideView()
                completed(responseObject: nil, response: false)
        })
    }
    
    //--------------------------------------------
    // MARK: - Random Video
    //--------------------------------------------
    
    class func randomVideoOperation(completed:(responseObject :IZLandingModel?, response:Bool) -> ()) {
        
        LoaderManager.sharedInstance.showView()
        
        IZRestLandingApiCalls.randomVideoCall({ (responseObject, responseStatus) in
            
            LoaderManager.sharedInstance.hideView()
            completed(responseObject: responseObject, response: true)
            
            }, failed: { (errorMessage) in
                
                if !errorMessage.isEmpty {
                    IZAlert.showAlertError(IZRouter.topViewController(), message: errorMessage, done: nil)
                }
                LoaderManager.sharedInstance.hideView()
                completed(responseObject: nil, response: false)
        })        
    }

    //--------------------------------------------
    // MARK: - Video filtered List
    //--------------------------------------------
    
    class func filteredVideoListOperation(keyword: String?,
                                        filter :[Int]?,
                                        pageNumber :Int,
                                        pageSize   :Int,
                                        completed:(responseObject :IZLandingItemsModel?, response:Bool) -> ()) {
        
        LoaderManager.sharedInstance.showView()
        IZRestLandingApiCalls.filteredVideoListCall(keyword, subCategoryId: filter, pageNumber: pageNumber, pageSize: pageSize, completed: { (responseObject) in
            
            LoaderManager.sharedInstance.hideView()
            completed(responseObject: responseObject, response: true)
            
            }, failed: { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlert.showAlertError(IZRouter.topViewController(), message: errorMessage, done: nil)
                }
                LoaderManager.sharedInstance.hideView()
                completed(responseObject: nil, response: false)
        })
    }
}
