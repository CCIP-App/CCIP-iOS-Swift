//
//  ScheduleViewController.swift
//  CCIP-iOS-Swift
//
//  Created by 高宜誠 on 2017/7/7.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

import Foundation
import UIKit

// TODO: Move This Const to Setting File
let DAY_ONE_DATE = "2017/08/06"
let DAY_TWO_DATE = "2017/08/07"

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var scrollView: UIScrollView!
    
    let dayFormatter = DateFormatter()
    var dayOneDate: Date?
    var dayTwoDate: Date?
    let timeFormatter = DateFormatter()
    
    // MARK: Life Cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dayFormatter.dateFormat = "yyyy/MM/dd"
        dayFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dayOneDate = dayFormatter.date(from: DAY_ONE_DATE)!
        dayTwoDate = dayFormatter.date(from: DAY_TWO_DATE)!
        timeFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        timeFormatter.dateFormat = "HH:mm"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dayOneTable.rowHeight = UITableViewAutomaticDimension
        self.dayTwoTable.rowHeight = UITableViewAutomaticDimension
        self.dayOneTable.estimatedRowHeight = 80
        self.dayTwoTable.estimatedRowHeight = 80
        loadSubmission()
    }
    
    var submissions:[Submission]?
    var filteredSubmissions:[Submission]?
    
    var dayOneSubmissions: [Date: [Submission]] = [:]
    var dayTwoSubmissions: [Date: [Submission]] = [:]
    var sortedDayOneSubmissionKey: [Date]?
    var sortedDayTwoSubmissionKey: [Date]?
    // Submissions Data
    func loadSubmission() {
        APIGateway.sharedInstance().getSubmissions(success: { (submissions) in
            self.submissions = submissions
            self.filteredSubmissions = self.filterSubmission(submissions: self.submissions!)
            let mask = Set([Calendar.Component.year , Calendar.Component.day , Calendar.Component.month])
            let dayOne = Calendar.current.dateComponents(mask, from: self.dayOneDate!)
            for submission in self.filteredSubmissions! {
                let day = Calendar.current.dateComponents(mask, from: submission.start)
                
                if (day == dayOne) {
                    if(self.dayOneSubmissions.keys.index(of: submission.start) == nil) {
                        self.dayOneSubmissions[submission.start] = []
                    }
                    self.dayOneSubmissions[submission.start]?.append(submission)
                    self.dayOneSubmissions[submission.start]?.sort(by: { (submissionA, submissionB) -> Bool in
                        return submissionA.room! < submissionB.room!
                    })
                } else {
                    if(self.dayTwoSubmissions.keys.index(of: submission.start) == nil) {
                        self.dayTwoSubmissions[submission.start] = []
                    }
                    self.dayTwoSubmissions[submission.start]?.append(submission)
                }
            }
            self.sortedDayOneSubmissionKey = self.dayOneSubmissions.keys.sorted()
            self.sortedDayTwoSubmissionKey = self.dayTwoSubmissions.keys.sorted()
            self.dayOneTable.reloadData()
            self.dayTwoTable.reloadData()
        }, failure: { (errorMessage) in
            
        })
    }
    // TODO: Complete Filter Function
    func filterSubmission(submissions: [Submission]) -> [Submission] {
        return submissions
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
        UIView.animate(withDuration: 0.5, animations: {
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
    
    // MARK: Tables
    @IBOutlet weak var dayOneTable: UITableView!
    @IBOutlet weak var dayTwoTable: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ((tableView == dayOneTable) ? dayOneSubmissions.count : dayTwoSubmissions.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == dayOneTable) ? dayOneSubmissions[sortedDayOneSubmissionKey![section]]!.count : dayTwoSubmissions[sortedDayTwoSubmissionKey![section]]!.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell: TimeCell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTimeCell") as! TimeCell
        cell.timeLabel.text = timeFormatter.string(from: ((tableView == dayOneTable) ? sortedDayOneSubmissionKey?[section]: sortedDayTwoSubmissionKey?[section])!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SubmissionCell = tableView.dequeueReusableCell(withIdentifier: "ScheduleSubmissionCell", for: indexPath) as! SubmissionCell
        cell.submission = (tableView == dayOneTable) ? dayOneSubmissions[sortedDayOneSubmissionKey![indexPath.section]]![indexPath.row] : dayTwoSubmissions[sortedDayTwoSubmissionKey![indexPath.section]]![indexPath.row]
        cell.titleLabel.text = cell.submission?.subject
        cell.roomLabel.text = cell.submission?.room!
        cell.durationLabel.text = String(format: "%d", Int((cell.submission?.end.timeIntervalSince((cell.submission?.start)!))!/60))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowDetailSegue", sender: self)
    }
}
