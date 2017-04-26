//
//  RedeemCouponView.swift
//  Hourglass
//
//  Created by Ryan Sachs on 3/21/17.
//  Copyright © 2017 Ryan Sachs. All rights reserved.
//

import UIKit

class RedeemCouponView: UIView {
    
    @IBOutlet weak var rewardLabel: UILabel!
    
    @IBOutlet weak var employeeLabel: UILabel!
    
    @IBOutlet weak var redeemButton: UIButton!
    
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
    
    func setRewardText(rewardName: String) {
        rewardText = rewardName
        rewardLabel.textColor = UIColor.black
    }
    
    func setEmployeeText(employeeName: String) {
        employeeText = employeeName
        employeeLabel.textColor = UIColor.black
    }
    
    func resetEmployeeText() {
        self.employeeText = "Select Employee Below."
        employeeLabel.textColor = UIColor.red
        self.rewardText = "Select Reward Below."
        rewardLabel.textColor = UIColor.red
    }
    
    func setRedeemButton(enabled: Bool) {
        redeemButton.isEnabled = enabled
    }

}
