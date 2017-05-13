//
//  IZAlert.swift
//  ShakerApp
//
//  Created by Nikita Gil on 14.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

enum AlertTitle : String {

    case TitleCommon = "Achtung"
    case Error = "Fehler"

}

enum AlertText : String {
    
    case TitleNoInternet = "Achtung"
    case NoInternetMessage = "Aber das Internet Tsonnetstion. Bitte Verbinden Grid devivise Vith Internet."
    case DeleteFavoriteMessage = "Bist du sicher, dass du das Video von deinen Favoriten löschen möchtest ?"
    case NoURLMessage = "Sorry, aber Thera IP URL!"
    case NoMoreVideos = "Es sind keine weiteren Videos verfügbar"
    case RequestTimeOut = "Die Zeitüberschreitung der Anforderung"
    
    //case NoMoreVideos = "Es sind keine weiteren Videos"
}

struct IZAlert {
    
    //*****************************************************************
    // MARK: - Simple
    //*****************************************************************
    
    static func showAlert(controller :UIViewController, title :String, message:String?, action: (() -> ())?){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Cancel,
            handler: { act in
                if let action = action {
                    action()
                }
        }))
        
        let popOver = alert.popoverPresentationController
        popOver?.sourceView  = controller.view
        popOver?.sourceRect = controller.view.bounds
        popOver?.permittedArrowDirections = UIPopoverArrowDirection.Any
        
        controller.presentViewController(alert, animated: true, completion: nil)
    }
    
    //*****************************************************************
    // MARK: - Error Alert
    //*****************************************************************
    
    static func showAlertError(controller :UIViewController?, message:String?, done: (() -> ())?){
        
        let alertController = UIAlertController(title: AlertTitle.Error.rawValue, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            if let done = done {
                done()
            }
        }
        alertController.addAction(OKAction)
        
        if controller != nil {
            let popOver = alertController.popoverPresentationController
            popOver?.sourceView  = controller!.view
            popOver?.sourceRect = controller!.view.bounds
            popOver?.permittedArrowDirections = UIPopoverArrowDirection.Any
            
            controller!.presentViewController(alertController, animated: true) {
            }
        }
    }
    
    //*****************************************************************
    // MARK: - Sharing Alert
    //*****************************************************************
    
    
    static func showAlert(controller :UIViewController, title :String, message:String?, done: (() -> ())?, cancel: (() -> ())?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .Cancel) { (action) in
            if let cancel = cancel {
                cancel()
            }
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            if let done = done {
                done()
            }
        }
        alertController.addAction(OKAction)
        
        let popOver = alertController.popoverPresentationController
        popOver?.sourceView  = controller.view
        popOver?.sourceRect = controller.view.bounds
        popOver?.permittedArrowDirections = UIPopoverArrowDirection.Any
        
        controller.presentViewController(alertController, animated: true) {
            
        }
    }
    
    
    
    
}

