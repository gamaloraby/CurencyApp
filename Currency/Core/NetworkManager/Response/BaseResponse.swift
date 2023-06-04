//
//  BaseResponse.swift
//  Currency
//
//  Created by gamal oraby on 30/05/2023.
//

import Foundation

class BaseResponse<T: Codable>: Codable {

    var status: String?
    var data: T?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
    }
}
