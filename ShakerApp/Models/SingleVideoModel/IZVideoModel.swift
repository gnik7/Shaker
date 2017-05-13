//
//  IZSingleVideoModel.swift
//  ShakerApp
//
//  Created by Nikita Gil on 20.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation

class IZVideoModel {
    
    var videoId             :Int?
    var videoTitle          :String?
    var universityTitle     :String?
    var videoDescription    :String?
    var videoURL            :String?
    var mainTitleUniversity :String?
    var filterItems         :[IZLandingModel]?
    
    init() {
        
    }
    
    init(videoId :Int ,videoTitle :String, universityTitle :String, videoDescription :String, videoURL:String, mainTitleUniversity:String , filterItems:[IZLandingModel]) {
        self.videoId = videoId
        self.videoTitle = videoTitle
        self.universityTitle = universityTitle
        self.videoDescription = videoDescription
        self.videoURL = videoURL
        self.filterItems = filterItems
        self.mainTitleUniversity = mainTitleUniversity
    }
}



class IZSingleVideoTableArray {
    
    var currentUserId : Int!
    var items : [IZSingleVideoTable]?
}

class IZSingleVideoTable {
    
    var userId                  : Int!
    var singleVideoItems        : [IZLandingModel]?
    var currentPaginationNumber : Int!
    
}

