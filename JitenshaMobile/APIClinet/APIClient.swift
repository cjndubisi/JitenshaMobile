//
//  JitenshaAPI.swift
//  JitenshaMobile
//
//  Created by Chijioke Ndubisi on 01/03/2017.
//
//

import SwiftyJSON
import PromiseKit
import Moya
import SimpleKeychain

protocol Auth {
    var apiToken: String! {get set}

    func signUp(with email: String, password: String ) -> Promise<Void>
    func login(with email: String, password: String) -> Promise<Void>
    func places() -> Promise<[JSON]>
}

class APIClinet: Auth {

    var apiToken: String! {
        didSet {
            A0SimpleKeychain(service: "Jitensha").setString(apiToken, forKey: "accessToken")
        }
    }

    static let shared = APIClinet()

    private init() {

    }

    func login(with email: String, password: String) -> Promise<Void> {
        return Promise{ fulfill, reject in
            MoyaProvider<JitenshaAPI>()
                .request(.login(email, password)) { (result) in

                    switch result {
                    case let .success(response):
                        do {
                            let jsonData = try response.mapJSON()
                            let json = JSON(jsonData)
                            guard let apiToken = json["accessToken"].string else {
                                reject(JitenshaAPIError.invalidCredential(response))
                                return
                            }
                            self.apiToken = apiToken
                            fulfill()
                        } catch {
                            reject(error)
                        }
                    case let .failure(error):
                        reject(error)
                    }
            }
        }
    }

    func signUp(with email: String, password: String) -> Promise<Void> {
        return Promise{ fulfill, reject in
            MoyaProvider<JitenshaAPI>()
                .request(.signup(email, password)) { (result) in

                    switch result {
                    case let .success(response):
                        do {
                            let jsonData = try response.mapJSON()
                            let json = JSON(jsonData)
                            guard let apiToken = json["accessToken"].string else {
                                reject(JitenshaAPIError.invalidCredential(response))
                                return
                            }
                            self.apiToken = apiToken
                            fulfill()
                        } catch {
                            reject(error)
                        }
                    case let .failure(error):
                        reject(error)
                    }
            }
        }
    }

    func places() -> Promise<[JSON]> {
        return Promise { fulfill, reject in
            MoyaProvider<JitenshaAPI>()
                .request(.places) { (result) in
                    switch result {
                    case let .success(response):
                        do {
                            let json = try response.mapJSON()
                            let places = JSON(json)["result"].array!
                            fulfill(places)
                        } catch {
                            reject(NSError(domain: "JSON Mapping", code: 300, userInfo: [NSLocalizedDescriptionKey: "Could not complete operation"]))
                        }
                    case let .failure(error):
                        reject(error)
                    }

                }
        }
    }
}


// MARK: - API Errors
public enum JitenshaAPIError: Swift.Error {

    case invalidCredential(Response)

}

// MARK: - Error Descriptions

extension JitenshaAPIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidCredential:
            return "Invalid email or password"
        }
    }
}
