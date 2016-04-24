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
    var fixedCost: Float
    var variableCostWithFuel: Float
    var transmissionInvestment: Float
    
    init(fuelType: String, levelizedCapitalCost: Float, fixedCost: Float, variableCostWithFuel: Float, transmissionInvestment: Float) {
        self.fuelType = fuelType
        self.levelizedCapitalCost = levelizedCapitalCost
        self.fixedCost = fixedCost
        self.variableCostWithFuel = variableCostWithFuel
        self.transmissionInvestment = transmissionInvestment
    }
    
    func totalCost() -> Int {
        return Int(levelizedCapitalCost + fixedCost + variableCostWithFuel + transmissionInvestment)
    }
    
    func getLabel() -> String {
        return "\(fuelType): $\(self.totalCost()) / MWh"
    }
}

// Wind
var wind = Fuel(fuelType: "Wind", levelizedCapitalCost: 58, fixedCost: 13, variableCostWithFuel: 0, transmissionInvestment: 3)

// Solar PV
var solar = Fuel(fuelType: "Solar PV", levelizedCapitalCost: 110, fixedCost: 11, variableCostWithFuel: 0, transmissionInvestment: 4)

// Hydroelectric
var hydro = Fuel(fuelType: "Hydro", levelizedCapitalCost: 71, fixedCost: 4, variableCostWithFuel: 7, transmissionInvestment: 2)

// Conventional Coal
var coal = Fuel(fuelType: "Coal", levelizedCapitalCost: 60, fixedCost: 4, variableCostWithFuel: 29, transmissionInvestment: 1)

// Natural Gas-fired Conventional Combined Cycle
var gas = Fuel(fuelType: "Natural Gas", levelizedCapitalCost: 14, fixedCost: 2, variableCostWithFuel: 57, transmissionInvestment: 1)
// 1 megawatt hours = 3.41214 mcf (thousand cubic feet) of natural gas
let mcfToMwh = Float(1/3.41214)

// Conventional Combustion Turbine
var oil = Fuel(fuelType: "Oil", levelizedCapitalCost: 41, fixedCost: 3, variableCostWithFuel: 45, transmissionInvestment: 4)
// 1 boe = 1.6282 Mwh
let bblToMwh = Float(1.6282)

// Advanced Nuclear
var nuclear = Fuel(fuelType: "Nuclear", levelizedCapitalCost: 70, fixedCost: 12, variableCostWithFuel: 12, transmissionInvestment: 1)

// Biomass
var biomass = Fuel(fuelType: "Biomass", levelizedCapitalCost: 47, fixedCost: 14, variableCostWithFuel: 38, transmissionInvestment: 1)