//
//  Jitensha.swift
//  JitenshaMobile
//
//  Created by Chijioke Ndubisi on 01/03/2017.
//
//

import Foundation
import SwiftyJSON

class Place {

    let name: String
    let id: String
    let lat: Double
    let long: Double
    
    init(json: JSON) {
        name = json["name"].string!
        lat = json["location"]["lat"].double!
        long = json["location"]["lng"].double!
        id = json["id"].string!
    }
}
