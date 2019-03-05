//
//  CIty.swift
//  iPlaces
//
//  Created by Ashh on 3/4/19.
//  Copyright © 2019 Ashh. All rights reserved.
//

import Foundation
import MapKit

struct City : Decodable{
    let country : String
    let name : String
    let coord : Coordinates
    
    var nameAndCountry : String {
        return "\(name) , \(country)"
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(coord.lat, coord.lon)
    }
    

}

extension Array where Element == City {
    init(fileName: String) throws {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw DecodingError.missingFile
        }
        
        let decoder = JSONDecoder()
        let data = try Data(contentsOf: url)
        self = try decoder.decode([City].self, from: data)
    }
}


