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
    func rent(with cardholder: String, cardNumber: String, expiration: String, cvv: String) -> Promise<Void>
}

class APIClient: Auth {

    var apiToken: String! {
        didSet {
            A0SimpleKeychain(service: "Jitensha").setString(apiToken, forKey: "accessToken")
        }
    }

    static let shared = APIClient()

    var provider: MoyaProvider<JitenshaAPI>! {
        guard let token = self.apiToken else {
            return MoyaProvider<JitenshaAPI>()
        }
        let endpointClosure = { (target: JitenshaAPI) -> Endpoint<JitenshaAPI> in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": token])
        }
         return  MoyaProvider<JitenshaAPI>(endpointClosure: endpointClosure)
    }

    private init() {

    }

    func login(with email: String, password: String) -> Promise<Void> {
        return Promise{ fulfill, reject in

            provider
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
            provider
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
            provider
                .request(.places) { (result) in
                    switch result {
                    case let .success(response):
                        do {
                            let json = try response.mapJSON()
                            guard let places = JSON(json)["results"].array else {
                                reject(JitenshaAPIError.internalError(response))
                                return
                            }
                            fulfill(places)
                        } catch {
                            reject(JitenshaAPIError.internalError(response))
                        }
                    case let .failure(error):
                        reject(error)
                    }

                }
        }
    }

    func rent(with cardholder: String, cardNumber: String, expiration: String, cvv: String) -> Promise<Void> {

        let card = ["name":cardholder, "number":cardNumber, "expiration":expiration, "code":cvv]
        return Promise { fulfill, reject in
            provider
                .request(.rent(card)) { (result) in
                    switch result {
                    case let .success(response):
                        do {
                            let json = try response.mapJSON()
                            let _ = JSON(json)["message"].string!
                            fulfill()
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
    case internalError(Response)
}

// MARK: - Error Descriptions

extension JitenshaAPIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidCredential:
            return "Invalid email or password"
        case .internalError:
            return "Something went wrong!!!"
        }
    }
}
