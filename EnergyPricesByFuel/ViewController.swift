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
import Social

class ViewController: UIViewController, GraphDelegate, NetworkHelperDelegate {

    @IBOutlet weak var graph: GraphView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let networkHelper = NetworkHelper()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var fuel = [wind, solar, hydro, coal, gas, oil, nuclear, biomass]
    var userLocation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        networkHelper.loadOilPrice()
        networkHelper.delegate = self
        // load solar price
        
        // load background and title
        view.backgroundColor = UIColor(red: 0.09019608, green: 0.03137255, blue: 0.18431373, alpha: 1.0)
        graph.delegate = self
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        titleLabel.textColor = UIColor(red: 0.56470588, green: 0.83137255, blue: 0.58431373, alpha: 1.0)
        
        // load location button
        let locationButton = UIButton()
        locationButton.setImage(UIImage(named: "Location"), forState: UIControlState.Normal)
        locationButton.addTarget(self, action: "setLocation", forControlEvents: UIControlEvents.TouchUpInside)
        locationButton.frame = CGRectMake(0, 0, 22, 31)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: locationButton)
        
        // Load tweet button
        let tweetButton = UIButton()
        tweetButton.setImage(UIImage(named: "Tweet"), forState: UIControlState.Normal)
        tweetButton.addTarget(self, action: "tweetNow", forControlEvents: UIControlEvents.TouchUpInside)
        tweetButton.frame = CGRectMake(0, 0, 35, 25)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetButton)
        
        loadingIndicator.startAnimating()
        
    }
    
    func setLocation() {
        performSegueWithIdentifier("showLocationPicker", sender: self)
    }
    
    func tweetNow() {
        // share the graph in a tweet and populate default tweet text
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetShare: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            let text = "Current costs of electricity generation in \(userLocation) via coolApp"
            tweetShare.setInitialText(text)
            tweetShare.addImage(screenShotMethod())
            // add screen shot
            self.presentViewController(tweetShare, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func screenShotMethod() -> UIImage {
        //Create a UIImage from a screenshot
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // check if a location is saved to userdefaults
        if let location = defaults.stringForKey("userlocation") {
            // check location, if not in the locations dictionary then load generic gas price
            if locations.contains({ $0.values.contains(location) }) {
                networkHelper.loadGasPriceForState(location)
            } else {
                networkHelper.loadGasPrice()
            }
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
        
        // Replace Solar - TO DO
        updateSolar()
        
        dispatch_async(dispatch_get_main_queue(), {
            self.graph.reloadData()
            self.loadingIndicator.stopAnimating()
        })
    }
    
    func updateSolar() {
        if locations.contains({ $0.values.contains(userLocation) }) {
            solar.levelizedCapitalCost = 60 // change to dynamic
            solar.transmissionInvestment = 0
            solar.variableCostWithFuel = 0
            solar.fixedOMCost = 0
            
            fuel.removeAtIndex(1)
            fuel.insert(solar, atIndex: 1)
        } else {
            solar.levelizedCapitalCost = 60 
            solar.transmissionInvestment = 0
            solar.variableCostWithFuel = 0
            solar.fixedOMCost = 0
            print("solar default")
        }
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
    
    func getIconNameForGraphView(graphView: GraphView, atIndex index: Int) -> String {
        let IconForIndex = fuel[index]
        return IconForIndex.fuelType
    }
    
}
