//
//  IZLandingModel.swift
//  ShakerApp
//
//  Created by Nikita Gil on 15.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import ObjectMapper

class IZLandingItemsModel :Mappable {
    
    var itemsArray          : [IZLandingModel]?
    var pagination          : IZPaginationModel?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        self.itemsArray             <- map["data"]
        self.pagination             <- map["meta.pagination"]
    }
    
}


class IZLandingRandomItemModel :Mappable {
    
    var item : IZLandingModel?
    
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        self.item  <- map["data"]
    }
    
}

class IZLandingModel : Mappable  {
    
    var idVideo         : Int?
    var title           : String?
    var description     : String?
    var descriptionLink : String?
    var cover           : String?
    var amazon_url      : String?
    var videoUrl        : String?  //stream_url
    var isNew           : Bool?
    var isFavorite      : Bool?
    var links           : String?
    var categories      : [Int]?
    var university      : IZLandingUniversityModel?
    
    init() {        
    }
    
    init(idVideo :Int?, title :String?, description :String?, videoUrl :String?, isNew:Bool?, isFavorite: Bool? ) {
        self.idVideo = idVideo
        self.title = title
        self.description = description
        self.videoUrl = videoUrl
        self.isNew = isNew
        self.isFavorite = isFavorite
    }
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        self.idVideo                <- map["id"]
        self.title                  <- map["title"]
        self.description            <- map["description"]
        self.descriptionLink        <- map["description_link"]
        self.cover                  <- map["cover"]
        self.amazon_url             <- map["source.amazon_url"]
        self.videoUrl               <- map["source.hls"]
        self.isNew                  <- map["is_new"]
        self.isFavorite             <- map["is_favorite"]
        self.categories             <- map["categories.data"]
        self.university             <- map["university.data"]
        self.links                  <- map["links.self"]
        
        if self.descriptionLink == nil || (self.descriptionLink?.isEmpty)! {
            self.descriptionLink = self.university?.link
        }}
}


class IZLandingUniversityModel :Mappable {
    
    var id          : Int?
    var title       : String?
    var link        : String?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        self.id             <- map["id"]
        self.title          <- map["title"]
        self.link           <- map["link"]
    }   
}

class IZPaginationModel :Mappable {
    
    var total           : Int?
    var count           : Int?
    var perPage         : Int?
    var currentPage     : Int?
    var totalPages      : Int?
    var nextPage        : String?
    
    init(){
        self.total = 0
        self.count = 0
        self.perPage = 0
        self.currentPage = 1
        self.totalPages = 0
    }
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        self.total              <- map["total"]
        self.count              <- map["count"]
        self.perPage            <- map["per_page"]
        self.currentPage        <- map["current_page"]
        self.totalPages         <- map["total_pages"]
        self.nextPage           <- map["links.next"]
    }
}




