//
//  IZLoaderManager.swift
//  ShakerApp
//
//  Created by Nikita Gil on 21.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class LoaderManager {
    
    var loader : IZLoaderView?
    
    // MARK: - SINGLETON
    class var sharedInstance: LoaderManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: LoaderManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = LoaderManager()
        }
        return Static.instance!
    }
    
    // MARK: - Functions for loader
    func showView() {
        
        dispatch_async(dispatch_get_main_queue()) {
            if UIApplication.sharedApplication().keyWindow != nil {
                if self.loader == nil {
                    self.loader = IZLoaderView.loadFromXib()
                    self.loader?.loadView()
                }
                
                self.loader?.showView()
            }
        }
    }
    
    func hideView() {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.loader?.hideView()
        }
    }

    
}
