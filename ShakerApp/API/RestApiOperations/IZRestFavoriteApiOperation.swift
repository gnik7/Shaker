//
//  IZRestFavoriteApiOperation.swift
//  ShakerApp
//
//  Created by Nikita Gil on 06.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation

class IZRestFavoriteApiOperation {
    
    //--------------------------------------------
    // MARK: - Video List
    //--------------------------------------------
    
    class func favoriteVideoListCall(pageNumber :Int,
                                     pageSize   :Int,
                                     completed:(responseObject :IZLandingItemsModel?, response:Bool) -> ()) {
        
        LoaderManager.sharedInstance.showView()
        
        IZRestFavoriteApiCalls.favoriteVideoListCall(pageNumber, pageSize: pageSize, completed: { (responseObject) in
            
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
    // MARK: - Add to Favorite
    //--------------------------------------------
    
    class func addToFavoriteVideoListCall(videoId :Int,
                                     completed:(response:Bool) -> ()) {
        
        LoaderManager.sharedInstance.showView()
        
        IZRestFavoriteApiCalls.addToFavoriteVideoCall(videoId, completed: { (responseObject) in
            
                LoaderManager.sharedInstance.hideView()
                completed(response: true)
            
            }, failed: { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlert.showAlertError(IZRouter.topViewController(), message: errorMessage, done: nil)
                }
                LoaderManager.sharedInstance.hideView()
                completed( response: false)
        })
    }
    
    //--------------------------------------------
    // MARK: - Delete from Favorite
    //--------------------------------------------
    
    class func deleteFromFavoriteVideoListCall(videoId :Int,
                                          completed:(response:Bool) -> ()) {
        
        LoaderManager.sharedInstance.showView()
        
        IZRestFavoriteApiCalls.removeFromFavoriteVideoCall(videoId, completed: { (responseStatus) in
            
            LoaderManager.sharedInstance.hideView()
            completed(response: true)
            
            }, failed: { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlert.showAlertError(IZRouter.topViewController(), message: errorMessage, done: nil)
                }
                LoaderManager.sharedInstance.hideView()
                completed( response: false)
        })        
    }
}