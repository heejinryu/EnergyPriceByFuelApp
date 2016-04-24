//
//  barView.swift
//  EnergyPricesByFuel
//
//  Created by Mei Tao on 4/23/16.
//  Copyright © 2016 HEEJIN RYU. All rights reserved.
//

import UIKit

class BarView: UIView {
    var gradient = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gradient.colors = [UIColor.whiteColor().CGColor, UIColor(red: 0.56470588, green: 0.83137255, blue: 0.58431373, alpha: 1.0).CGColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = frame
        gradient.cornerRadius = 5
        self.layer.addSublayer(gradient)
    }
    
    override func layoutSubviews() {
        gradient.frame = self.bounds
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
