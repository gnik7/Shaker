//
//  IZFilterModel.swift
//  ShakerApp
//
//  Created by Nikita Gil on 16.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import ObjectMapper

class IZFilterModel : Mappable {
    
    var categories : [IZFilterCategoryModel]?
    
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        self.categories         <- map["data"]
    }

}


class IZFilterCategoryModel : Mappable {
    
    var categoryId       : Int?
    var categoryTitle    : String?
    var subcategoryItems : [IZFilterSubCategoryModel]?
    
    init() {
        
    }
    
    init(categoryId :Int ,categoryTitle :String, categoryItems :[IZFilterSubCategoryModel]) {
        self.categoryTitle = categoryTitle
        self.subcategoryItems = categoryItems
        self.categoryId = categoryId
    }
    
    required init?(_ map: Map){        
    }
    
    func mapping(map: Map) {
        self.categoryId         <- map["id"]
        self.categoryTitle      <- map["title"]
        self.subcategoryItems   <- map["children.data"]
    }
}

class IZFilterSubCategoryModel : Mappable {
    
    var itemName        :String?
    var itemIndex       :Int?
    var categoryId      :Int?
    
    init() {}
    
    init(itemName :String, itemIndex :Int, categoryId :Int) {
        self.itemName = itemName
        self.itemIndex = itemIndex
        self.categoryId = categoryId
    }
    
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        self.itemName         <- map["title"]
        self.itemIndex        <- map["id"]
        
    }
}

class CheckedSubItemsModel  {
    
    var itemName        :String?
    var itemIndex       :Int?
    var categoryId      :Int?
    
    init() {}
    
    init(itemName :String, itemIndex :Int, categoryId :Int) {
        self.itemName = itemName
        self.itemIndex = itemIndex
        self.categoryId = categoryId
    }

}

