//
//  Coordinates.swift
//  iPlaces
//
//  Created by Ashh on 3/4/19.
//  Copyright © 2019 Ashh. All rights reserved.
//

import Foundation

struct Coordinates : Decodable {
    let lon : Double
    let lat : Double
    
    var details: String {
        return "\(lat), \(lon)"
    }
}
