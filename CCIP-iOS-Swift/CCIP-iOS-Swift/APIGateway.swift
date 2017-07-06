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

let BASE_URL = "https://ccip.coscup.org/"
let ATTENDEE_STATUS = "status"
/*
- (void)requestAttendeeStatusWithToken:(NSString* _Nonnull)token Completion:(void (^ _Nullable)(Attendee* _Nonnull attendee))completion Failure:(void (^ _Nullable)(ErrorMessage* _Nonnull message))failure;*/

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
                    return failure!(ErrorMessage(title: "", message: response.value?.message))
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
    
}
