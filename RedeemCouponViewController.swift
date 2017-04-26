//
//  RedeemCouponViewController.swift
//  Hourglass
//
//  Created by Ryan Sachs on 3/21/17.
//  Copyright © 2017 Ryan Sachs. All rights reserved.
//

import UIKit

class RedeemCouponViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var redeemCouponView: RedeemCouponView!
    
    private var userName: String?
    private var rewardName: String?
    private var employees: [String]?
    private var redeemableRewards: [String]?
    private var deals: [Deal] = []
    
    func setCouponText(userName: String, rewardName: String) {
        self.userName = userName
        self.rewardName = rewardName
    }
    
    // sets names for the picker view
    func setEmployeesForCoupon(names: [String]) {
        employees = names
    }
    
    // sets deals for the picker view
    func setDealsForCoupon(deals: [Deal]) {
        redeemableRewards = []
        self.deals = deals
        for deal in deals {
            redeemableRewards?.append("\(deal.getName()) - \(deal.getRequiredLoyaltyPointsForDeal())")
        }
    }
    
    @IBAction func cancelRedemption(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var employeePicker: UIPickerView!
    
    // Delegate methods for picker view
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 { return (employees?.count)! }
        else              { return (redeemableRewards?.count)!}
    }
    
    private var selectedEmployee: String?
    private var selectedDeal: Deal?
    private var numberOfPointsForDeal: Int?
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            selectedEmployee = employees?[row]
            return employees?[row]
        } else {
            selectedDeal = deals[row]
            return redeemableRewards?[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        if component > 0 {
            label.font = UIFont(name: "Helvetica", size: 17.0)
            label.text = redeemableRewards?[row]
            selectedDeal = deals[row]
        } else {
            label.font = UIFont(name: "Helvetica", size: 25.0)
            let employee = employees?[row]
            selectedEmployee = employee
            label.text = employee
        }
        
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }
    
    
    private struct Constants {
        static let SelectEmployeeButton = "Select Employee"
        static let UnselectEmployeeButton = "Unselect Employee"
        static let DisplayCouponButton = "Display Coupon"
        static let DisplayCouponSegue = "Display Coupon"
        static let FirstPartOfAlertMessage = "Only the employee selected is authorized to redeem your reward. The coupon will display on screen for at most 60 seconds. Your loyalty points will be reduced by "
        static let SecondPartOfAlertMessage = " points after redemption of this coupon. Click 'Ok' to continue."
    }
    
    @IBAction func selectOrUnselectEmployee(_ sender: UIButton) {
        let buttonText = sender.title(for: .normal) ?? ""
        switch  buttonText {
        case Constants.SelectEmployeeButton:
            selectEmployee(sender)
        case Constants.UnselectEmployeeButton:
            unselectEmployee(sender)
        default:
            print("Error")
        }
    }
    
    private func selectEmployee(_ sender: UIButton) {
        if selectedEmployee != nil, selectedDeal != nil {
            let deal = selectedDeal!
            let employee = selectedEmployee!
            
            if !employee.isEmpty {
                numberOfPointsForDeal = deal.getRequiredLoyaltyPointsForDeal()
                sender.setTitle(Constants.UnselectEmployeeButton, for: .normal)
                employeePicker.isHidden = true
                redeemCouponView.setRedeemButton(enabled: true)
                redeemCouponView.setEmployeeText(employeeName: employee)
                redeemCouponView.setRewardText(rewardName: deal.getName())
            }
        }
        
    }
    
    private func unselectEmployee(_ sender: UIButton) {
        sender.setTitle(Constants.SelectEmployeeButton, for: .normal)
        employeePicker.isHidden = false
        redeemCouponView.setRedeemButton(enabled: false)
        redeemCouponView.resetEmployeeText()
    }
    
    @IBAction func redeemReward(_ sender: UIButton) {
        if numberOfPointsForDeal != nil {
            let points = numberOfPointsForDeal!
            let alert = UIAlertController(title: Constants.DisplayCouponButton,
                                          message: Constants.FirstPartOfAlertMessage + points.description + Constants.SecondPartOfAlertMessage,
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                action in self.performSegue(withIdentifier: Constants.DisplayCouponSegue, sender: self)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        employeePicker.delegate = self
        employeePicker.dataSource = self
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.DisplayCouponSegue:
                if let dcvc = segue.destination.contentViewController as? DisplayCouponViewController {
                    dcvc.setCouponText(reward: selectedDeal!, employeeName: selectedEmployee!)
                }
                
            default:
                break
            }
        }
    }
}

