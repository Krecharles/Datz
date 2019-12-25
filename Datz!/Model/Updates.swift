//
//  Updates.swift
//  Datz!
//
//  Created by Charel Kremer on 24/12/2019.
//  Copyright © 2019 charelkremer. All rights reserved.
//

import Foundation

let updates = ["2.0"]

class Updates {
    
    static func update20() {
        
        /*
         What the update changed:
         - active year is not stored by its index but by its name
         */
        
//        func loadAllNames() -> [String] {
//            guard let n = UserDefaults.standard.object(forKey: "allNames") as? [String] else {
//                print("ERROR: allNames could not be retrieved from UserDefaults. Falling back to empty list")
//                return []
//            }
//            return n
//        }
//
//        func loadYear(key: String) -> Year {
//            guard let ec = UserDefaults.standard.object(forKey: key) as? Foundation.Data else {
//                print("ERROR: could not retrieve Year for key \(key) from UserDefaults. Falling back to EMPTY_YEAR")
//                return EMPTY_YEAR
//            }
//            do {
//                return try JSONDecoder().decode(Year.self, from: ec)
//            } catch {
//                print("ERROR: could not decode the year that has been loaded. Falling back to EMTPY_YEAR.")
//                print(ec)
//                return EMPTY_YEAR
//            }
//        }
//
//        let activeIndex = UserDefaults.standard.integer(forKey: "activeIndex")
//        let activeYearName = loadAllNames()
        
        print("Updated to 2.0 successfull")
    }
    
    /// This function is the very first function to be called
    /// so very few variables are set at that point
    static func performUpdatesIfNecessary() {
        if !MyData.isKeyPresentInUserDefaults(key: "UPDATES_2.0") {
            update20()
            UserDefaults.standard.set(true, forKey: "UPDATES_2.0")
        }
    }
    
}
