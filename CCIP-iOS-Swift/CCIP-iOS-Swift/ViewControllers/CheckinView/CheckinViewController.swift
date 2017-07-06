//
//  CheckinViewController.swift
//  CCIP-iOS-Swift
//
//  Created by 高宜誠 on 2017/7/7.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

import Foundation
import UIKit

class CheckinViewController: UIViewController, TokenObserver {
    @IBOutlet weak var containerView: UIView!
    
    var redeemVC: UIViewController?
    var cardVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIGateway.sharedInstance().addTokenObserver(observer: self)
        redeemVC = (self.storyboard?.instantiateViewController(withIdentifier: "RedeemVC"))!
        cardVC = (self.storyboard?.instantiateViewController(withIdentifier: "CardVC"))!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presentContent(animate: false)
        super.viewWillAppear(animated)
    }
    
    // MARK: Present View Controller
    func presentContent(animate: Bool) {
        var vc: UIViewController?
        if(!APIGateway.sharedInstance().haveAccessToken) {
            vc = redeemVC
        } else {
            vc = cardVC
        }
        
        if(animate) {
            vc?.view.alpha = 0.0
            UIView.animate(withDuration: 0.5, animations: { 
                vc?.view.alpha = 1.0
            })
        }
        
        addSubview(subView: (vc?.view)!, toView: containerView)
        addChildViewController(vc!)
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func tokenHaveChange(attendee: Attendee?) {
        presentContent(animate: true)
    }
    
}
