//
//  Data.swift
//  Design Inspiration
//
//  Created by Charel Kremer on 30.03.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import Foundation

// bad name to avoid collision with Foundation.Data
class MyData {

    /// the names of all the saved year objects
    static var allNames = [String]()
    public static var activeYear: Year!
    
    public static var presetYears = [Year]()
    
    // MARK: key generation
    
    /// generates a key for a string, so that userdefaults cannot break anything
    static func genKey(_ s: String) -> String {
        return "KEY_\(s)"
    }
    
    static func deGenKey(_ s: String) -> String {
        let index = s.index(s.startIndex, offsetBy: 4)
        return String(s.suffix(from: index))
    }
    
    static func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    // MARK: loading
    
    static func load() {
        loadAllNames()
        loadActiveYear()
    }
    
    static func loadAllNames() {
        allNames = UserDefaults.standard.object(forKey: "allNames") as! [String]
    }
    
    static func getYear(name: String) -> Year {
        return loadYear(key: genKey(name))
    }
    
    static func loadYear(key: String) -> Year {
        let ec = UserDefaults.standard.object(forKey: key) as! Foundation.Data
        return try! JSONDecoder().decode(Year.self, from: ec)
    }
    
    static func loadActiveYear() {
        let activeIndex = UserDefaults.standard.integer(forKey: "activeIndex")
		if activeIndex < allNames.count {
			activeYear = getYear(name: allNames[activeIndex])
		}
		else {
			print("------fatal error, Index out of range")
			print(allNames)
			print(activeIndex)
			activeYear = getYear(name: allNames[0])
		}
		
    }
    
    // MARK: saving
    
    static func save() {
        
        if activeYear == nil {
            return
        }
        
        save(year: activeYear) // since it has been edited
        saveActiveIndex()
        saveAllNames()
        
        UserDefaults.standard.set("not first launch", forKey: "firstLaunch")
    }
    
    static func saveAllNames() {
        UserDefaults.standard.set(allNames, forKey: "allNames")
    }
    
    static func save(year: Year) {
        let key = genKey(year.name)
        let ec = try? JSONEncoder().encode(year)
        UserDefaults.standard.set(ec, forKey: key)
    }

    static func saveActiveIndex() {
        let idx = allNames.index(of: activeYear.name)
        UserDefaults.standard.set(idx, forKey: "activeIndex")
    }
    
    static func delete(yearName: String) {
        allNames.remove(at: allNames.index(of: yearName)!)
        UserDefaults.standard.set(nil, forKey: genKey(yearName))
    }
    
    // MARK: Default values
    
    static func isFirstLaunch() -> Bool {
        return (UserDefaults.standard.value(forKey: "firstLaunch") as? String) == nil
    }
    
    static func loadDefaultValues() {
        // set the activeIndex to zero
        UserDefaults.standard.set(0, forKey: "activeIndex")
        let an = [String]()
        UserDefaults.standard.set(an, forKey: "allNames")
        
    }
    
    static func loadPresetYears() {
        presetYears = readPresetYears()
    }
    
    
    // is called manually from the debugger console
    static func reset() {
        UserDefaults.standard.set(nil, forKey: "firstLaunch")
        print("reset successfully")
    }

}
