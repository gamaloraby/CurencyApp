import Foundation

protocol MainAPiProtocol {
    func getUsers(completion: @escaping (RatesResponse?, Error?) -> Void)
}

class UsersAPI: BaseAPI<UsersNetworking>, MainAPiProtocol {
    //MARK:- Requests
    func getUsers(completion: @escaping (RatesResponse?, Error?) -> Void) {
        self.fetchData(target: .getUsers, responseClass: RatesResponse.self) { (result, error) in
            completion(result, error)
        }
    }
}
