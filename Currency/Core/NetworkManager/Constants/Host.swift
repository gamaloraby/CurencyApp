//
//  Host.swift
//  Currency
//
//  Created by gamal oraby on 30/05/2023.
//

import Foundation

/// The Identifiers of the different base urls which is used across the whole app
enum HOST {
    case defaultBase
}

/// Adding the default base url
extension HOST {

    /// based on the target environment setting the base url
    private var baseString: String? {
        switch self {
        case .defaultBase:
            return Configuration.value(for: .baseURL)
        }
    }
    
    static let access_key = "c0ee4c6b46637f0d651ae8232139da69"
    /// setting the base url by confirming the protocol attribute
    var baseUrl: String {
        guard let baseString = baseString
        else {
            fatalError("Empty Base String, Please add the DEFAULT_BASE_URL key to the configurations files")
        }
        return "http://" + baseString + "/api"
    }
}
