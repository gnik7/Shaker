//
//  IZExtantions.swift
//  ShakerApp
//
//  Created by Nikita Gil on 21.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit


extension NSObject {
    
    //*****************************************************************
    // MARK: - Convert from class to string and Nib - for Cells
    //*****************************************************************
    
    class func classNibFromString(className :AnyClass) -> (String?, UINib?) {
        
        let classNameString = NSStringFromClass(className).componentsSeparatedByString(".").last!
        let nibObject = UINib(nibName: classNameString, bundle:nil)
        
        return (classNameString, nibObject)
    }
    
    class func classFromString(className :AnyClass) -> String? {
        return NSStringFromClass(className).componentsSeparatedByString(".").last
    }
}


extension UINavigationController {
    func pushViewController(viewController: UIViewController, animated: Bool, completion: (Void -> Void)) {
        pushViewController(viewController, animated: animated)
        
        if let coordinator = transitionCoordinator() where animated {
            coordinator.animateAlongsideTransition(nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}

//*****************************************************************
// MARK: - Count Height Label
//*****************************************************************

extension UILabel {
    
    func requiredHeight() -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, self.frame.width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = self.font
        label.text = self.text
        
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func lines() -> Int {
        var lineCount = 0;
        let textSize = CGSizeMake(self.frame.size.width, CGFloat(Float.infinity))
        let rHeight = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize = lroundf(Float(self.font.lineHeight))
        lineCount = rHeight/charSize
        print("No of lines \(lineCount)")
        return lineCount
    }
}

//*****************************************************************
// MARK: - Open Site
//*****************************************************************

extension UIView {
    func openURL(urlString: String) {
        if let urlWithPercentEscapes = urlString.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet()), let url = NSURL(string: urlWithPercentEscapes) {
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
}

