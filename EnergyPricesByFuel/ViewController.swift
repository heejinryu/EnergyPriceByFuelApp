//
//  ViewController.swift
//  EnergyPricesByFuel
//
//  Created by HEEJIN RYU on 4/16/16.
//  Copyright © 2016 HEEJIN RYU. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GraphDelegate {

    @IBOutlet weak var graph: GraphView!
    
    var energyPrices = [192, 188, 160, 170, 100, 90]
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func maximumValueForGraphView(graphView: GraphView) -> CGFloat? {
        return 200
    }
    
    func valueForBarAtIndexForGraphView(graphView: GraphView, index: Int) -> CGFloat {
        return CGFloat(energyPrices[index])
    }
    
    func spacingInBetweenBars(graphView: GraphView) -> CGFloat {
        return 100
    }
}
