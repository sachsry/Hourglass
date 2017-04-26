//
//  VisitView.swift
//  Hourglass
//
//  Created by Ryan Sachs on 3/20/17.
//  Copyright © 2017 Ryan Sachs. All rights reserved.
//

import UIKit

class VisitView: TimerView {

    @IBOutlet weak var deal: UILabel!
    @IBOutlet weak var loyaltyPointsRequiredLabel: UILabel!
    @IBOutlet weak var visitTimeLabel: UILabel!
    @IBOutlet weak var loyaltyPointsLabel: UILabel!
    
    private var dealDescription: String {
        get {
            return deal.text!
        }
        set {
            deal.text = newValue
        }
    }
    
    private var loyaltyPointsRequiredText: String {
        get {
            return loyaltyPointsRequiredLabel.text!
        }
        set {
            loyaltyPointsRequiredLabel.text = newValue
        }
    }
    
    private var loyaltyPointsText: String {
        get {
            return loyaltyPointsLabel.text!
        }
        set {
            loyaltyPointsLabel.text = newValue
        }
    }
    
    
    func updateUI(withNewDeal newDeal: Deal?)  {
        dealDescription = (newDeal?.getName())!
        loyaltyPointsRequiredText = (newDeal?.getRequiredLoyaltyPointsForDeal().description)!
    }
    
    func updateLoyaltyPoints(withPoints points: Int)  {
        loyaltyPointsText = String(points)
    }
    
    override func setTimer(hours: Double) {
        super.setTimer(hours: hours)
    }
    
    override func updateTimer() -> Int {
        return super.updateTimer()
    }
    
    override func setTimeLabel(withMessage message: String) {
        super.setTimeLabel(withMessage: message)
        visitTimeLabel.text = "✅"
    }
    
    

}
