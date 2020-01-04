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
    
    /// the active Year.
    /// if null, this computed variable return EMPTY_YEAR
    public static var activeYear: Year {
        get {
            guard let y = MyData._activeYear else {
                return EMPTY_YEAR
            }
            return y
        }
        set {
            MyData._activeYear = newValue
        }
    }
    
    private static var _activeYear: Year?
    
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
    
    /// loads all the names of the classes that the user has used
    static func loadAllNames() {
        guard let n = UserDefaults.standard.object(forKey: "allNames") as? [String] else {
            print("ERROR: allNames could not be retrieved from UserDefaults. Falling back to empty list")
            allNames = []
            return
        }
        allNames = n
    }
    
    static func getYear(name: String) -> Year {
        return loadYear(key: genKey(name))
    }
    
    static func loadYear(key: String) -> Year {
        guard let ec = UserDefaults.standard.object(forKey: key) as? Foundation.Data else {
            print("ERROR: could not retrieve Year for key \(key) from UserDefaults. Falling back to EMPTY_YEAR")
            return EMPTY_YEAR
        }
        do {
            return try JSONDecoder().decode(Year.self, from: ec)
        } catch {
            print("ERROR: could not decode the year that has been loaded. Falling back to EMTPY_YEAR.")
            print(ec)
            return EMPTY_YEAR
        }
    }
    
    static func loadActiveYear() {
        // if activeIndex does not exist as key in UserDefaults, .integer() automatically
        // falls back to 0.
//        let activeIndex = UserDefaults.standard.integer(forKey: "activeIndex")
        guard let activeYearName = UserDefaults.standard.string(forKey: "activeYearName") else {
            print("ERROR: could not load activeYearName from UserDefaults. Setting activeYear to EMTPY_YEAR")
            activeYear = EMPTY_YEAR
            return
        }
//		if activeIndex < allNames.count {
//			activeYear = getYear(name: allNames[activeIndex])
//		}
        if allNames.contains(activeYearName) {
            activeYear = getYear(name: activeYearName)
        } else {
            print("ERROR: activeYearName is not in allNames. Falling back to EMPTY_YEAR")
            print("activeYearName: \(activeYearName)")
            print("allNames: \(allNames)")
			activeYear = EMPTY_YEAR
		}
		
    }
    
    // MARK: saving
    
    static func save() {
        // saving approximately takes 0.001s
        Benchmark.start()
        print("INFO: attempting to save.")
        
        if activeYear.name == EMPTY_YEAR.name {
            print("WARNING: Tried to save EMPTY_YEAR. Saving aborted.")
            return
        }
        
        save(year: activeYear) // since it has been edited
        saveActiveYearName()
        saveAllNames()
        
        UserDefaults.standard.set("not first launch", forKey: "firstLaunch")
        
        print("INFO: Finished saving.")
        Benchmark.stop()
    }
    
    static func saveAllNames() {
        UserDefaults.standard.set(allNames, forKey: "allNames")
    }
    
    static func save(year: Year) {
        let key = genKey(year.name)
        guard let ec = try? JSONEncoder().encode(year) else {
            print("ERROR: could not encode year. Saving the year aborted")
            print(year)
            return
        }
        UserDefaults.standard.set(ec, forKey: key)
    }

    static func saveActiveYearName() {
        UserDefaults.standard.set(activeYear.name, forKey: "activeYearName")
    }
    
    static func deleteYear(yearName: String) {
        
        if yearName == MyData.activeYear.name {
            // attempting to delete active Year
            print("INFO: attempting to delete activeYear. It will be deleted and activeYear set to EMPTY_YEAR")
            MyData.activeYear = EMPTY_YEAR
        }
        
        // actually deleting the year
        UserDefaults.standard.set(nil, forKey: genKey(yearName))
        print("INFO: deleted year with name \(yearName)")
        
        guard let yearIndex = allNames.index(of: yearName) else {
            print("ERROR: tried to delete yearName but yearName not present in allNames. Aborting Delete yearName")
            print("yearName: \(yearName)")
            print("allNames: \(allNames)")
            return
        }
        
        allNames.remove(at: yearIndex)
        
        MyData.saveAllNames()
        
    }
    
    // MARK: Default values
    
    /// indicated whether it is the first launch or not,
    /// which is determined if the app has saved once in its live
    static func isFirstLaunch() -> Bool {
        return (UserDefaults.standard.value(forKey: "firstLaunch") as? String) == nil
    }
    
    /// is called on first launch
    static func loadDefaultValues() {
        // set the activeIndex to zero
        UserDefaults.standard.set(0, forKey: "activeIndex")
        UserDefaults.standard.set("", forKey: "activeYearName")
        let allNames = [String]()
        UserDefaults.standard.set(allNames, forKey: "allNames")
        
    }
    
    static func loadPresetYears() {
        presetYears = PresetLoader.readPresetYears()
    }
    
    
    // is called manually from the debugger console
    static func reset() {
        UserDefaults.standard.set(nil, forKey: "firstLaunch")
        print("reset successfully")
    }

}
