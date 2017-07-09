//
//  LogoNavigationBar.swift
//  CCIP-iOS-Swift
//
//  Created by 高宜誠 on 2017/7/7.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

import Foundation
import UIKit

class LogoNavigationBar: UINavigationBar {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let logoImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "CoscupLogo"))
        logoImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 28)
        logoImageView.contentMode = UIViewContentMode.scaleAspectFit
        self.topItem?.titleView = logoImageView
    }
}
