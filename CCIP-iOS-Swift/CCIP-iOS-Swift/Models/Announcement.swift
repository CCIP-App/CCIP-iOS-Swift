//
//  Announcement.swift
//  CCIP-iOS-Swift
//
//  Created by 高宜誠 on 2017/7/6.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

import Foundation
import ObjectMapper

class Announcement: Mappable {
    
    var datetime: Date!
    var msgZh: String?
    var msgEn: String?
    var uri: String?
    
    var msg: String {
        get {
            if (NSLocale.current.identifier == "zh") {
                return msgZh!
            }
            return msgEn!
        }
    }
    
    // MARK: ObjectMapper
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        datetime <- (map["datetime"], DateTransform())
        msgZh <- map["msg_zh"]
        msgEn <- map["msg_en"]
        uri <- map["uri"]
    }
}
