//
//  NetworkManager.swift
//  Currency
//
//  Created by gamal oraby on 30/05/2023.
//

import Foundation
import Alamofire

class BaseAPI<T: TargetType> {
    
    func request<M: Decodable>(target: T, responseClass: M.Type, completion:@escaping (M?,Error?) -> Void) {
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let params = buildParams(task: target.task)
        let url = "\(target.baseURL)\(target.path)"
        
        let reachability = try? Reachability.init()
        if reachability!.connection == .unavailable {
            let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.internetMessage])
            completion(nil, error)
            return

        }
        AF.request(url, method: method, parameters: params.0, encoding: params.1, headers: headers).responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else {
                // ADD Custom Error
                let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.genericError])
                // time out
                completion(nil, error)
                return
            }
            if statusCode == 200 {
                // Successful
                guard let jsonResponse = try? response.result.get() else {
                    // ADD Custom Error
                    let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.genericError])
                    completion(nil, error)
                    return
                }
                guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                    // ADD Custom Error
                    let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.genericError])
                    completion(nil, error)
                    return
                }
                guard let responseObj = try? JSONDecoder().decode(M.self, from: theJSONData) else {
                    // ADD Custom Error
                    let error = NSError(domain: target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.genericError])
                    completion(nil, error)
                    return
                }
                completion(responseObj, nil)
            } else {
                let message = "Error Message Parsed From BE"
                let error = NSError(domain: target.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: message])
                completion(nil, error)
            }
        }
    }
    
    
    private func buildParams(task: Task) -> ([String:Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:], URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        }
    }
}

struct ErrorMessage {
    static let genericError = "Something went wrong please try again later"
    static let internetMessage = "No Interned Conection"
}
