//
//  DataHelper.swift
//  iPlaces
//
//  Created by Ashh on 3/4/19.
//  Copyright © 2019 Ashh. All rights reserved.
//

import Foundation

class DataHelper : Decodable {
        
    static func sortCityNames(completion: @escaping ([City]) -> Void?) {
        DispatchQueue.global().async() {
            let citiesInfo = try! [City](fileName: "cities")
            completion(citiesInfo.sorted { $0.name < $1.name })
        }
    }
}

enum DecodingError : Error {
    case missingFile
}
