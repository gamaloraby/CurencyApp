import Foundation

protocol MainAPiProtocol {
    func getUsers(completion: @escaping (RatesResponse?, Error?) -> Void)
}

class UsersAPI: BaseAPI<RatesNetworking>, MainAPiProtocol {

    func getUsers(completion: @escaping (RatesResponse?, Error?) -> Void) {
        self.request(target: .getRates, responseClass: RatesResponse.self) { (result, error) in
            completion(result, error)
        }
    }
}
