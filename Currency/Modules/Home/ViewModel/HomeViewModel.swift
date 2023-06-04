//
//  HomeViewModel.swift
//  Currency
//
//  Created by gamal oraby on 31/05/2023.
//

import Foundation
import RxSwift
import RxRelay


class HomeViewModel {
    
    private let userDefaults = UserDefaults.standard
    var currencyCodesList = BehaviorRelay<[String]>(value: [])
    var ratesList = BehaviorRelay<[Double]>(value: [])
    var fromCurencyValue = BehaviorRelay<String>(value: "")
    var fromCurencyText = BehaviorRelay<String>(value: "")
    var toCurencyValue = BehaviorRelay<String>(value: "")
    var toCurencyValueText = BehaviorRelay<String>(value: "")
    private let api: MainAPiProtocol = RatesAPI()
    private var currencyCodsKey = "currencyCods"
    private var ratesKey = "ratesKey"
    private var entityName = "Rate"
    private var fromCurrencyIndex = 0
    private var toCurrencyIndex = 0
    private var initialAmount = 1.0
    private var toCurrencyValue = "1"
    private var fromCurrencyValue = "1"
    private let currencyManager: ConvertCurrencyManagerProtocol?
    private let manager = DataManager()
    init(currencyManager: ConvertCurrencyManagerProtocol? = CurrencyManager()) {
        self.currencyManager = currencyManager
    }
    
    func numberOfComponents() -> Int {
        return 1
    }
    
    func numberOfRowsInComponent() -> Int {
        return currencyCodesList.value.count
    }
    
    func titleForRow(row: Int) -> String {
        return currencyCodesList.value[row]
    }
    
    func selectedFromCurrencyIndex(index: Int) {
        self.fromCurrencyIndex = index
    }
    
    func selectedToCurrencyIndex(index: Int) {
        self.toCurrencyIndex = index
    }
    
    func fromCurrencyValue(value: String) {
        self.fromCurrencyValue = value
    }
    
    func toCurrencyValue(value: String) {
        self.toCurrencyValue = value
    }
    
    func getDayDate() -> String {
        let date = Date.now
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    func switchCurancy(from value : String, to: String) {
        exchangeCodes { [weak self] (toIndex, fromIndex) in
            self?.selectedToCurrencyIndex(index: toIndex)
            self?.selectedFromCurrencyIndex(index: fromIndex)
            self?.fromCurencyText.accept(self?.titleForRow(row: fromIndex) ?? "")
            self?.toCurencyValueText.accept(self?.titleForRow(row: toIndex) ?? "")
        }
            self.fromCurencyValue.accept(to)
            self.toCurencyValue.accept(value)
    }
    
    func getConvertedAmount(amount: String?, completion: @escaping (Double) -> Void ) {
        if let enterdAmount = amount {
            guard let convertedAmount = Double(enterdAmount) else {return}
            self.initialAmount = convertedAmount
            var value = currencyManager?.getConvertedValue(fromRate: ratesList.value[fromCurrencyIndex], toRate: ratesList.value[toCurrencyIndex] , amount: convertedAmount)
            value = Double(round(1000 * (value ?? 0)) / 1000)
            completion(value ?? 0)
            manager.createEntity(entityName: entityName, rate: CurencyRate(currencyFromCode: currencyCodesList.value[fromCurrencyIndex] , currencyToCode: currencyCodesList.value[toCurrencyIndex] , day: getDayDate(), amount: value ?? 0 , enterdAmount: convertedAmount, currencyFromRate: ratesList.value[fromCurrencyIndex]))
        } else {
            var value = currencyManager?.getConvertedValue(fromRate: ratesList.value[fromCurrencyIndex], toRate: ratesList.value[toCurrencyIndex], amount: initialAmount)
            value = Double(round(1000 * (value ?? 0)) / 1000)
            completion(value ?? 0)
            manager.createEntity(entityName: entityName, rate: CurencyRate(currencyFromCode: currencyCodesList.value[fromCurrencyIndex], currencyToCode: currencyCodesList.value[toCurrencyIndex], day: getDayDate(), amount: value ?? 0, enterdAmount: initialAmount, currencyFromRate:  ratesList.value[fromCurrencyIndex]))
        }
        
    }
    
    func exchangeCodes(completion: @escaping (Int,Int) -> Void) {
        completion(fromCurrencyIndex, toCurrencyIndex)
    }
    
    func getCurrencyCodes() {
        if let ratesCurrencyKeys = userDefaults.array(forKey: currencyCodsKey) as? [String], let currencyRatesList = userDefaults.array(forKey: ratesKey) as? [Double]{
            self.currencyCodesList.accept(ratesCurrencyKeys)
            self.ratesList.accept(currencyRatesList)

        } else {
            api.getRates { (result, error) in
                guard let returnedList = result?.rates else {return}
                let ratesCurrencyKeys = Array(returnedList.keys)
                let ratesListValues = Array(returnedList.values)
                self.userDefaults.set(ratesCurrencyKeys, forKey: self.currencyCodsKey)
                self.userDefaults.set(ratesListValues, forKey: self.ratesKey)
                self.currencyCodesList.accept(ratesCurrencyKeys)
                self.ratesList.accept(ratesListValues)
            }
        }
    }
}
