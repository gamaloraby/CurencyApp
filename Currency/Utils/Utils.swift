//
//  Utils.swift
//  Currency
//
//  Created by gamal oraby on 31/05/2023.
//

import Foundation

class Utils {
    static func getConvertedValue(fromRate: Double, toRate: Double, amount: Double) -> Double {
        let rate = toRate / fromRate
        return rate * amount
    }
}
