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
    var levelizedCapitalCost: Float
    var fixedOMCost: Float
    var variableCostWithFuel: Float
    var transmissionInvestment: Float
    
    init(fuelType: String, levelizedCapitalCost: Float, fixedOMCost: Float, variableCostWithFuel: Float, transmissionInvestment: Float) {
        self.fuelType = fuelType
        self.levelizedCapitalCost = levelizedCapitalCost
        self.fixedOMCost = fixedOMCost
        self.variableCostWithFuel = variableCostWithFuel
        self.transmissionInvestment = transmissionInvestment
    }
    
    func totalCost() -> Int {
        return Int(levelizedCapitalCost + fixedOMCost + variableCostWithFuel + transmissionInvestment)
    }
    
    func getLabel() -> String {
        return "\(fuelType): $\(self.totalCost()) / MWh"
    }
}

// Wind
var wind = Fuel(fuelType: "Wind", levelizedCapitalCost: 58, fixedOMCost: 13, variableCostWithFuel: 0, transmissionInvestment: 3)

// Solar PV
var solar = Fuel(fuelType: "Solar PV", levelizedCapitalCost: 110, fixedOMCost: 11, variableCostWithFuel: 0, transmissionInvestment: 4)

// Hydroelectric
var hydro = Fuel(fuelType: "Hydro", levelizedCapitalCost: 71, fixedOMCost: 4, variableCostWithFuel: 7, transmissionInvestment: 2)

// Conventional Coal
var coal = Fuel(fuelType: "Coal", levelizedCapitalCost: 60, fixedOMCost: 4, variableCostWithFuel: 29, transmissionInvestment: 1)

// Natural Gas-fired Conventional Combined Cycle
var gas = Fuel(fuelType: "Natural Gas", levelizedCapitalCost: 14, fixedOMCost: 2, variableCostWithFuel: 57, transmissionInvestment: 1)

// Conventional Combustion Turbine
var oil = Fuel(fuelType: "Oil", levelizedCapitalCost: 41, fixedOMCost: 3, variableCostWithFuel: 45, transmissionInvestment: 4)

// Advanced Nuclear
var nuclear = Fuel(fuelType: "Nuclear", levelizedCapitalCost: 70, fixedOMCost: 12, variableCostWithFuel: 12, transmissionInvestment: 1)

// Biomass
var biomass = Fuel(fuelType: "Biomass", levelizedCapitalCost: 47, fixedOMCost: 14, variableCostWithFuel: 38, transmissionInvestment: 1)