//
//  DataHelper.swift
//  iPlaces
//
//  Created by Ashh on 3/4/19.
//  Copyright © 2019 Ashh. All rights reserved.
//

import Foundation

class DataHelper : Decodable {
    static let shared = DataHelper()
    
    var sortedCitiesInfo : [City]?
    
    static func sortCityNames(completion: @escaping ([City]) -> Void?) {
        DispatchQueue.global().async() {
            let citiesInfo = try! [City](fileName: "cities")
            completion(citiesInfo.sorted { $0.name < $1.name })
        }
    }
    
    static func filter(from data: [City], for searchString: String) -> [City] {
        let searchStartIndex = getIndexForSlice(from: data, with: searchString.lowercased(), for: .startingIndex)
        return DataHelper.arrayTake(m: searchStartIndex + 1, n: data.count - 1, arrayIn: data) as! [City]
    }
    
    static func arrayTake(m: Int, n: Int, arrayIn: Array<Any>) -> Array<Any>
    {
        if m < 0 || n < 0 {
            return arrayIn
        }
        return Array(arrayIn[m...n])
    }
    static func getIndexForSlice(from data: [City], with string: String, for index: FilterFor) -> Int {
        var startPointer = 0
        var endPointer = data.count - 1
        var currentPointer = (startPointer + endPointer) / 2
        while startPointer != currentPointer {
            if string <= data[currentPointer].name.lowercased() {
                
                endPointer = currentPointer
                print("ENDPOINTER:\(string) \(data[endPointer].name)")
            }
            else {
                startPointer = currentPointer
                print("startPointer:\(string) \(data[startPointer].name)")
            }
            
            currentPointer = (startPointer + endPointer) / 2
        }
        return endPointer
    }
}

enum DecodingError : Error {
    case missingFile
}

enum FilterFor {
    case startingIndex
    case endingIndex
}
