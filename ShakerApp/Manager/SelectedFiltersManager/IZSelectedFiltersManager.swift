//
//  IZSelectedFiltersMAnager.swift
//  ShakerApp
//
//  Created by Nikita Gil on 21.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation


class IZSelectedFiltersManager {
    
    var checkedSubItems: [CheckedSubItemsModel]?
    
    class var sharedInstance: IZSelectedFiltersManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: IZSelectedFiltersManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = IZSelectedFiltersManager()
        }
        return Static.instance!
    }
    
    init() {
        self.checkedSubItems = [CheckedSubItemsModel]()
    }
    
    func countSelectedCategories() -> Int {
        
        if checkedSubItems!.count == 0 {
            return 0
        }
        
        var categoryArray = [Int]()
        
        for item in checkedSubItems! {
            if !categoryArray.contains(item.categoryId!) {
                categoryArray.append(item.categoryId!)
            }
        }
        
        return categoryArray.count
    }
    
    func selectedSubCategoriesIndexes() -> [Int]? {
        
        guard checkedSubItems != nil else {
            return nil
        }
        
        var indexesArray = [Int]()
        
        for item in checkedSubItems! {
            indexesArray.append(item.itemIndex!)
        }
        return indexesArray
    }

}