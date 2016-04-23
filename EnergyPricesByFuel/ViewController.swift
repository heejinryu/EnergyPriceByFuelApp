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

class ViewController: UIViewController, GraphDelegate, NetworkHelperDelegate {

    @IBOutlet weak var graph: GraphView!
    
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
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let location = defaults.stringForKey("userlocation") {
            networkHelper.loadGasPriceForState(location)
            userLocation = location
        } else {
            //present location picker
        }
        print(userLocation)
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
    
//  Mei - I force upwrapped energyPrices.maxElement() as it should always have max value.  but we can change that if you'd like. 
    
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
        return 50
    }
    
    func getLabelForGraphView(graphView: GraphView, atIndex index: Int) -> String {
        let fuelForIndex = fuel[index]
        return fuelForIndex.getLabel()
    }
    
}
