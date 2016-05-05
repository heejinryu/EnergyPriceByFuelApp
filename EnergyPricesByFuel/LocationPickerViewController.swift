//
//  LocationPickerViewController.swift
//  EnergyPricesByFuel
//
//  Created by HEEJIN RYU, MEI TAO on 4/16/16.
//  Copyright © 2016 HEEJIN RYU & MEI TAO. All rights reserved.
//

import UIKit
import CoreLocation

var locations = [[String:String]]()

class LocationPickerViewController: UITableViewController, CLLocationManagerDelegate {
    let defaults = NSUserDefaults.standardUserDefaults()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        // load the states as an array of dicts from the plist "states"
        let plistPath = NSBundle.mainBundle().pathForResource("States", ofType: "plist")
        if let path = plistPath, let states = NSArray(contentsOfFile: path) {
            let s = states as! [NSDictionary]
            for state in s {
                locations.append(state as! [String: String])
            }
            // print(locations[1]["fullname"])
        }
    }
    
    @IBAction func getCurrentLocation(sender: UIButton) {
        solar = solarDefault
        
        // request permission for user location acess the first time
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        CLGeocoder().reverseGeocodeLocation(newLocation) { (results, error) in
            if let error = error {
                print(error)
                return
            }
            
            // parse Apple location data to return the state code and store in userdefaults
            if results?.count > 0 {
                let place = results![0]
                let code = place.administrativeArea
                self.defaults.setValue(code, forKey: "userlocation")
                print("We found you at \(place.thoroughfare) \(code)")
                self.locationManager.stopUpdatingLocation()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    // load each location from array "locations" to the table view
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath)
        cell.textLabel?.text = locations[indexPath.row]["fullname"]
        cell.backgroundColor = UIColor(red: 0.09019608, green: 0.03137255, blue: 0.18431373, alpha: 1.0)
        cell.textLabel?.textColor = UIColor.whiteColor()

        return cell
    }
    
    // save selected location to UseDefaults backend
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defaults.setValue(locations[indexPath.row]["code"], forKey: "userlocation")
        // update solar cost with chosen location code
        dismissViewControllerAnimated(true, completion: nil)
    }

}
