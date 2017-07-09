//
//  Submission.swift
//  CCIP-iOS-Swift
//
//  Created by 高宜誠 on 2017/7/6.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

import Foundation
import ObjectMapper

let SPEAKER_KEY = "SPEAKER_KEY"
let COMMUNITY_KEY = "COMMUNITY_KEY"
let START_KEY = "START_KEY"
let END_KEY = "END_KEY"
let TYPE_KEY = "TYPE_KEY"
let ROOM_KEY = "ROOM_KEY"
let SUBJECT_KEY = "SUBJECT_KEY"
let SUMMARY_KEY = "SUMMARY_KEY"

class Submission: NSObject, NSCoding, Mappable {

    var speaker: Speaker?
    var community: String?
    var start: Date!
    var end: Date!
    var type: String?
    var room: String?
    var subject: String!
    var summary: String?
    
    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        speaker = aDecoder.decodeObject(forKey: SPEAKER_KEY) as? Speaker
        community = aDecoder.decodeObject(forKey: COMMUNITY_KEY) as? String
        start = aDecoder.decodeObject(forKey: START_KEY) as! Date
        end = aDecoder.decodeObject(forKey: END_KEY) as! Date
        type = aDecoder.decodeObject(forKey: TYPE_KEY) as? String
        room = aDecoder.decodeObject(forKey: ROOM_KEY) as? String
        subject = aDecoder.decodeObject(forKey: SUBJECT_KEY) as! String
        summary = aDecoder.decodeObject(forKey: SUMMARY_KEY) as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(speaker, forKey: SPEAKER_KEY)
        aCoder.encode(community, forKey: COMMUNITY_KEY)
        aCoder.encode(start, forKey: START_KEY)
        aCoder.encode(end, forKey: END_KEY)
        aCoder.encode(type, forKey: TYPE_KEY)
        aCoder.encode(room, forKey: ROOM_KEY)
        aCoder.encode(subject, forKey: SUBJECT_KEY)
        aCoder.encode(summary, forKey: SUMMARY_KEY)
    }
    
    // MARK: ObjectMapper
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        speaker <- map["speaker"]
        start <- (map["start"], ISO8601DateTransform())
        end <- (map["end"], ISO8601DateTransform())
        community <- map["community"]
        type <- map["type"]
        room <- map["room"]
        subject <- map["subject"]
        summary <- map["summary"]
    }
}

let NAME_KEY = "NAME_KEY"
let AVATAR_KEY = "AVATAR_KEY"
let BIO_KEY = "BIO_KEY"

class Speaker: NSObject, NSCoding, Mappable {
    
    var name: String!
    var avatar: String?
    var bio: String?
    
    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: NAME_KEY) as! String
        avatar = aDecoder.decodeObject(forKey: AVATAR_KEY) as? String
        bio = aDecoder.decodeObject(forKey: BIO_KEY) as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: NAME_KEY)
        aCoder.encode(avatar, forKey: AVATAR_KEY)
        aCoder.encode(bio, forKey: BIO_KEY)
    }
    
    // MARK: ObjectMapper
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        avatar <- map["avatar"]
        bio <- map["bio"]
    }
}
