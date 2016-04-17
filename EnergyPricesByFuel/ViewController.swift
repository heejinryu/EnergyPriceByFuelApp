//
//  ViewController.swift
//  EnergyPricesByFuel
//
//  Created by HEEJIN RYU on 4/16/16.
//  Copyright © 2016 HEEJIN RYU. All rights reserved.
//

import UIKit
import SnapKit
import pop

class ViewController: UIViewController, GraphDelegate {

    @IBOutlet weak var graph: GraphView!

    var energyPrices = [wind.totalCost(), solar.totalCost(), hydro.totalCost(), coal.totalCost(), gas.totalCost(), oil.totalCost(), nuclear.totalCost(), biomass.totalCost()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//  Mei - You can change the background color here to black if you'd like.
        
        view.backgroundColor = UIColor(red: 0.733, green: 0.82, blue: 0, alpha: 1.0)
        graph.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !graph.isInitialized {
            graph.reloadData()
        }
    }
    
    // MARK: GraphView Delegate
    func numberOfBarsInGraphView(graphView: GraphView) -> Int {
        return energyPrices.count
    }
    
//  Mei - I force upwrapped energyPrices.maxElement() as it should always have max value.  but we can change that if you'd like. 
    
    func maximumValueForGraphView(graphView: GraphView) -> CGFloat? {
        return CGFloat(energyPrices.maxElement()!)
    }
    
    func valueForBarAtIndexForGraphView(graphView: GraphView, index: Int) -> CGFloat {
        return CGFloat(energyPrices[index])
    }
    
    func spacingInBetweenBars(graphView: GraphView) -> CGFloat {
        return 60
    }
    
}
