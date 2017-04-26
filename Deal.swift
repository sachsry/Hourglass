//
//  Deal.swift
//  Hourglass
//
//  Created by Ryan Sachs on 1/16/17.
//  Copyright © 2017 Ryan Sachs. All rights reserved.
//

import Foundation

enum DealStatus {
    case Ongoing(visits: Int)
    case Finished
}

class Deal: Equatable, Comparable {
    private var status: DealStatus
    private var requiredLoyaltyPointsForDeal: Int
    private var name: String
    
    init(name: String, requiredVisitsForDeal: Int) {
        self.name = name
        self.requiredLoyaltyPointsForDeal = requiredVisitsForDeal
        self.status = DealStatus.Ongoing(visits: Int(requiredVisitsForDeal))
    }
    
    func restart(visits: Int) {
        switch status {
        case DealStatus.Ongoing(let oldRemainingVisits):
            let currentRemainingVisits = oldRemainingVisits + visits
            let restartedVisits = currentRemainingVisits > requiredLoyaltyPointsForDeal ? requiredLoyaltyPointsForDeal : currentRemainingVisits
            status = DealStatus.Ongoing(visits: restartedVisits)
        case DealStatus.Finished:
            status = DealStatus.Ongoing(visits: requiredLoyaltyPointsForDeal)
        }
    }
    
    func completeVisit() {
        switch status {
        case DealStatus.Ongoing(let oldRemainingVisits):
            let currentRemainingVisits = oldRemainingVisits - 1
            status = currentRemainingVisits == 0 ? DealStatus.Finished : DealStatus.Ongoing(visits: currentRemainingVisits)
        case DealStatus.Finished: break
        }
    }
    
    func getRemainingVisits() -> Int {
        switch status {
        case DealStatus.Ongoing(let remaining): return remaining
        case DealStatus.Finished: return 0
        }
    }
    
    func getRequiredLoyaltyPointsForDeal() -> Int {
        return requiredLoyaltyPointsForDeal
    }
    
    func getName() -> String { return name }
    
    static func == (lhs: Deal, rhs: Deal) -> Bool {
        return (lhs.name == rhs.name && lhs.requiredLoyaltyPointsForDeal == rhs.requiredLoyaltyPointsForDeal)
    }
    
    static func < (lhs: Deal, rhs: Deal) -> Bool {
        return (lhs.requiredLoyaltyPointsForDeal < rhs.requiredLoyaltyPointsForDeal)
    }
    
}

class Bar {
    private var deals: [Deal]
    private var hourGlassRate: TimeInterval
    private var currentDeal: Deal? // delete
    private var currentDealIndex: Int // delete
    private var timeForVisit: Double
    private var loyaltyPointsForVisit: Int
    
    init(rate: TimeInterval, timeForVisit: Double) {
        hourGlassRate = rate
        self.timeForVisit = timeForVisit
        deals = []
        currentDeal = nil
        currentDealIndex = 0
        loyaltyPointsForVisit = 10
    }
    
    init(rate: TimeInterval, timeForVisit: Double, dealList: [Deal]) {
        deals = dealList
        hourGlassRate = rate
        self.timeForVisit = timeForVisit
        currentDeal = deals.first
        currentDealIndex = 0
        loyaltyPointsForVisit = 10
    }
    
    func getCurrentDeal() -> Deal? {
        return currentDeal!
    }
    
    func nextDeal() -> Deal? {
        let size = deals.count
        if size > 0 {
            currentDealIndex = currentDealIndex == size - 1 ? 0: currentDealIndex + 1
            currentDeal = deals[currentDealIndex]
        }
        
        return currentDeal
    }
    
    func previousDeal() -> Deal? {
        let size = deals.count
        if size > 0 {
            currentDealIndex = currentDealIndex == 0 ? size - 1: currentDealIndex - 1
            currentDeal = deals[currentDealIndex]
        }
        
        return currentDeal
    }
    
    func getHourGlassRate() -> TimeInterval {
        return hourGlassRate
    }
    
    func getTimeForVisit() -> Double {
        return timeForVisit
    }
    
    func addDeal(deal: Deal) {
        deals.append(deal)
        deals.sort() { $0 < $1 }
        
        currentDeal = deals.first
    }
    
    // Returns list of deals that are redeemable
    func getRedeemableRewards(points: Int) -> [Deal] {
        var redeemableRewards = [Deal]()
        for deal in deals {
            if deal.getRequiredLoyaltyPointsForDeal() <= points {
                redeemableRewards.append(deal)
            }
        }
        
        return redeemableRewards
    }
    
    func getVisitPoints() -> Int {
        return loyaltyPointsForVisit
    }
    
}



