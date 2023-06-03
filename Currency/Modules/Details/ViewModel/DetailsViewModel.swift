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
    private var histoiricalData = [String?: [Rate]]()
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
    
    func getLastThreeDayesData(completion: @escaping (Dictionary<String?,[Rate]>) -> Void ) {
        let dic = removeDayes()
        completion(dic)
    }
    
    func historicalNumberOfSection() -> Int {
        return histoiricalData.count
    }
    
    func historicalNumberOfRows(in section: Int) -> Int {
        return histoiricalData[keys[section]]?.count ?? 0
    }
    
    func cellDataInRow(in section: Int, row: Int) -> Rate {
        guard let data = histoiricalData[keys[section]]?[row] else {return Rate()}
        return data
    }
    
    func storedDataDay(section: Int) -> String {
        return "\(histoiricalData[keys[section]]?[0].day ?? "")"
    }
    
    func getPopularCurencies(in section: Int, at row: Int) -> [String] {
        if let ratesCurrencyKeys = userDefaults.array(forKey: currencyCodsKey) as? [String], let currencyRatesList = userDefaults.array(forKey: ratesKey) as? [Double]{
                self.currencyCodesList = ratesCurrencyKeys
                self.ratesList = currencyRatesList
            }
        let popularConvertedCurencies = calculatePopularCurncies(section: section, row: row)
        return popularConvertedCurencies
    }
    
    private func removeDayes() -> [String?: [Rate]] {
        guard let  storedData = manager.fetchData(entityName: "Rate") else {return [:]}
        let dic = Dictionary(grouping: storedData, by: {"\(String(describing: $0.day))" })
        let sortedDic = dic.sorted { $0.value.first?.day ?? "" > $1.value.first?.day ?? ""}
        self.histoiricalData = dic
        keys = Array(sortedDic.map { "\($0.key)" })
        for (index, key) in keys.enumerated() {
            if index > 2, let rates =  dic[key]  {
                for rate in rates {
                    manager.deleteObject(item: rate)
                }
                guard let  storedData = manager.fetchData(entityName: "Rate") else {return [:]}
                let dic = Dictionary(grouping: storedData, by: {"\(String(describing: $0.day))" })
                self.histoiricalData = dic
                return self.histoiricalData
            }
        }
        return self.histoiricalData
    }

    private func calculatePopularCurncies(section: Int, row: Int) -> [String] {
        var count = 0
        var topPopularRates = [String]()
        for (index, currencyCode) in  currencyCodesList.enumerated() {
            if self.popularCurrenciesList.contains(currencyCode) {
                guard let data = histoiricalData[keys[section]]?[row] else {return[]}
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
