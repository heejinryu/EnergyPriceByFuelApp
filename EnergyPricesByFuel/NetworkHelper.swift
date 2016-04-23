//
//  NetworkHelper.swift
//  EnergyPricesByFuel
//
//  Created by Mei Tao on 4/23/16.
//  Copyright © 2016 HEEJIN RYU, MEI TAO. All rights reserved.
//

import UIKit

protocol NetworkHelperDelegate {
    func didReceiveprices(gas: Fuel, oil: Fuel)
}

class NetworkHelper {
    
    var gasPrice: Float?
    var oilPrice: Float?
    
    var delegate: NetworkHelperDelegate?
    
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
                self.gasPrice = self.parseEIAGasPriceWithJSON(json)
                self.checkPricesAvailability()
            } catch {
                print("could not read json")
            }
        }
        task.resume()
    }
    
    func checkPricesAvailability() {
        if let gasPrice = gasPrice, oilPrice = oilPrice {
            oil.variableCostWithFuel = oilPrice
            gas.variableCostWithFuel = gasPrice
            
            delegate?.didReceiveprices(gas, oil: oil)
        }
    }
    
    var currentBrentLink = String("https://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20yahoo.finance.quote%20WHERE%20symbol%3D%22BZM16.NYM%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=")
    
    var currentHHLink = String("https://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20yahoo.finance.quote%20WHERE%20symbol%3D%22NGK16.NYM%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=")
    
    let eiaLinkBeg = String("https://api.eia.gov/series/?api_key=6495EB74AFCC6C24FFB6500DC2B9AB44&series_id=NG.N3050")
    let eiaLinkEnd = String("3.M")
    
    
    func parseYFPriceWithJSON(data: NSDictionary) -> Float? {
        // parse Yahoo finance data and return a Brent or Henry Hub price
        guard let query = data["query"] as? NSDictionary,
            let results = query["results"] as? NSDictionary,
            let quote = results["quote"] as? NSDictionary,
            let lastPrice = quote["LastTradePriceOnly"] as? String else{
                return nil
        }
        print(lastPrice)
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
        print(latestGasPrice)
        return latestGasPrice
    }
    
    // data source: https://www.eia.gov/forecasts/aeo/pdf/electricity_generation.pdf
    

}

//Wind
var wind = Fuel(fuelType: "Wind", levelizedCapitalCost: 58, fixedCost: 13, variableCostWithFuel: 0, transmissionInvestment: 3)

//Solar PV
var solar = Fuel(fuelType: "Solar", levelizedCapitalCost: 110, fixedCost: 11, variableCostWithFuel: 0, transmissionInvestment: 4)

//Hydroelectric
var hydro = Fuel(fuelType: "Hydro", levelizedCapitalCost: 71, fixedCost: 4, variableCostWithFuel: 7, transmissionInvestment: 2)

// Conventional Coal
var coal = Fuel(fuelType: "Coal", levelizedCapitalCost: 60, fixedCost: 4, variableCostWithFuel: 29, transmissionInvestment: 1)

// Natural Gas-fired Conventional Combined Cycle
// 1 megawatt hours = 3.41214 mcf (thousand cubic feet) of natural gas
var gas = Fuel(fuelType: "Gas", levelizedCapitalCost: 14, fixedCost: 2, variableCostWithFuel: 57, transmissionInvestment: 1)

// Conventional Combustion Turbine
var oil = Fuel(fuelType: "Oil", levelizedCapitalCost: 41, fixedCost: 3, variableCostWithFuel: 45, transmissionInvestment: 4)

// Advanced Nuclear
var nuclear = Fuel(fuelType: "Nuclear", levelizedCapitalCost: 70, fixedCost: 12, variableCostWithFuel: 12, transmissionInvestment: 1)

// Biomass
var biomass = Fuel(fuelType: "Biomass", levelizedCapitalCost: 47, fixedCost: 14, variableCostWithFuel: 38, transmissionInvestment: 1)
