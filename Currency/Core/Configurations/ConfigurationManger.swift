//
//  ConfigurationManger.swift
//  Currency
//
//  Created by gamal oraby on 30/05/2023.
//

import Foundation
enum Configuration {
    
    enum Error: Swift.Error {
        case missingKey
    }
    enum ConfigurationKey: String {
        case baseURL = "DEFAULT_BASE_URL"
    }

    static func value(for key: ConfigurationKey) -> String {
        switch key {
        case .baseURL:
            return "http://data.fixer.io/api"
        }
    }
}
