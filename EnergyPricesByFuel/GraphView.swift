//
//  GraphView.swift
//  EnergyPricesByFuel
//
//  Created by HEEJIN RYU, MEI TAO on 4/16/16.
//  Copyright © 2016 HEEJIN RYU & MEI TAO. All rights reserved.
//

import UIKit
import SnapKit
import pop

protocol GraphDelegate {
    func numberOfBarsInGraphView(graphView: GraphView) -> Int
    func maximumValueForGraphView(graphView: GraphView) -> CGFloat?
    func valueForBarAtIndexForGraphView(graphView: GraphView, index: Int) -> CGFloat
    func spacingInBetweenBars(graphView: GraphView) -> CGFloat
    func getLabelForGraphView(graphView: GraphView, atIndex index: Int) -> String
    func getIconNameForGraphView(graphView: GraphView, atIndex index: Int) -> String
}

class GraphView: UIView {
    var delegate: GraphDelegate?
    var isInitialized = false
    private var debug = true
    private var bars = [UIView]()
    private var widthConstraints = [NSLayoutConstraint]()
    private var numberOfBars = 0
    private var iconSpace = CGFloat(40)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Reset our storyboard background color
        backgroundColor = debug ? backgroundColor : UIColor.clearColor()
    }
    
    func reloadData() {
        // Check if we have a delegate, otherwise we don't have data
        guard let _ = delegate else {
            fatalError("Please implement the GraphDelegate")
        }
        
        numberOfBars = delegate!.numberOfBarsInGraphView(self)
        
        // Create the bars
        createBars()
        // showAbsoluteBars()
        showRelativeBars()
    }
    
    private func createBars() {
        // Clear out possible old bars
        removeSubViews()
        
        // Reset bars array
        bars.removeAll()
        widthConstraints.removeAll()
        
        let spaceInBetween = delegate!.spacingInBetweenBars(self)
        
        // The available height for drawing minus the space in between minus one
        let sumHeight = self.frame.height - CGFloat(CGFloat(numberOfBars - 1) * spaceInBetween)
        let heightOffset = 1 / CGFloat(numberOfBars)
        let barHeight = sumHeight * heightOffset
        
        var previousBar: UIView?
        for i in 0 ..< numberOfBars {
            
            // Generate a new bar
            let bar = BarView()
            addSubview(bar)
            
            // add a label
            let label = UILabel(frame: CGRectMake(0, barHeight - 8, 250, 50))
            label.textAlignment = NSTextAlignment.Left
            label.text = delegate!.getLabelForGraphView(self, atIndex: i)
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 13)
            label.textColor = UIColor.whiteColor()
            bar.addSubview(label)
            
            // add a icon
            let iconName = delegate!.getIconNameForGraphView(self, atIndex: i)
            let imageView = UIImageView(frame: CGRectMake(-iconSpace-5, 15, iconSpace - 10, barHeight - 10))
            imageView.contentMode = .ScaleAspectFill
            imageView.image = UIImage(named: iconName)
            bar.addSubview(imageView)
            
            // Set bar constraints
            bar.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(self).offset(iconSpace)
                make.height.equalTo(barHeight)
                
                if let previousBar = previousBar {
                    make.top.equalTo(previousBar.snp_bottom).offset(spaceInBetween)
                } else {
                    make.top.equalTo(0)
                }
            })
            
            // Add a width constraint
            let widthConstraint = NSLayoutConstraint(item: bar, attribute: .Width,
                                                     relatedBy: .Equal,
                                                     toItem: nil, attribute: .Width,
                                                     multiplier: 1.0, constant: 0)
            addConstraint(widthConstraint)
            widthConstraints.append(widthConstraint)
            
            // Keep track of state
            previousBar = bar
            bars.append(bar)
        }
    }

    private func showRelativeBars() {
        var delay = 0.0
        
        let drawWidth = self.frame.width - iconSpace
        var maxValue = CGFloat(0)
        
        // Determine what the maxValue in the graph is
        // If the delegate doesn't specify one it's just the highest number in the array
        // If it does; we check if it's not less than the maximum value in the array and we set it to that
        if let maxWidth = delegate?.maximumValueForGraphView(self) {
            if maxWidth > maximumValueInDataSet() {
                maxValue = maxWidth
            } else {
                maxValue = maximumValueInDataSet()
            }
        } else {
            maxValue = maximumValueInDataSet()
        }
        
        for (index, constraint) in widthConstraints.enumerate() {
            let valueForIndex = delegate!.valueForBarAtIndexForGraphView(self, index: index)
            let percentage = valueForIndex / maxValue
            // print(percentage)
            
            let width = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
            width.toValue = drawWidth*percentage
            width.springSpeed = 4
            width.springBounciness = 7
            width.beginTime =  (CACurrentMediaTime() + delay)
            constraint.pop_addAnimation(width, forKey: "bar-\(index).width")
            
            delay += 0.2
        }
    }

    private func showAbsoluteBars() {
        var delay = 0.0
        
        // Width Constraints
        for (index, constraint) in widthConstraints.enumerate() {
            // Get the width for the current bar
            let valueForIndex = delegate!.valueForBarAtIndexForGraphView(self, index: index)
            
            let width = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
            width.toValue = valueForIndex
            width.springSpeed = 4
            width.springBounciness = 7
            width.beginTime =  (CACurrentMediaTime() + delay)
            constraint.pop_addAnimation(width, forKey: "bar-\(index).width")
            
            delay += 0.2
        }
    }

    func removeSubViews() {
        for view in bars {
            view.removeFromSuperview()
        }
    }
    
    private func maximumValueInDataSet() -> CGFloat {
        var max = CGFloat(0)
        for i in 0..<numberOfBars {
            let valueForIndex = delegate!.valueForBarAtIndexForGraphView(self, index: i)
            if valueForIndex > max {
                max = valueForIndex
            }
        }
        
        return max
    }
}