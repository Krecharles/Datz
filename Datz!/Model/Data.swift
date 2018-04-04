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
	static var allNames = [String]() {
		didSet {
			// This saves it once too much when this var is initialized,
			// but that doesn't matter too much
			saveAllNames()
		}
	}
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
		activeYear = getYear(name: allNames[activeIndex])
	}
	
	// MARK: saving
	
	static func save() {
		// I don't save allNames here, the variable is saved when it is mutated
		save(year: activeYear) // since it has been edited
		saveActiveIndex()
		
		// TODO: uncomment this line
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
		
		// i do it like this in order to not cluster the code too much
		func createYear(_ name: String, _ subjectNames: [String], _ subjectCoefs: [Int]) {
			var metas = [SubjectMeta]()
			for i in 0..<subjectNames.count {
				metas.append(SubjectMeta(name: subjectNames[i], coef: Float(subjectCoefs[i]), combiMeta: nil))
			}
			presetYears.append(Year(name: name, subjects: metas))
		}
		
		// because of combi subjects -.-
		func co(_ names: [String], _ coefs: [Float]) -> CombiMeta {
			var subs = [SubjectMeta]()
			for i in 0..<names.count {
				subs.append(SubjectMeta(name: names[i], coef: coefs[i]))
			}
			return CombiMeta(subjects: subs)
		}
		
		func ms(_ name: String, _ coef: Float) -> SubjectMeta {
			return SubjectMeta(name: name, coef: coef, combiMeta: nil)
		}
		
		func mc(_ name: String, _ coef: Float, combiMeta: CombiMeta) -> SubjectMeta {
			return SubjectMeta(name: name, coef: coef, combiMeta: combiMeta)
		}
		
		func add(_ name: String, _ subjects: [SubjectMeta]) {
			presetYears.append(Year(name: name, subjects: subjects))
		}
		
//		let c = co(["mathe2", "info"], [3, 1])
//		let meta = SubjectMeta(name: "Combi2", coef: 4, combiMeta: c)
		
//		let meta = me("Combi", 4, combiMeta: co(["mathe2", "info"], [3, 1]))
//		let year = Year(name: "2MB", subjects: [mc("Combi", 4, combiMeta: co(["mathe2", "info"], [3, 1]))])
		
		add("2MB", [mc("Combi", 4, combiMeta: co(["mathe2", "info"], [3, 1]))])
		
		
		createYear("7e", ["Français", "Allemand", "Mathématiques", "SciNa", "Histoire", "VieSo", "Géographie", "Artistique", "EduMusic", "Luxembourgeois", "EduPhys"], [4, 4, 4, 3, 2, 2, 2, 1, 1, 1, 1])
		createYear("6C", ["Français", "Allemand", "Latin", "Mathématiques", "SciNa", "Histoire", "VieSo", "Géographie", "Artistique", "EduPhys"], [4, 4, 4, 4, 3, 2, 2, 2, 1, 1])
		createYear("6M", ["Français", "Allemand", "Anglais", "Mathématiques", "SciNa", "Histoire", "VieSo", "Géographie", "Artistique", "EduPhys"], [4, 4, 4, 4, 3, 2, 2, 2, 1, 1])
		createYear("5C", ["Français", "Allemand", "Anglais", "Latin", "Mathématiques", "Biologie", "Chimie/Physique", "Histoire", "VieSo", "Géographie", "Artistique", "EduPhys"], [4, 4, 4, 4, 4, 2, 2, 2, 2, 2, 2, 1])
		createYear("5M", ["Français", "Allemand", "Anglais", "Mathématiques", "Biologie", "Chimie/Physique", "Histoire", "VieSo", "Géographie", "Artistique", "EduPhys"], [4, 4, 4, 4, 2, 2, 2, 2, 2, 2, 1])
		createYear("4C", ["Français", "Allemand", "Anglais", "Latin", "Mathématiques", "Biologie", "Chimie/Physique", "Histoire", "VieSo", "Géographie", "Artistique", "EduPhys"], [4, 4, 4, 4, 4, 2, 2, 2, 2, 2, 2, 1])
		createYear("4M", ["Français", "Allemand", "Anglais", "Mathématiques", "Biologie", "Chimie/Physique", "Histoire", "VieSo", "Géographie", "Artistique", "EduPhys"], [4, 4, 4, 4, 2, 2, 2, 2, 2, 2, 1])
		createYear("3MA", ["Français", "Allemand", "Anglais", "4e Langue", "Mathématiques", "Biologie", "Chimie", "Histoire", "VieSo", "Physique", "Artistique", "Option", "EduPhys"], [4, 4, 4, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1])
		createYear("3CA", ["Français", "Allemand", "Anglais", "Latin", "Mathématiques", "Biologie", "Chimie", "Histoire", "VieSo", "Physique", "Artistique", "Option", "EduPhys"], [4, 4, 4, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1])

	}
	
	
	
	// is called manually
	static func reset() {
		UserDefaults.standard.set(nil, forKey: "firstLaunch")
		print("reset successfully")
	}

}
