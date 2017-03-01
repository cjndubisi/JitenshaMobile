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

protocol Auth {
    var bToken: String! {get set}

    func signUp(with email: String, password: String ) -> Promise<Void>
    func login(with email: String, password: String) -> Promise<Void>
    func places() -> Promise<[JSON]>
}

class APIClinet: Auth {

    var bToken: String!
    static let shared = APIClinet()

    private init() {

    }

    func login(with email: String, password: String) -> Promise<Void> {
        return Promise{ fulfill, reject in
            MoyaProvider<Jitensha>()
                .request(.login(email, password)) { (result) in

                    switch result {
                    case let .success(response):
                        do {
                            let json = try response.mapJSON()
                            self.bToken = JSON(json)["accessToken"].string
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
            MoyaProvider<Jitensha>()
                .request(.signup(email, password)) { (result) in

                    switch result {
                    case let .success(response):
                        do {
                            let json = try response.mapJSON()
                            self.bToken = JSON(json)["accessToken"].string
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
            MoyaProvider<Jitensha>()
                .request(Jitensha.places) { (result) in
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
