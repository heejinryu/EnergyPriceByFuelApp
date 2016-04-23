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
        return "\(fuelType): $\(self.totalCost()) /MWh"
    }
}


