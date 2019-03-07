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
    
    //Helper function to calculate time taken by complex method's
    func duration(_ block: () -> ()) -> TimeInterval {
        let startTime = Date()
        block()
        return Date().timeIntervalSince(startTime)
    }
    
    //Method: sortCityNames - returns list of all cities to completion handler
    //Parameter: completion handler
    func sortCityNames(completion: @escaping ([City]) -> Void?) {
        DispatchQueue.global().async() {
            let citiesInfo = try! [City](fileName: "cities")
            completion(citiesInfo.sorted { $0.name < $1.name })
        }
    }
    
    //Method: filter - returns list of all cities depending on search string
    //Parameter: data : Contains data to be filtered on
    //Parameter: searchString: method to filter for list of cities containing search String
    func filter(from data: [City], for searchString: String) -> [City] {
        //Create array slice for the records starting from searchString
        let searchStartIndex = getIndexForSlice(from: data, with: searchString.lowercased())
        return self.getArraySlice(fromIndex: searchStartIndex + 1, toIndex: data.count - 1, arrayIn: data)
    }
    
    //Method: getArraySlice - returns list of all cities depending on search string
    //Parameter: fromIndex
    //Parameter: toIndex
    //Parameter: arrayIn : Contains data to be sliced on
    //Returns: [City] : List of records sliced
    fileprivate func getArraySlice(fromIndex: Int, toIndex: Int, arrayIn: [City]) -> [City] {
        if fromIndex < 0 || toIndex < 0 {
            return arrayIn
        }
        return Array(arrayIn[fromIndex...toIndex])
    }
    
    //Method: getIndexForSlice - Binary search technique to filter records with their indices
    //Parameter: data
    //Parameter: string
    //Retuns: start index offset from original dataset "data"
    fileprivate func getIndexForSlice(from data: [City], with string: String) -> Int {
        var startPointer = 0
        var endPointer = data.count - 1
        var currentPointer = (startPointer + endPointer) / 2
        while startPointer != currentPointer {
            if string <= data[currentPointer].name.lowercased() {
                endPointer = currentPointer
            }
            else {
                startPointer = currentPointer
            }
            currentPointer = (startPointer + endPointer) / 2
        }
        
        return endPointer
    }
}

//Enum : Throws in case of any exception
enum DecodingError : Error {
    case missingFile
}
