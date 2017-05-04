//
//  VisitViewController.swift
//  Hourglass
//
//  Created by Ryan Sachs on 3/20/17.
//  Copyright © 2017 Ryan Sachs. All rights reserved.
//

import UIKit

class VisitViewController: TimerViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var visitView: VisitView! {
        didSet {
            let nextDealSwipeRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(nextDeal)
            )
            let previousDealSwipeRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(previousDeal)
            )
            nextDealSwipeRecognizer.direction = .left
            previousDealSwipeRecognizer.direction = .right
            visitView.addGestureRecognizer(nextDealSwipeRecognizer)
            visitView.addGestureRecognizer(previousDealSwipeRecognizer)
            
        }
    }
    
    @IBOutlet weak var logoView: HourGlassLogoView! {
        didSet {
            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(redeemReward))
        }
    }
    
    private var tapGestureRecognizer :UITapGestureRecognizer?
    
    func nextDeal() {
        currentDeal = bar?.nextDeal()
        visitView.updateUI(withNewDeal: currentDeal)
    }
    
    func previousDeal() {
        currentDeal = bar?.previousDeal()
        visitView.updateUI(withNewDeal: currentDeal)
    }
    
    func redeemReward() {
        performSegue(withIdentifier: Constants.RedeemRewardSegue, sender: logoView)
    }
    
    private var bar: Bar?
    private var currentDeal: Deal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBar()
    }
    
    override func startTimer(hours: Double, rate: TimeInterval) {
        super.startTimer(hours: hours, rate: rate)
    }
    
    override func finishTimer() {
        super.finishTimer()
        visitView.setTimeLabel(withMessage: Constants.TimerIsCompleteMessage)
        if bar != nil {
            let b = bar!
            currentLoyaltyPointsForBar += b.getVisitPoints()
            visitView.updateLoyaltyPoints(withPoints: currentLoyaltyPointsForBar)
            logoView.sandEarned = CGFloat(currentLoyaltyPointsForBar / currentDeal!.getRequiredLoyaltyPointsForDeal())
            visitView.setNeedsDisplay()
            manageRedeemableRewards()
            manageTapGestureRecognizer()
            
        }
        
    }
    
    private var employees: [String]?
    
    // FOR SCOTTY
    // Make this a query call to whatever bar you check into
    // Set the 'bar' variable equal to the resulting bar
    // Make another query call to get all the employees currently working
    // Set the 'employees' variable equal to the result
    
    private func setUpBar() {
        bar = Bar(rate: 1, timeForVisit: 0.003)                                 // Replace with bar query
        
        for (name, visits) in barDeals {                                        // Replace with bar query
            bar!.addDeal(deal: Deal(name: name, requiredVisitsForDeal: visits)) // Replace with bar query
        }                                                                       // Replace with bar query
        
        employees = testEmployees                                               // Replace with employee query
        currentLoyaltyPointsForBar = 40                                         // Replace with query
        visitView.updateLoyaltyPoints(withPoints: currentLoyaltyPointsForBar)
        
        // Keep these lines
        if bar != nil  {
            let b = bar!
            let deal = b.getCurrentDeal()
            visitView.setTimer(hours: b.getTimeForVisit())
            currentDeal = deal
            visitView.updateUI(withNewDeal: deal)
            logoView.sandEarned = CGFloat(CGFloat(currentLoyaltyPointsForBar) / CGFloat(deal!.getRequiredLoyaltyPointsForDeal()))
            manageRedeemableRewards()
            manageTapGestureRecognizer()
            startTimer(hours: b.getTimeForVisit(), rate: b.getHourGlassRate())
        }
    }
    
    // Won't be needed once setUpBar() is altered
    private let barDeals = [
        "Free Domestic Beer" : 50,
        "Free Rail" : 50
    ]
    
    private let testEmployees = [
        "",
        "Ryan",
        "Scotty",
        "Samantha",
        "Evan"
    ]
    
    // adds and removes ability to redeem reward based on remaining visits
    private func manageTapGestureRecognizer() {
        if redeemableRewardsForUser.isEmpty {
            logoView.complete = false
            logoView.removeGestureRecognizer(tapGestureRecognizer!)
        } else {
            logoView.complete = true
            logoView.addGestureRecognizer(tapGestureRecognizer!)
            
        }
    }
    
    private struct Constants {
        static let RedeemRewardSegue = "Redeem"
        static let TimerIsCompleteMessage = "Your visit is complete!"
    }
    
    @IBAction func unwindToVisit(segue: UIStoryboardSegue) {
//        print("just unwinded and the amount is \(currentLoyaltyPointsForBar)")
        logoView.sandEarned = 0
        manageRedeemableRewards()
        manageTapGestureRecognizer()
        visitView.updateLoyaltyPoints(withPoints: currentLoyaltyPointsForBar)
    }
    
    private var currentLoyaltyPointsForBar = 0
    private var redeemableRewardsForUser: [Deal] = []
    
    private func manageRedeemableRewards() {
        if bar != nil {
            let b = bar!
            redeemableRewardsForUser = b.getRedeemableRewards(points: currentLoyaltyPointsForBar)
        }
    }
    
    private func userHasEarnedReward() -> Bool {
        return !redeemableRewardsForUser.isEmpty
    }
    
    func decreaseLoyaltyPoints(points: Int) {
        currentLoyaltyPointsForBar -= points
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.RedeemRewardSegue:
                if let rcvc = segue.destination.contentViewController as? RedeemCouponViewController {
                    // rcvc.setCouponText(userName: "John Doe", rewardName: (currentDeal?.getName())!)
                    rcvc.setEmployeesForCoupon(names: employees!)
                    rcvc.setDealsForCoupon(deals: redeemableRewardsForUser)
                }
                
            default:
                break
            }
        }
    }

}

extension UIViewController {
    var contentViewController: UIViewController {
        get {
            if let navcon = self as? UINavigationController {
                return navcon.visibleViewController ?? self
            } else {
                return self
            }
        }
    }
}
