//
//  LocationPickerViewController.swift
//  EnergyPricesByFuel
//
//  Created by HEEJIN RYU, MEI TAO on 4/16/16.
//  Copyright © 2016 HEEJIN RYU & MEI TAO. All rights reserved.
//

import UIKit
import CoreLocation

class LocationPickerViewController: UITableViewController, CLLocationManagerDelegate {
    let defaults = NSUserDefaults.standardUserDefaults()
    let locationManager = CLLocationManager()
    var locations = [[String:String]]()
    
    @IBAction func getCurrentLocation(sender: UIButton) {
        // request permission for user location acess the first time
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        CLGeocoder().reverseGeocodeLocation(newLocation) { (results, error) in
            if let error = error {
                print(error)
                return
            }
            
            for placemark in results! {
                print("\(placemark) \n\n ------------")
            }
            
            if results?.count > 0 {
                let place = results![0]
                print("We found you at \(place.thoroughfare) \(place.locality)")
                self.locationManager.stopUpdatingLocation()
            }
        }
        
    }
    
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
        dismissViewControllerAnimated(true, completion: nil)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
