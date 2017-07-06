//
//  Attendee.swift
//  CCIP-iOS-Swift
//
//  Created by 高宜誠 on 2017/7/6.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

import Foundation
import ObjectMapper

class Attendee: Mappable {
    var token: String?
    var userId: String?
    var attr: [String : Any]?
    var status: Int?
    var scenarios: [Scenario]?
    var type: NSString?
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        token <- map["token"]
        userId <- map["user_id"]
        attr <- map["attr"]
        status <- map["status"]
        scenarios <- map["scenarios"]
        type <- map["type"]
    }
}

class Scenario : Mappable {
    var scenarioId: String?
    var disabled: Bool?
    var countdown: Int?
    var used: Date?
    var expireTime: Date?
    var availableTime: Date?
    var attr: [String: Any]?
    var order: Int?
    var display: DisplayText?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        scenarioId <- map["scenario_id"]
        disabled <- map["disabled"]
        countdown <- map["countdown"]
        used <- (map["used"], DateTransform())
        expireTime <- (map["expireTime"], DateTransform())
        availableTime <- (map["availableTime"], DateTransform())
        attr <- map["attr"]
        order <- map["order"]
        display <- map["display"]
    }
}

class DisplayText : Mappable {
    
    var zh: String?
    var en: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        zh <- map["zh"]
        en <- map["en"]
    }
}
