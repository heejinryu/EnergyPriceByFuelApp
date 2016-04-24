//
//  ViewController.swift
//  EnergyPricesByFuel
//
//  Created by HEEJIN RYU, MEI TAO on 4/16/16.
//  Copyright © 2016 HEEJIN RYU & MEI TAO. All rights reserved.
//

import UIKit
import SnapKit
import pop
import Foundation

class ViewController: UIViewController, GraphDelegate, NetworkHelperDelegate {

    @IBOutlet weak var graph: GraphView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let networkHelper = NetworkHelper()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var fuel = [wind, solar, hydro, coal, gas, oil, nuclear, biomass]
    var userLocation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkHelper.loadOilPrice()
        networkHelper.delegate = self

        view.backgroundColor = UIColor(red: 0.09019608, green: 0.03137255, blue: 0.18431373, alpha: 1.0)
        graph.delegate = self
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        titleLabel.textColor = UIColor(red: 0.62352941, green: 0.96470588, blue: 0.25098039, alpha: 1.0)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // check if a location is saved to userdefaults
        if let location = defaults.stringForKey("userlocation") {
            networkHelper.loadGasPriceForState(location)
            userLocation = location
        } else {
            performSegueWithIdentifier("showLocationPicker", sender: self)
        }
        print("location code: \(userLocation)")
    }
    
    func didReceiveprices(gas: Fuel, oil: Fuel) {
        // Replace oil
        fuel.removeAtIndex(5)
        fuel.insert(oil, atIndex: 5)
        
        // Replace gas
        fuel.removeAtIndex(4)
        fuel.insert(gas, atIndex: 4)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.graph.reloadData()
        })
    }
    
    
    // MARK: GraphView Delegate
    func numberOfBarsInGraphView(graphView: GraphView) -> Int {
        return fuel.count
    }
    
    
    func maximumValueForGraphView(graphView: GraphView) -> CGFloat? {
        let costs = fuel.map { fuel in
            return fuel.totalCost()
        }
        
        return CGFloat(costs.maxElement()!)
    }
    
    func valueForBarAtIndexForGraphView(graphView: GraphView, index: Int) -> CGFloat {
        let costForFuel = fuel[index].totalCost()
        return CGFloat(costForFuel)
    }
    
    func spacingInBetweenBars(graphView: GraphView) -> CGFloat {
        return graphView.bounds.size.height * 0.1
    }
    
    func getLabelForGraphView(graphView: GraphView, atIndex index: Int) -> String {
        let fuelForIndex = fuel[index]
        return fuelForIndex.getLabel()
    }
    
}
