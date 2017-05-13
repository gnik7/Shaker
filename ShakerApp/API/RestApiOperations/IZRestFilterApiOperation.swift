//
//  IZRestFilterApiOperation.swift
//  ShakerApp
//
//  Created by Nikita Gil on 06.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation

class IZRestFilterApiOperation {
    
    //--------------------------------------------
    // MARK: - Statistic
    //--------------------------------------------

    class func filterCategoryOperation(completed:(responseObj: IZFilterModel?) -> (),
                                        failed:(String -> ()) ) {
        
        LoaderManager.sharedInstance.showView()
        
        IZRestFilterApiCalls.filterCategoryCall({ (responseObject, responseStatus) in
            
            LoaderManager.sharedInstance.hideView()
            
            if let obj = responseObject as IZFilterModel? {
                completed(responseObj: obj)
            }
            
            }, failed: { (errorMessage) in
                if !errorMessage.isEmpty {
                    IZAlert.showAlertError(IZRouter.topViewController(), message: errorMessage, done: nil)
                }
                LoaderManager.sharedInstance.hideView()
        })
    }
}