//
//  IZSharing.swift
//  ShakerApp
//
//  Created by Nikita Gil on 21.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit


struct IZSharing {
    
    //*****************************************************************
    // MARK: - Sharing
    //*****************************************************************
    
    static func showSharing(controller :UIViewController, shareContent:String?, action: (() -> ())?){
        
       let activityViewController = UIActivityViewController(activityItems: [shareContent! as NSString], applicationActivities: nil)
        
        let popOver = activityViewController.popoverPresentationController
        popOver?.sourceView  = controller.view
        popOver?.sourceRect = controller.view.bounds
        popOver?.permittedArrowDirections = UIPopoverArrowDirection.Any
        
        if let vc = controller as? IZSingleVideoViewController{
            let sender = vc.shareButton
            activityViewController.popoverPresentationController?.sourceView = sender
        }
        
        controller.presentViewController(activityViewController, animated: true, completion: nil)
  }
}
