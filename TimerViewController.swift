//
//  TimerViewController.swift
//  Hourglass
//
//  Created by Ryan Sachs on 1/11/17.
//  Copyright © 2017 Ryan Sachs. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    @IBOutlet weak var timerView: TimerView!
    
    private var timer :Timer?
    
    
    func updateEllapsedTime() {
        let remainingSecondsForVisit = timerView.updateTimer()
        if remainingSecondsForVisit == 0 {
            finishTimer()
        }
    }
    
    func finishTimer() {
        timer?.invalidate()
    }
    
    func startTimer(hours: Double, rate: TimeInterval) {
        timer = Timer.scheduledTimer(timeInterval: rate, target: self, selector: #selector(updateEllapsedTime), userInfo: nil, repeats: true)
    }

}
