//
//  Utils.swift
//  Currency
//
//  Created by gamal oraby on 31/05/2023.
//

import Foundation

protocol ConvertCurrencyManagerProtocol: AnyObject {
    func getConvertedValue(fromRate: Double, toRate: Double, amount: Double) -> Double
}

class CurrencyManager: ConvertCurrencyManagerProtocol {
     func getConvertedValue(fromRate: Double, toRate: Double, amount: Double) -> Double {
        let rate = toRate / fromRate
        return rate * amount
    }
}
