//
//  IZSingleVideoModelMapper.swift
//  ShakerApp
//
//  Created by Nikita Gil on 23.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import ObjectMapper

//TODO:   не используется


class IZSingleVideoModel : Mappable {
    
    var videoId             :Int?
    var videoTitle          :String?
    var videoDescription    :String?
    var videoPicture        :String?
    var videoURL            :String?
    var userId              :Int?
    var isNew               :Bool?
    var isFavorite          :Bool?
    
    init() {}
    
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        self.videoId                <- map["id"]
        self.videoTitle             <- map["title"]
        self.videoDescription       <- map["description"]
        self.userId                 <- map["user_id"]
        self.videoPicture           <- map["cover"]
        self.videoURL               <- map["stream_url"]
        self.isNew                  <- map["is_new"]
        self.isFavorite             <- map["is_favorite"]
    }
    
    class func convertIZLandingModelToSingleVideo(item : IZLandingModel) -> IZSingleVideoModel {
        
        let singleVideo = IZSingleVideoModel()
        singleVideo.videoId = item.idVideo
        singleVideo.videoTitle = item.title
        singleVideo.videoDescription = item.description
        singleVideo.videoPicture = item.cover
        singleVideo.videoURL = item.videoUrl
        
        singleVideo.isNew = item.isNew
        singleVideo.isFavorite = item.isFavorite
        
        return singleVideo
    }
    
    
}
