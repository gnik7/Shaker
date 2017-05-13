//
//  IZHelpConverter.swift
//  ShakerApp
//
//  Created by Nikita Gil on 17.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//


import UIKit
import AVFoundation



class IZHelpConverter {
    
    //*****************************************************************
    // MARK: - get selected elements in Filter 1
    //*****************************************************************

    class func getSelectedSubItemsInFilter1(categoryItem :Int) -> [String]? {
        
        let checkedSubItems = IZSelectedFiltersManager.sharedInstance.checkedSubItems
        if checkedSubItems?.count > 0 {
            
            var subsArray = [String]()
            for item in checkedSubItems! {
                if item.categoryId == categoryItem {
                    subsArray.append(item.itemName!)
                }
            }
            return subsArray
        }
        return nil

    }
    
    //*****************************************************************
    // MARK: - Check state of checkbox in Filter 2
    //*****************************************************************
    
    class func stateCheckBoxInFilter2(categoryItemID :Int?, index :Int) -> Bool{
   
        let checkedSubItems = IZSelectedFiltersManager.sharedInstance.checkedSubItems
        if checkedSubItems!.count > 0 {
            
            for item in checkedSubItems! {
                if item.categoryId == categoryItemID && item.itemIndex == index {
                    return true
                }
            }
        }
        
        return false
    }
    
    //*****************************************************************
    // MARK: - Create Title for Section
    //*****************************************************************
    
    class func createUILabelForSectionTitle(xOffset :CGFloat, width: CGFloat, text :String) -> UILabel {
        
        let headerLabel = UILabel(frame: CGRectMake(xOffset, 0, width, 22.0))
        headerLabel.text = text
        headerLabel.font = UIFont(name: "Quicksand-Bold", size: 10.0)
        headerLabel.textColor = UIColor.init(colorLiteralRed: 76/255.0, green: 76/255.0, blue: 76/255.0, alpha: 1.0)
        headerLabel.textAlignment = .Left
        headerLabel.sizeToFit()

        return headerLabel
    }
    
    //*****************************************************************
    // MARK: - web url
    //*****************************************************************
    
    class func URL(string: String) -> String {
        return string.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
    
    //*****************************************************************
    // MARK: - Convert Array [Int] to String
    //*****************************************************************
    
    class func convertSubCategoriesArrayToString(subItems :[Int]?) -> String? {
        
        
        if let array = subItems as [Int]? {
            var fullString = ""
            for item in array {
                fullString += "\(item)"
                if item != array.last {
                    fullString += ","
                }
            }
            return fullString
        }
        return nil
    }
    
    //*****************************************************************
    // MARK: - Landing Array
    //*****************************************************************
    
    class func convertLandingArrayToIntArray(subItems :[IZLandingModel]?) -> [Int]? {
        
        if let array = subItems as [IZLandingModel]? {
            var intArray = [Int]()
            for item in array {
                if let idVideo = item.idVideo {
                    intArray.append(idVideo)
                }
            }
            return intArray
        }
        return nil
    }

    
    //*****************************************************************
    // MARK: - portrait Orientation
    //*****************************************************************

    class func portraitOrientation()  {
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.shouldSupportAllOrientation = false
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
}






