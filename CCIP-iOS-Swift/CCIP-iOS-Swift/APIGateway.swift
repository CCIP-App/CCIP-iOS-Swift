//
//  APIGateway.swift
//  CCIP-iOS-Swift
//
//  Created by 高宜誠 on 2017/7/6.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import OneSignal

let BASE_URL = "https://ccip.coscup.org/"
let ATTENDEE_STATUS = "status"

struct ErrorMessage {
    var title: String!
    var message: String!
}

struct Cache {
    var attendee: Attendee?
    var submissions: [Submission]?
    var announcements: [Announcement]?
}

// MARK: Responses
class AttendeeResponse: Attendee {
    var message: String?
    override func mapping(map: Map) {
        super.mapping(map: map)
        message <- map["message"]
    }
}

class APIGateway {
    // MARK: Singleton
    private static var instance: APIGateway?
    static func sharedInstance() -> APIGateway {
        if(instance == nil) {
            instance = APIGateway()
        }
        return instance!
    }
    
    private var cache: Cache! = Cache()
    var token: String?
    
    // MARK: Attendee
    func requestAttendee(token: String!, success: @escaping (Attendee) -> Void, failure: ((ErrorMessage) -> Void)?) {
        let parameters: Parameters = ["token": token]
        Alamofire.request(BASE_URL + ATTENDEE_STATUS, parameters:parameters).responseObject {
            (response: DataResponse<AttendeeResponse>) in
            
            switch response.result {
            case .success:
                if((response.value?.message) != nil) {
                    return failure!(ErrorMessage(title: "token_error".localized, message: response.value?.message))
                } else {
                    self.cache.attendee = response.value
                    return success(response.value!)
                }
            case .failure(let err):
                return failure!(ErrorMessage(title: "", message: err.localizedDescription))
            }
        }
    }
    
    func getAttendee(token: String!, success: @escaping (Attendee) -> Void, failure: ((ErrorMessage) -> Void)?) {
        if(cache.attendee != nil) {
            return success(cache.attendee!)
        }
        return requestAttendee(token: token, success: success, failure:failure)
    }
    
    func refreshAttendee(token: String!, success: @escaping (Attendee) -> Void, failure: ((ErrorMessage) -> Void)?) {
        requestAttendee(token: token, success: success, failure: failure)
    }
    
    // MARK: Token
    var accessToken: String! {
        set {
            KeychainWrapper.standard.set(newValue, forKey: "token")
        }
        get {
            return KeychainWrapper.standard.string(forKey: "token")
        }
    }
    
    var haveAccessToken: Bool {
        return accessToken.characters.count > 0 ? true : false
    }
    
    func setAccessToken(token: String!, success: @escaping (Attendee) -> Void, failure: ((ErrorMessage) -> Void)?) {
        accessToken = token
        requestAttendee(token: token, success: { (attendee: Attendee) in
            OneSignal.sendTags(["Token": self.accessToken, "type": attendee.type!])
            return success(attendee)
        }, failure: failure)
    }
    
    func resetAccessToken() {
        self.cache.attendee = nil;
        accessToken = ""
        OneSignal.sendTags(["token":""])
    }
}
