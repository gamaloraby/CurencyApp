//
//  DetailsViewModel.swift
//  Currency
//
//  Created by gamal oraby on 01/06/2023.
//

import Foundation

class DetailsViewModel {
    
    private let userDefaults = UserDefaults.standard
    private let currencyCodsKey = "currencyCods"
    private let ratesKey = "ratesKey"
    private let manager = DataManager()
    private var histoiricalData = [Int64: [Rate]]()
    private var dayes = [Int]()
    private var data = [Rate]()
    private var ratesList = [Double]()
    private var currencyCodesList = [String]()
    private var popularRates = [String : Double]()
    private let popularCurrenciesList = ["USD", "SAR", "EUR", "JPY", "QAR", "GBP" ,"AUD" ,"CAD" ,"CHF" ,"HKD" , "AED"]
    private var popularConvertedAmount = [String]()
    private var keys = [String]()
    private let currencyManager: ConvertCurrencyManagerProtocol?
    
    init(currencyManager: ConvertCurrencyManagerProtocol? = CurrencyManager()) {
        self.currencyManager = currencyManager
    }
    
    func getLastThreeDayesData(completion: @escaping (Dictionary<Int64,[Rate]>) -> Void ) {
        guard let  storedData = manager.fetchData(entityName: "Rate") else {return}
        let dic = Dictionary(grouping: storedData, by: { $0.day })
        self.histoiricalData = dic
        keys = Array(dic.map { "\($0.key)" })
        completion(dic)
    }
    
    func historicalNumberOfSection() -> Int {
        return histoiricalData.count
    }
    
    func historicalNumberOfRows(in section: Int) -> Int {
        return histoiricalData[Int64(keys[section]) ?? 0]?.count ?? 0
    }
    
    func cellDataInRow(in section: Int, row: Int) -> Rate {
        guard let data = histoiricalData[Int64(keys[section]) ?? 0]?[row] else {return Rate()}
        return data
    }
    
    func storedDataDay(section: Int) -> String {
        return "\(histoiricalData[Int64(keys[section]) ?? 0]?[0].day ?? 0)"
    }
    
    func getPopularCurencies(in section: Int, at row: Int) -> [String] {
        if let ratesCurrencyKeys = userDefaults.array(forKey: currencyCodsKey) as? [String], let currencyRatesList = userDefaults.array(forKey: ratesKey) as? [Double]{
                self.currencyCodesList = ratesCurrencyKeys
                self.ratesList = currencyRatesList
            }
        let popularConvertedCurencies = calculatePopularCurncies(section: section, row: row)
        return popularConvertedCurencies
    }
    
    private func calculatePopularCurncies(section: Int, row: Int) -> [String] {
        var count = 0
        var topPopularRates = [String]()
        for (index, currencyCode) in  currencyCodesList.enumerated() {
            if self.popularCurrenciesList.contains(currencyCode) {
                guard let data = histoiricalData[Int64(keys[section]) ?? 0]?[row] else {return[]}
                if self.popularCurrenciesList.contains(data.currencyFromCode ?? "") && currencyCodesList[index] == data.currencyFromCode ?? "" {
                    continue
                } else {
                    if count == 10 {
                       break
                    } else{
                        guard let value = currencyManager?.getConvertedValue(fromRate: ratesList[index], toRate: data.currencyFromRate, amount: data.enteredAmount) else {return []}
                        topPopularRates.append("\(popularCurrenciesList[count]) \(value)")
                        count += 1
                    }
                }
            }
        }
        return topPopularRates
    }
}
