//
//  DisplayCouponViewController.swift
//  Hourglass
//
//  Created by Ryan Sachs on 3/22/17.
//  Copyright © 2017 Ryan Sachs. All rights reserved.
//

import UIKit

class DisplayCouponViewController: TimerViewController {

    @IBOutlet var couponView: DisplayCouponView!
    
    private var rewardName: String?
    private var employeeName: String?
    private var loyaltyPoints: Int?
    
    func setCouponText(reward: Deal, employeeName: String) {
        self.rewardName = reward.getName()
        self.loyaltyPoints = reward.getRequiredLoyaltyPointsForDeal()
        self.employeeName = employeeName
    }
    
    private struct Constants {
        static let OneMinute: Double = 1/480
        static let NormalRate: TimeInterval = 1
        static let UnwindSegue = "Go Back to Visit"
    }
    
    override func finishTimer() {
        super.finishTimer()
        performSegue(withIdentifier: Constants.UnwindSegue, sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        couponView.setCouponAttributes(rewardName: rewardName!, employeeName: employeeName!)
        couponView.setTimer(hours: Constants.OneMinute)
        startTimer(hours: Constants.OneMinute, rate: Constants.NormalRate)
    }

    @IBAction func done(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.UnwindSegue, sender: self)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.UnwindSegue:
                if let vvc = segue.destination.contentViewController as? VisitViewController {
                    // let the controller know which reward we redeemed so it can adjust points accordingly
                    print("changed points")
                    vvc.decreaseLoyaltyPoints(points: loyaltyPoints!)
                }
                
            default:
                print("here")
                if let vvc = segue.destination.contentViewController as? VisitViewController {
                    // let the controller know which reward we redeemed so it can adjust points accordingly
                    vvc.decreaseLoyaltyPoints(points: loyaltyPoints!)
                }
            }
        }

    }
    

}
