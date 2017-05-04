//
//  HourGlassLogoView.swift
//  Hourglass
//
//  Created by Ryan Sachs on 1/18/17.
//  Copyright © 2017 Ryan Sachs. All rights reserved.
//

import UIKit

@IBDesignable
class HourGlassLogoView: UIView {
    
    @IBInspectable
    private var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
    
    private var heightOffset: CGFloat {
        get {
            return bounds.size.height - (bounds.size.height * scale)
        }
    }
    
    private var widthOffset: CGFloat {
        get {
            return bounds.size.width - (bounds.size.width * scale)
        }
    }
    
    private var width: CGFloat {
        get {
            return bounds.size.width - (2 * widthOffset)
        }
    }
    
    private var height: CGFloat {
        get {
            return bounds.size.width - (2 * widthOffset)
        }
    }
    
    public var complete = false { didSet { setNeedsDisplay() } }
    
    public var sandEarned: CGFloat = 0.5 { didSet { setNeedsDisplay() } }
    
    
    private func hourGlassPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: widthOffset, y: heightOffset))
        path.addLine(to: CGPoint(x: widthOffset + width, y: heightOffset + height))
        path.addLine(to: CGPoint(x: widthOffset, y: heightOffset + height))
        path.addLine(to: CGPoint(x: widthOffset + width, y: heightOffset))
        path.close()
        path.lineWidth = 4.0
        return path
    }
    
    private func pointsRemainingHourGlassPath(fraction: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: widthOffset + width * fraction, y: heightOffset + height * fraction))
        path.addLine(to: CGPoint(x: widthOffset + width / 2, y: heightOffset + height / 2))
        path.addLine(to: CGPoint(x: widthOffset + width / 2, y: heightOffset + height / 2))
        path.addLine(to: CGPoint(x: widthOffset + width * (1 - fraction), y: heightOffset + height * fraction))
        path.close()
        path.lineWidth = 4.0
        return path
    }
    
    private func pointsEarnedHourGlassPath(fraction: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: widthOffset, y: heightOffset + height))
        path.addLine(to: CGPoint(x: widthOffset + width * fraction, y: heightOffset + height - height * fraction))
        path.addLine(to: CGPoint(x: widthOffset + width * (1 - fraction), y: heightOffset + height - height * fraction))
        path.addLine(to: CGPoint(x: widthOffset + width, y: heightOffset + height))
        path.close()
        path.lineWidth = 4.0
        return path
    }

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        UIColor.darkGray.set()
        if sandEarned == 1 {
            let path = hourGlassPath()
            UIColor.red.setFill()
            path.stroke()
            path.fill()
        } else {
            let path = hourGlassPath()
            UIColor.white.setFill()
            path.stroke()
            path.fill()
            
            let sandLeftPath = pointsRemainingHourGlassPath(fraction: sandEarned / 2)
            let sandEarnedPath = pointsEarnedHourGlassPath(fraction: sandEarned / 2)
            UIColor.gray.setFill()
            sandLeftPath.stroke()
            sandLeftPath.fill()
            sandEarnedPath.stroke()
            sandEarnedPath.fill()
            
        }
//        let path = hourGlassPath()
//        UIColor.gray.setFill()
//        path.stroke()
//        path.fill()
//        
//        UIColor.red.setFill()
//        let fillPath = pointsRemainingHourGlassPath(fraction: 0.2)
//        fillPath.stroke()
//        fillPath.fill()
        
        
    }
    

}
