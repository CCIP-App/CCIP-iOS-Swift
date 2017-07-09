//
//  FontUtil.swift
//  CCIP-iOS-Swift
//
//  Created by 高宜誠 on 2017/7/9.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

import Foundation
import UIKit

class FontUtil {
    static func sfuiTextRegular(string: String, size: Int, color: UIColor?) -> NSAttributedString {
        let attribute = [NSForegroundColorAttributeName: color ?? UIColor.black,
                         NSFontAttributeName: UIFont.fontNames(forFamilyName: "SF UI Text Regular"),
                         ] as [String : Any]
        return NSAttributedString(string: string, attributes: attribute)
    }
}
