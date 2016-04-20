//
//  EnergyPrice.swift
//  EnergyPricesByFuel
//
//  Created by HEEJIN RYU, MEI TAO on 4/16/16.
//  Copyright © 2016 HEEJIN RYU & MEI TAO. All rights reserved.
//

import Foundation

class Fuel {
    let fuelType: String
    var levelizedCapitalCost: Int
    var fixedCost: Int
    var variableCostWithFuel: Int
    var transmissionInvestment: Int
    
    init(fuelType: String, levelizedCapitalCost: Int, fixedCost: Int, variableCostWithFuel: Int, transmissionInvestment: Int) {
        self.fuelType = fuelType
        self.levelizedCapitalCost = levelizedCapitalCost
        self.fixedCost = fixedCost
        self.variableCostWithFuel = variableCostWithFuel
        self.transmissionInvestment = transmissionInvestment
    }
    
    func totalCost() -> Int {
        return levelizedCapitalCost + fixedCost + variableCostWithFuel + transmissionInvestment
    }
}

// data source: https://www.eia.gov/forecasts/aeo/pdf/electricity_generation.pdf


//Wind
let wind = Fuel(fuelType: "Wind", levelizedCapitalCost: 58, fixedCost: 13, variableCostWithFuel: 0, transmissionInvestment: 3)

//Solar PV
let solar = Fuel(fuelType: "Solar", levelizedCapitalCost: 110, fixedCost: 11, variableCostWithFuel: 0, transmissionInvestment: 4)

//Hydroelectric
let hydro = Fuel(fuelType: "Hydro", levelizedCapitalCost: 71, fixedCost: 4, variableCostWithFuel: 7, transmissionInvestment: 2)

// Conventional Coal
let coal = Fuel(fuelType: "Coal", levelizedCapitalCost: 60, fixedCost: 4, variableCostWithFuel: 29, transmissionInvestment: 1)

// Natural Gas-fired Conventional Combined Cycle
let gas = Fuel(fuelType: "Gas", levelizedCapitalCost: 14, fixedCost: 2, variableCostWithFuel: 58, transmissionInvestment: 1)

// Conventional Combustion Turbine
let oil = Fuel(fuelType: "Oil", levelizedCapitalCost: 41, fixedCost: 3, variableCostWithFuel: 95, transmissionInvestment: 4)

// Advanced Nuclear
let nuclear = Fuel(fuelType: "Nuclear", levelizedCapitalCost: 70, fixedCost: 12, variableCostWithFuel: 12, transmissionInvestment: 1)

// Biomass
let biomass = Fuel(fuelType: "Biomass", levelizedCapitalCost: 47, fixedCost: 14, variableCostWithFuel: 38, transmissionInvestment: 1)




