//
//  HomeViewModel.swift
//  Currency
//
//  Created by gamal oraby on 31/05/2023.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    private let userDefaults = UserDefaults.standard
    private var currencyCodesList: [String]?
    private var ratesList: [Double]?
    private let api: MainAPiProtocol = UsersAPI()
    private var currencyCodsKey = "currencyCods"
    private var ratesKey = "ratesKey"
    private var fromCurrencyIndex = 0
    private var toCurrencyIndex = 0
    private var initialAmount = 1.0
    private var toCurrencyValue = "1"
    private var fromCurrencyValue = "1"
    
    func numberOfComponents() -> Int {
        return 1
    }
    
    func numberOfRowsInComponent() -> Int {
        return currencyCodesList?.count ?? 0
    }
    
    func titleForRow(row: Int) -> String {
        return currencyCodesList?[row] ?? ""
    }
    
    func selectedFromCurrencyIndex(index: Int) {
        self.fromCurrencyIndex = index
        let value = Utils.getConvertedValue(fromRate: ratesList?[fromCurrencyIndex] ?? 0, toRate: ratesList?[toCurrencyIndex] ?? 0, amount: 1000)
        print("======== ", value)
    }
    
    func selectedToCurrencyIndex(index: Int) {
        self.toCurrencyIndex = index
        let value = Utils.getConvertedValue(fromRate: ratesList?[fromCurrencyIndex] ?? 0, toRate: ratesList?[toCurrencyIndex] ?? 0, amount: initialAmount)
    }
    
    func fromCurrencyValue(value: String) {
        self.fromCurrencyValue = value
    }
    
    func toCurrencyValue(value: String) {
        self.toCurrencyValue = value
    }
    
    func getConvertedAmount(amount: String?, completion: @escaping (Double) -> Void ) {
        if let enterdAmount = amount {
            let convertedAmount = Double(enterdAmount)
            self.initialAmount = convertedAmount ?? 0
            let value = Utils.getConvertedValue(fromRate: ratesList?[fromCurrencyIndex] ?? 0, toRate: ratesList?[toCurrencyIndex] ?? 0, amount: convertedAmount ?? 0)
            completion(value)
        } else {
            let value = Utils.getConvertedValue(fromRate: ratesList?[fromCurrencyIndex] ?? 0, toRate: ratesList?[toCurrencyIndex] ?? 0, amount: initialAmount)
            completion(value)
        }
    }
    
    func exchangeCodes(completion: @escaping (Int,Int) -> Void) {
        completion(fromCurrencyIndex, toCurrencyIndex)
    }
    
    func exchangeValues(completion: @escaping (String,String) -> Void) {
        completion(self.fromCurrencyValue, self.toCurrencyValue)
    }
    
    func getCurrencyCodes() {
        if let ratesCurrencyKeys = userDefaults.array(forKey: currencyCodsKey) as? [String], let currencyRatesList = userDefaults.array(forKey: ratesKey) as? [Double]{
            self.currencyCodesList = ratesCurrencyKeys
            self.ratesList = currencyRatesList
        } else {
            api.getUsers { (result, error) in
                let ratesCurrencyKeys = result?.rates?.keys
                let ratesListValues = result?.rates?.values
                
                if let ratesKeys = ratesCurrencyKeys, let ratesValues = ratesListValues {
                    self.currencyCodesList = [String] (ratesKeys)
                    self.ratesList = [Double] (ratesValues)
                    self.userDefaults.set(self.currencyCodesList, forKey: self.currencyCodsKey)
                    self.userDefaults.set(self.ratesList, forKey: self.ratesKey)
                }
            }
        }
    }
}
