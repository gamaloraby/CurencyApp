//
//  DetailsModel.swift
//  Currency
//
//  Created by gamal oraby on 01/06/2023.
//

import Foundation

struct CurencyRate {
    let currencyFromCode: String
    let currencyToCode: String
    let day: Int
    let amount: Double
    let enterdAmount: Double
    let currencyFromRate: Double
}

struct CurrencyCellModel {
    let currencyCodeFrom: String
    let currencyValueFrom: String
    let currencyCodeTo: String
    let currencyValueTo: String
}
