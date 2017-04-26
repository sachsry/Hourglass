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
    
    public var complete = false { didSet { setNeedsDisplay() } }
    
    
    private func hourGlassPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: widthOffset, y: heightOffset))
        path.addLine(to: CGPoint(x: bounds.size.width - widthOffset, y: bounds.size.height - heightOffset))
        path.addLine(to: CGPoint(x: widthOffset, y: bounds.size.height - heightOffset))
        path.addLine(to: CGPoint(x: bounds.size.width - widthOffset, y: heightOffset))
        path.close()
        path.lineWidth = 4.0
        return path
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        UIColor.darkGray.set()
        if complete {
            UIColor.red.setFill()
        } else {
            UIColor.gray.setFill()
        }
        let path = hourGlassPath()
        path.stroke()
        path.fill()
    }
    

}
