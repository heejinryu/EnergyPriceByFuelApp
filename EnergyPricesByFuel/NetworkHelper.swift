//
//  NetworkHelper.swift
//  EnergyPricesByFuel
//
//  Created by Mei Tao on 4/23/16.
//  Copyright © 2016 HEEJIN RYU, MEI TAO. All rights reserved.
//

import UIKit
import Foundation

protocol NetworkHelperDelegate {
    func didReceiveprices(gas: Fuel, oil: Fuel)
}

class NetworkHelper {
    
    var gasPrice: Float?
    var oilPrice: Float?
    
    var delegate: NetworkHelperDelegate?
    
    var currentBrentLink = String("https://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20yahoo.finance.quote%20WHERE%20symbol%3D%22BZM16.NYM%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=")
    
    var currentHHLink = String("https://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20yahoo.finance.quote%20WHERE%20symbol%3D%22NGK16.NYM%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=")
    
    let eiaLinkBeg = String("https://api.eia.gov/series/?api_key=6495EB74AFCC6C24FFB6500DC2B9AB44&series_id=NG.N3050")
    let eiaLinkEnd = String("3.M")
    
    func loadOilPrice() {
        // Get Yahoo Finance data for Brent with a query link
        let url = NSURL(string: currentBrentLink)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
            guard let data = data else {
                return
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
                self.oilPrice = self.parseYFPriceWithJSON(json)
                self.checkPricesAvailability()
            } catch {
                print("could not read json")
            }
        }
        task.resume()
    }
    
    func loadGasPrice() {
        // Get Yahoo Finance data for Henry Hub with a query link
        let url = NSURL(string: currentHHLink)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
            guard let data = data else {
                return
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
                self.gasPrice = self.parseYFPriceWithJSON(json)
                print("gas price is \(self.gasPrice)")
                self.checkPricesAvailability()
            } catch {
                print("could not read json")
            }
        }
        task.resume()
    }
    
    func loadGasPriceForState(state: String) {
        // Pass on state code to get link and get EIA gas price for the chosen location
        let link = eiaLinkBeg + state + eiaLinkEnd
        let url = NSURL(string: link)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
            guard let data = data else {
                return
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
                if self.parseEIAGasPriceWithJSON(json) == nil {
                    self.loadGasPrice()
                } else {
                    self.gasPrice = self.parseEIAGasPriceWithJSON(json)
                    print("gas price is \(self.gasPrice)")
                    self.checkPricesAvailability()
                }
            } catch {
                print("could not read json")
            }
        }
        task.resume()
    }
    
    func checkPricesAvailability() {
        if let gasPrice = gasPrice, oilPrice = oilPrice {
            oil.variableCostWithFuel = oilPrice / bblToMwh
            gas.variableCostWithFuel = gasPrice / mcfToMwh
            
            delegate?.didReceiveprices(gas, oil: oil)
        }
    }
    
    func parseYFPriceWithJSON(data: NSDictionary) -> Float? {
        // parse Yahoo finance data and return a Brent or Henry Hub price
        guard let query = data["query"] as? NSDictionary,
            let results = query["results"] as? NSDictionary,
            let quote = results["quote"] as? NSDictionary,
            let lastPrice = quote["LastTradePriceOnly"] as? String else{
                return nil
        }
        // print(lastPrice)
        return Float(lastPrice)
    }
    
    func parseEIAGasPriceWithJSON(data: NSDictionary) -> Float? {
        // parse EIA data and return
        guard let series = data["series"] as? NSArray,
            let seriesContent = series[0] as? NSDictionary,
            let priceData = seriesContent["data"] as? NSArray,
            let latestData = priceData[0] as? NSArray,
            let latestGasPrice = latestData[1] as? Float
            else {
                return nil
        }
        // print(latestGasPrice)
        return latestGasPrice
    }
    
    // data source: https://www.eia.gov/forecasts/aeo/pdf/electricity_generation.pdf
    

}


