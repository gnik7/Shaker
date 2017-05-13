//
//  ErrorMapper.swift
//  ShakerApp
//
//  Created by Nikita Gil on 23.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import ObjectMapper

class IZErrorMapper : Mappable {
    
    var code          :String?
    var status        :String?
    var title         :String?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        self.code <- map["code"]
        self.status     <- map["status"]
        self.title    <- map["title"]
    }
    
}