//
//  LocationPickerViewController.swift
//  EnergyPricesByFuel
//
//  Created by MEI TAO on 4/16/16.
//  Copyright © 2016 MEI TAO. All rights reserved.
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
        if locations.count == 0 {
            loadLocations()
        }
    }
    
    func loadLocations() {
        // load the states as an array of dicts from the plist "states"
        let plistPath = NSBundle.mainBundle().pathForResource("States", ofType: "plist")
        if let path = plistPath, let states = NSArray(contentsOfFile: path) {
            let s = states as! [NSDictionary]
            for state in s {
                locations.append(state as! [String: String])
            }
        }
    }
    
    @IBAction func getCurrentLocation(sender: UIButton) {
        // request permission for user location acess the first time
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func closeVC(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        // print(locations.count)
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
        dismissViewControllerAnimated(true, completion: nil)
    }

}
