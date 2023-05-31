//
//  MainApi.swift
//  Currency
//
//  Created by gamal oraby on 30/05/2023.
//
//

import Foundation
import Alamofire

enum RatesNetworking {
    case getRates
}

extension RatesNetworking: TargetType {
    var baseURL: String {
        switch self {
        case .getRates:
            return "http://data.fixer.io/api"
        }
    }
    
    var path: String {
        switch self {
        case .getRates:
            return "/latest"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getRates:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getRates:
            return .requestPlain

        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
}
