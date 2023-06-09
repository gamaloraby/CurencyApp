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
    
    static let access_key = "1ffe0a129b1c2de20274b9bbacc1a3e0"
    /// setting the base url by confirming the protocol attribute
    var baseUrl: String {
        guard let baseString = baseString
        else {
            fatalError("Empty Base String, Please add the DEFAULT_BASE_URL key to the configurations files")
        }
        return "http://" + baseString + "/api"
    }
}
