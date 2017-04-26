//
//  TimerView.swift
//  Hourglass
//
//  Created by Ryan Sachs on 1/11/17.
//  Copyright © 2017 Ryan Sachs. All rights reserved.
//

import UIKit

class TimerView: UIView {

    @IBOutlet weak var remainingTime: UILabel!
    
    private var seconds: Int {
        get {
            return secondsLeft(time: time) ?? -1
        }
        set {
            time = createRemainingTimeString(numberOfSeconds: newValue)
        }
    }
    
    // Formats time into String with format: <HH:MM:SS>
    private func createRemainingTimeString(numberOfSeconds: Int) -> String {
        var tempSecs = numberOfSeconds
        let hours = numberOfSeconds / 3600
        tempSecs -= hours * 3600
        let mins = tempSecs / 60
        tempSecs -= mins * 60
        var str = ""
        str += hours < 10 ? "0\(hours):" : "\(hours):"
        str += mins < 10 ? "0\(mins):" : "\(mins):"
        str += tempSecs < 10 ? "0\(tempSecs)" : "\(tempSecs)"
        return str
    }
    
    private var time: String {
        get {
            return remainingTime.text!
        }
        set {
            remainingTime.text = newValue
        }
    }
    
    // Parses String and turns it into the number of seconds remaining
    private func secondsLeft(time: String) -> Int? {
        let parsedTime = time.components(separatedBy: ":")
        if parsedTime.count == 3
        {
            if let hours = Int(parsedTime[0]), let mins = Int(parsedTime[1]), let secs = Int(parsedTime[2])
            {
                return hours * 3600 + mins * 60 + secs
            } else { return nil }
        } else {
            return nil
        }
        
    }
    
    func setTimer(hours: Double) {
        seconds = Int(hours * 3600)
    }
    
    func updateTimer() -> Int {
        if seconds > 0 {
            seconds -= 1
        }
        
        return seconds
    }
    
    func setTimeLabel(withMessage message: String) {
        time = message 
    }
    
    
}
