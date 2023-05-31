//
//  MainApi.swift
//  Currency
//
//  Created by gamal oraby on 30/05/2023.
//
//

import Foundation
import Alamofire

enum UsersNetworking {
    case getUsers
}

extension UsersNetworking: TargetType {
    var baseURL: String {
        switch self {
        case .getUsers:
            return "http://data.fixer.io/api"
        }
    }
    
    var path: String {
        switch self {
        case .getUsers:
            return "/latest"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUsers:
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
