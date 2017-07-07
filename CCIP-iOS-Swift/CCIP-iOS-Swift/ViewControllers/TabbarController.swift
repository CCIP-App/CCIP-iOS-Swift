//
//  TabViewController.swift
//  CCIP-iOS-Swift
//
//  Created by 高宜誠 on 2017/7/7.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

import Foundation
import UIKit

// TODO: Move This Const to Setting File
let TELEGRAM_ID = "coscupchat"

class TabbarController:UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if (viewController.restorationIdentifier == "Telegram") {
            var telegramURL: URL = URL(string: "tg://resolve?domain=" + TELEGRAM_ID)!
            if (!UIApplication.shared.canOpenURL(telegramURL)) {
                telegramURL = URL(string: "https://telegram.me/" + TELEGRAM_ID)!
            }
            UIApplication.shared.openURL(telegramURL)
            return false
        }
        return true
    }
}
