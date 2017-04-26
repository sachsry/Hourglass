//
//  DisplayCouponView.swift
//  Hourglass
//
//  Created by Ryan Sachs on 3/22/17.
//  Copyright © 2017 Ryan Sachs. All rights reserved.
//

import UIKit

class DisplayCouponView: TimerView {

    @IBOutlet weak var rewardLabel: UILabel!
    
    @IBOutlet weak var employeeLabel: UILabel!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
    
    private var rewardText: String? {
        get {
            return rewardLabel.text
        }
        set {
            rewardLabel.text = newValue
        }
    }
    
    private var employeeText: String? {
        get {
            return employeeLabel.text
        }
        set {
            employeeLabel.text = newValue
        }
    }
    
    private var timeStampText: String? {
        get {
            return timeStampLabel.text
        }
        set {
            timeStampLabel.text = newValue
        }
    }
    
    func setCouponAttributes(rewardName: String, employeeName: String) {
        rewardText = rewardName
        employeeText = employeeName
        timeStampText = getTimeStamp()
    }
    
    private func getTimeStamp() -> String {
        let date = Date()
        let calender = Calendar.current
        
        let year = calender.component(.year, from: date)
        let month = calender.component(.month, from: date)
        let day = calender.component(.day, from: date)
        let hours = calender.component(.hour, from: date)
        let minutes = calender.component(.minute, from: date)
        let seconds = calender.component(.second, from: date)
        
        return "\(month)/\(day)/\(year) at \(hours):\(minutes):\(seconds)"
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
