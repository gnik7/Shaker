//
//  IZLoaderView.swift
//  ShakerApp
//
//  Created by Nikita Gil on 21.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class  IZLoaderView :UIView {
    
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    /**
     Get IZLoaderView from xib
     
     - parameter bundle: bundle for search. Default nil
     
     - returns: object IZLoaderView
     */
    class func loadFromXib(bundle : NSBundle? = nil) -> IZLoaderView? {
        return UINib(
            nibName: "IZLoaderView",
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? IZLoaderView
    }
    
    func configureView() {
        self.centerView.layer.cornerRadius = 10.0
        self.centerView.clipsToBounds = true
        
        self.activityIndicatorView.startAnimating()
    }
    
    func loadView() {
        
        if let windowView = UIApplication.sharedApplication().keyWindow {
            windowView.addSubview(self)
        }
    }
    
    func bringToFront() {
        let sizeFrame: CGFloat = 100.0
        let frameX = UIScreen.mainScreen().bounds.width / 2.0 - sizeFrame / 2.0
        let frameY = UIScreen.mainScreen().bounds.height / 2.0 - sizeFrame / 2.0
        
        self.frame = CGRect(x: frameX, y: frameY, width: sizeFrame, height: sizeFrame)
        
        self.superview?.bringSubviewToFront(self)
    }
    
    func showView() {
        
        self.bringToFront()
        self.configureView()
        
        self.alpha = 0.0
        self.hidden = false
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            self.alpha = 1.0
            }, completion: nil)
    }
    
    func hideView() {
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.alpha = 0.0
            }, completion: { (Bool) -> Void in
                self.hidden = true
        })
    }

}
