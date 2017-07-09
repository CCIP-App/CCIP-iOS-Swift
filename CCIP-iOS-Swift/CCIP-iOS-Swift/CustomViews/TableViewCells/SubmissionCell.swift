//
//  SubmissionCell.swift
//  CCIP-iOS-Swift
//
//  Created by 高宜誠 on 2017/7/9.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

import Foundation
import UIKit

class SubmissionCell: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    var submission: Submission?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
}
