//
//  IZVideoApiOperation.swift
//  ShakerApp
//
//  Created by Nikita Gil on 23.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation

class IZRestVideoApiOperation {
    
    //--------------------------------------------
    // MARK: - Single Video
    //--------------------------------------------
    
    class func shakeEventOperation(currentVideoId : Int,
                                       followUpId : Int?,
                                         duration : Double,
                                   completed:( responseObject : IZLandingModel,responseStatus:Bool) -> ()) {
        
        LoaderManager.sharedInstance.showView()
        
        IZRestVideoApiCalls.shakeEventCall(currentVideoId,
                                           followUpId: followUpId,
                                           duration: duration,
            completed: { (responseObject, responseStatus) in
            
                LoaderManager.sharedInstance.hideView()
                completed(responseObject: responseObject, responseStatus: responseStatus)
                
            }, failed: { (errorMessage) in
                LoaderManager.sharedInstance.hideView()
                if !errorMessage.isEmpty {
                    IZAlert.showAlertError(IZRouter.topViewController(), message: errorMessage, done: nil)
                }
        })
    }

    //--------------------------------------------
    // MARK: - Video from the same Author
    //--------------------------------------------
    
    class func videoFromTheSameAuthorOperation(userId : Int,
                                               currentPage :Int,
                                               pageSize :Int,
                                               skipId :Int,
                                               completed:( responseObject : IZLandingItemsModel?, response:Bool) -> ()) {
        
        LoaderManager.sharedInstance.showView()
        
        IZRestVideoApiCalls.videoFromTheSameAuthorCall(userId, currentPage: currentPage, pageSize: pageSize, skipId: skipId, completed: { (responseObject) in
            
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
    // MARK: - Similar videos
    //--------------------------------------------
    
    class func videoSimilarOperation(videoId : Int,
                                               currentPage :Int,
                                               pageSize :Int,
                                               completed:( responseObject : IZLandingItemsModel?, response:Bool) -> ()) {
        
        LoaderManager.sharedInstance.showView()
        
        IZRestVideoApiCalls.videoSimilarCall(videoId, currentPage: currentPage, pageSize: pageSize, completed: { (responseObject) in
            
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

