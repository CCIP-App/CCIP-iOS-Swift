//
//  ScheduleViewController.swift
//  CCIP-iOS-Swift
//
//  Created by 高宜誠 on 2017/7/7.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

import Foundation
import UIKit

class ScheduleViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Day Select
    
    @IBOutlet weak var dayOneButton: UIButton!
    @IBOutlet weak var dayTwoButton: UIButton!
    @IBOutlet weak var dayOneIndicatorConstraint: NSLayoutConstraint!
    @IBOutlet weak var dayTwoIndicatorConstraint: NSLayoutConstraint!
    @IBAction func daySelect(_ sender: UIButton!) {
        dayOneButton.isSelected = false
        dayTwoButton.isSelected = false
        sender.isSelected = true
        UIView.animate(withDuration: 5, animations: {
            if(sender.tag == 0) {
                self.dayTwoIndicatorConstraint.isActive = false
                self.dayOneIndicatorConstraint.isActive = true
            } else {
                self.dayOneIndicatorConstraint.isActive = false
                self.dayTwoIndicatorConstraint.isActive = true
            }
            self.view.layoutIfNeeded()
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.bounds.width * CGFloat(sender.tag), y: 0.0), animated: false)
        })
    }
}
