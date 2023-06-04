import Foundation

protocol MainAPiProtocol {
    func getRates(completion: @escaping (RatesResponse?, Error?) -> Void)
}

class RatesAPI: BaseAPI<RatesNetworking>, MainAPiProtocol {

    func getRates(completion: @escaping (RatesResponse?, Error?) -> Void) {
        self.request(target: .getRates, responseClass: RatesResponse.self) { (result, error) in
            completion(result, error)
        }
    }
}
