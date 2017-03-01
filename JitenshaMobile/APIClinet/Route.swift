//
//  Auth.swift
//  JitenshaMobile
//
//  Created by Chijioke Ndubisi on 01/03/2017.
//
//

import PromiseKit
import SwiftyJSON
import Moya
import MoyaSugar

enum Jitensha {
    case signup(String, String)
    case login(String, String)
    case places
    case rent([String:Any])
}

extension Jitensha: SugarTargetType {

    var route: MoyaSugar.Route {
        switch self {
        case .signup:
            return .post("/register")
        case .login:
            return .post("/auth")
        case .places:
            return .get("/places")
        case .rent:
            return .post("/rent")
        }
    }

    var params: MoyaSugar.Parameters? {
        switch self {
        case let .signup(email, password):
            return JSONEncoding() => ["username":email, "password":password]
        case let .login(email, password):
            return JSONEncoding() => ["username":email, "password":password]
        case .places:
            return nil
        case let .rent(card):
            return JSONEncoding() => card
        }
    }

    var httpHeaderFields: [String : String]? {
        return self.token == nil ? nil : ["Authorization": self.token]
    }

    var task: Task {
        return .request
    }
}

extension SugarTargetType {

    var baseURL: URL {
        return URL(string: "https://localhost:8080/api/v1/auth")!
    }

    var token: String! {
        return AppDelegate.delegate.apiToken
    }

    var sampleData: Data {
        return Data()
    }
}
