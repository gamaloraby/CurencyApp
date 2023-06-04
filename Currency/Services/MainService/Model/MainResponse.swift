//
//  MainResponse.swift
//  Currency
//
//  Created by gamal oraby on 30/05/2023.
//

import Foundation

// MARK: - RatesResponse
struct RatesResponse: Codable {
    let success: Bool?
    let timestamp: Double?
    let base, date: String?
    let rates: [String: Double]?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case timestamp = "timestamp"
        case base = "base"
        case date = "date"
        case rates = "rates"
    }
}
