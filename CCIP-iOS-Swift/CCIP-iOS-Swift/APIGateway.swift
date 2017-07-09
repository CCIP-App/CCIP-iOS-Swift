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

// TODO: Move This Const to Setting File
let BASE_URL = "https://ccip.coscup.org/"
let ATTENDEE_STATUS = "status"
let SUBMISSIONS_URL = "https://coscup.org/2017-assets/json/submissions.json"

struct ErrorMessage {
    var title: String!
    var message: String!
}

struct Cache {
    var attendee: Attendee?
    private var _submission: [Submission]?
    private var _submissionPath = (NSTemporaryDirectory() as String) + "/Submissions"
    var submissions: [Submission]? {
        set {
            _submission = newValue
            NSKeyedArchiver.archiveRootObject(_submission!, toFile: _submissionPath)
        }
        mutating get {
            if (_submission == nil && FileManager.default.fileExists(atPath: _submissionPath)) {
                _submission = NSKeyedUnarchiver.unarchiveObject(withFile: _submissionPath) as? [Submission]
            }
            return _submission
        }
    }
    var announcements: [Announcement]?
}

// MARK: Observers
protocol TokenObserver {
    func tokenHaveChange(attendee: Attendee?)
}

// MARK: Responses
class AttendeeResponse: Attendee {
    var message: String?
    override func mapping(map: Map) {
        super.mapping(map: map)
        message <- map["message"]
    }
}

class SubmissionsResponse: Mappable {
    var submissions: [Submission]?
    required init?(map: Map) {
        
    }
 func mapping(map: Map) {
        submissions <- map["data"]
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
    
    // MARK: Submissions
    func requestSubmissions(success: @escaping ([Submission]) -> Void, failure: ((ErrorMessage) -> Void)?) {
        
        Alamofire.request(SUBMISSIONS_URL).responseJSON { (response) in
            let json: [String: Any] = ["data": response.result.value!]
            let submissionsResponse = SubmissionsResponse(JSON: json)
            self.cache.submissions = submissionsResponse?.submissions
            
        }
    }
    
    func getSubmissions(success: @escaping ([Submission]) -> Void, failure: ((ErrorMessage) -> Void)?) {
        if(cache.submissions != nil) {
            return success(cache.submissions!)
        }
        requestSubmissions(success: { (submissions) in
            self.cache.submissions = submissions
            return success(self.cache.submissions!)
        }, failure: failure)
    }
    
    // MARK: Token
    private(set) var accessToken: String! {
        set {
            KeychainWrapper.standard.set(newValue, forKey: "token")
        }
        get {
            return KeychainWrapper.standard.string(forKey: "token") ?? ""
        }
    }
    
    var haveAccessToken: Bool {
        return accessToken.characters.count > 0 ? true : false
    }
    
    func setAccessToken(token: String!, success: @escaping (Attendee) -> Void, failure: ((ErrorMessage) -> Void)?) {
        accessToken = token
        requestAttendee(token: token, success: { (attendee: Attendee) in
            OneSignal.sendTags(["Token": self.accessToken, "type": attendee.type!])
            self.notifyTokenObserver()
            return success(attendee)
        }, failure: failure)
        
    }
    
    func resetAccessToken() {
        self.cache.attendee = nil;
        accessToken = ""
        OneSignal.sendTags(["token":""])
        self.notifyTokenObserver()
    }
    
    // MARK: Token Observer
    private var tokenObservers: [TokenObserver] = []
    
    func addTokenObserver(observer: TokenObserver) {
        tokenObservers.append(observer)
    }
    
    private func notifyTokenObserver() {
        for observer in tokenObservers {
            observer.tokenHaveChange(attendee: cache.attendee)
        }
    }
}
