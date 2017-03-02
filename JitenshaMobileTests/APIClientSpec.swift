//
//  JoinViewControllerSpec.swift
//  JitenshaMobile
//
//  Created by Chijioke Ndubisi on 01/03/2017.
//
//

import XCTest
import Quick
import Nimble
import OHHTTPStubs
import SimpleKeychain
import SwiftyJSON
import PromiseKit

@testable import JitenshaMobile

class APIClinetSpec: QuickSpec {

    override func spec() {

        describe("APIClient"){
            let specEmail: String = "crossover@crossover.com"
            let specPassword: String = "Crossover123"
            beforeEach {
                A0SimpleKeychain(service: "Jitensha").clearAll()
            }
            context("Signup", {
                beforeEach {
                    A0SimpleKeychain(service: "Jitensha").clearAll()
                    stub(condition: isHost("localhost") && isPath("/api/v1/register"), response: { _ in
                        let url = Bundle.main.url(forResource: "POST#auth", withExtension: ".json")
                        return OHHTTPStubsResponse(fileURL: url!, statusCode: 200, headers: nil)
                    })
                    let _ = APIClient.shared.signUp(with: specEmail, password: specPassword)
                }

                it("creates user") {
                    expect(APIClient.shared.apiToken).toNotEventually(beNil(), timeout: 10, pollInterval: 1, description: nil)
                }
            })

            context("Login", { 
                beforeEach {
                    A0SimpleKeychain(service: "Jitensha").clearAll()

                    stub(condition: isHost("localhost") && isPath("/api/v1/auth"), response: { _ in
                        let url = Bundle.main.url(forResource: "POST#auth", withExtension: ".json")
                        return OHHTTPStubsResponse(fileURL: url!, statusCode: 200, headers: nil)
                    })
                    let _ = APIClient.shared.login(with: specEmail, password: specPassword)
                }

                it("sign user") {

                    expect(APIClient.shared.apiToken).toNotEventually(beNil(), timeout: 10, pollInterval: 1, description: nil)
                }
            })

            context("Get Places", {
                var promise: Promise<[JSON]>!
                beforeEach {
                    A0SimpleKeychain(service: "Jitensha").clearAll()

                    stub(condition: isHost("localhost") && isPath("/api/v1/places"), response: { _ in
                        let url = Bundle.main.url(forResource: "GET#places", withExtension: ".json")
                        return OHHTTPStubsResponse(fileURL: url!, statusCode: 200, headers: nil)
                    })
                    promise = APIClient.shared.places()
                }
                it("return places") {
                    _ = promise.then { json -> (Void) in
                        expect(json.count).to(beGreaterThan(10))
                    }
                }
            })

            context("Send Card", {
                var promise: Promise<Void>!
                beforeEach {
                    A0SimpleKeychain(service: "Jitensha").clearAll()

                    stub(condition: isHost("localhost") && isPath("/api/v1/rent"), response: { _ in
                        let url = Bundle.main.url(forResource: "POST#rent", withExtension: ".json")
                        return OHHTTPStubsResponse(fileURL: url!, statusCode: 200, headers: nil)
                    })
                    promise = APIClient.shared.rent(with: "Cross Over", cardNumber: "233344455535555", expiration: "12/12", cvv: "132")
                }
                it("sendCard") {
                    expect(promise.isFulfilled).toEventually(equal(true), timeout:10, pollInterval: 1, description: nil)
                    expect(promise.isRejected).toEventually(equal(false), timeout:10, pollInterval: 1, description: nil)
                }
            })
        }
    }

}
