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
        if(childViewControllers.index(of: vc!) != nil) {
            return
        } else {
            self.childViewControllers.first?.view.removeFromSuperview()
            self.childViewControllers.first?.removeFromParentViewController()
        }
        
        if(animate) {
            vc?.view.alpha = 0.0
            UIView.animate(withDuration: 0.5, animations: { 
                vc?.view.alpha = 1.0
            })
        }
        
        self.containerView.addSubview(vc!.view)
        addChildViewController(vc!)
    }
    
    func tokenHaveChange(attendee: Attendee?) {
        presentContent(animate: true)
    }
    
}
