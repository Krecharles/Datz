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
		
		func mc(_ name: String, _ coef: Float, _ combiMeta: CombiMeta) -> SubjectMeta {
			return SubjectMeta(name: name, coef: coef, combiMeta: combiMeta)
		}
		
		func add(_ name: String, _ subjects: [SubjectMeta]) {
			presetYears.append(Year(name: name, subjects: subjects))
		}
		
		// classique
		add("7e", [ms("Français", 4.0), ms("Allemand", 4.0), ms("Mathématiques", 4.0), ms("SciNa", 3.0), ms("Histoire", 2.0), ms("VieSo", 2.0), ms("Géographie", 2.0), ms("Artistique", 1.0), ms("EduMusic", 1.0), ms("Luxembourgeois", 1.0), ms("EduPhys", 1.0)])
		add("6C", [ms("Français", 4.0), ms("Allemand", 4.0), ms("Latin", 4.0), ms("Mathématiques", 4.0), ms("SciNa", 3.0), ms("Histoire", 2.0), ms("VieSo", 2.0), ms("Géographie", 2.0), ms("Artistique", 1.0), ms("EduPhys", 1.0)])
		add("6M", [ms("Français", 4.0), ms("Allemand", 4.0), ms("Anglais", 4.0), ms("Mathématiques", 4.0), ms("SciNa", 3.0), ms("Histoire", 2.0), ms("VieSo", 2.0), ms("Géographie", 2.0), ms("Artistique", 1.0), ms("EduPhys", 1.0)])
		add("5C", [ms("Français", 4.0), ms("Allemand", 4.0), ms("Anglais", 4.0), ms("Latin", 4.0), ms("Mathématiques", 4.0), ms("Biologie", 2.0), ms("Chimie/Physique", 2.0), ms("Histoire", 2.0), ms("VieSo", 2.0), ms("Géographie", 2.0), ms("Artistique", 2.0), ms("EduPhys", 1.0)])
		add("5M", [ms("Français", 4.0), ms("Allemand", 4.0), ms("Anglais", 4.0), ms("Mathématiques", 4.0), ms("Biologie", 2.0), ms("Chimie/Physique", 2.0), ms("Histoire", 2.0), ms("VieSo", 2.0), ms("Géographie", 2.0), ms("Artistique", 2.0), ms("EduPhys", 1.0)])
		add("4C", [ms("Français", 4.0), ms("Allemand", 4.0), ms("Anglais", 4.0), ms("Latin", 4.0), ms("Mathématiques", 4.0), ms("Biologie", 2.0), ms("Chimie/Physique", 2.0), ms("Histoire", 2.0), ms("VieSo", 2.0), ms("Géographie", 2.0), ms("Artistique", 2.0), ms("EduPhys", 1.0)])
		add("4M", [ms("Français", 4.0), ms("Allemand", 4.0), ms("Anglais", 4.0), ms("Mathématiques", 4.0), ms("Biologie", 2.0), ms("Chimie/Physique", 2.0), ms("Histoire", 2.0), ms("VieSo", 2.0), ms("Géographie", 2.0), ms("Artistique", 2.0), ms("EduPhys", 1.0)])
		add("3MA", [ms("Français", 4.0), ms("Allemand", 4.0), ms("Anglais", 4.0), ms("4e Langue", 3.0), ms("Mathématiques", 2.0), ms("Biologie", 2.0), ms("Chimie", 2.0), ms("Histoire", 2.0), ms("VieSo", 2.0), ms("Physique", 2.0), ms("Artistique", 2.0), ms("Option", 2.0), ms("EduPhys", 1.0)])
		add("3CA", [ms("Français", 4.0), ms("Allemand", 4.0), ms("Anglais", 4.0), ms("Latin", 3.0), ms("Mathématiques", 2.0), ms("Biologie", 2.0), ms("Chimie", 2.0), ms("Histoire", 2.0), ms("VieSo", 2.0), ms("Physique", 2.0), ms("Artistique", 2.0), ms("Option", 2.0), ms("EduPhys", 1.0)])
		add("3MB", [ms("Mathématiques", 4.0), ms("Français", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Physique", 3.0), ms("Chimie", 3.0), ms("Histoire", 2.0), ms("Biologie", 2.0), ms("Option", 2.0), ms("Artistique", 2.0), ms("VieSo", 2.0), ms("EduPhys", 1.0)])
		add("3CB", [ms("Mathématiques", 4.0), ms("Français", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Physique", 3.0), ms("Chimie", 3.0), ms("Latin", 3.0), ms("Histoire", 2.0), ms("Biologie", 2.0), ms("Artistique", 2.0), ms("VieSo", 2.0), ms("EduPhys", 1.0)])
		add("3MC", [ms("Biologie", 4.0), ms("Mathématiques", 3.0), ms("Français", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Physique", 3.0), ms("Chimie", 3.0), ms("Histoire", 2.0), ms("Option", 2.0), ms("Artistique", 2.0), ms("VieSo", 2.0), ms("EduPhys", 1.0)])
		add("3CC", [ms("Biologie", 4.0), ms("Mathématiques", 3.0), ms("Français", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Physique", 3.0), ms("Chimie", 3.0), ms("Latin", 3.0), ms("Histoire", 2.0), ms("Artistique", 2.0), ms("VieSo", 2.0), ms("EduPhys", 1.0)])
		add("3MD", [ms("Economie", 4.0), ms("Mathématiques", 3.0), ms("Français", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Physique", 2.0), ms("Chimie", 2.0), ms("Biologie", 2.0), ms("Histoire", 2.0), ms("Option", 2.0), ms("Artistique", 2.0), ms("VieSo", 2.0), ms("EduPhys", 1.0)])
		add("3CD", [ms("Economie", 4.0), ms("Mathématiques", 3.0), ms("Français", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Latin", 3.0), ms("Physique", 2.0), ms("Chimie", 2.0), ms("Biologie", 2.0), ms("Histoire", 2.0), ms("Artistique", 2.0), ms("VieSo", 2.0), ms("EduPhys", 1.0)])
		add("3ME", [mc("Artistique", 4.0, co(["Dessin", "Graphisme", "HistoArt"], [1.33, 1.33, 1.33])), ms("Mathématiques", 3.0), ms("Français", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Physique", 2.0), ms("Chimie", 2.0), ms("Histoire", 2.0), ms("Option", 2.0), ms("Artistique", 2.0), ms("VieSo", 2.0), ms("EduPhys", 1.0)])
		add("3CE", [mc("Artistique", 4.0, co(["Dessin", "Graphisme", "HistoArt"], [1.33, 1.33, 1.33])), ms("Mathématiques", 3.0), ms("Français", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Latin", 3.0), ms("Physique", 2.0), ms("Chimie", 2.0), ms("Histoire", 2.0), ms("Artistique", 2.0), ms("VieSo", 2.0), ms("EduPhys", 1.0)])
		add("3MF", [ms("EduMusic", 4.0), ms("Mathématiques", 3.0), ms("Français", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Physique", 2.0), ms("Chimie", 2.0), ms("Histoire", 2.0), ms("Option", 2.0), ms("Artistique", 2.0), ms("VieSo", 2.0), ms("EduPhys", 1.0)])
		add("3CF", [ms("EduMusic", 4.0), ms("Mathématiques", 3.0), ms("Français", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Latin", 3.0), ms("Physique", 2.0), ms("Chimie", 2.0), ms("Histoire", 2.0), ms("Artistique", 2.0), ms("VieSo", 2.0), ms("EduPhys", 1.0)])
		add("3MG", [ms("Economie", 4.0), ms("Mathématiques", 3.0), ms("Français", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Physique", 2.0), ms("Chimie", 2.0), ms("Biologie", 2.0), ms("Histoire", 2.0), ms("Option", 2.0), ms("Artistique", 2.0), ms("VieSo", 2.0), ms("Géographie", 2.0), ms("EduPhys", 1.0)])
		add("3MG", [ms("Economie", 4.0), ms("Mathématiques", 3.0), ms("Français", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Latin", 3.0), ms("Physique", 2.0), ms("Chimie", 2.0), ms("Biologie", 2.0), ms("Histoire", 2.0), ms("Artistique", 2.0), ms("VieSo", 2.0), ms("Géographie", 2.0), ms("EduPhys", 1.0)])
		add("2CA", [ms("Français", 4.0), ms("Allemand", 4.0), ms("Anglais", 4.0), ms("4e Langue", 3.0), mc("Histo/Civique", 3.0, co(["Histoire", "Civique"], [2.0, 1.0])), ms("Philosophie", 2.0), ms("EduMusic", 2.0), ms("Artistique", 2.0), ms("Option", 2.0), ms("EduPhys", 1.0)])
		add("2CAL", [ms("Français", 4.0), ms("Allemand", 4.0), ms("Anglais", 4.0), ms("Latin", 3.0), ms("4e Langue", 3.0), mc("Histo/Civique", 3.0, co(["Histoire", "Civique"], [2.0, 1.0])), ms("Philosophie", 2.0), ms("EduMusic", 2.0), ms("Artistique", 2.0), ms("EduPhys", 1.0)])
		add("2MB", [mc("Mathé2/Info", 4.0, co(["Mathématiques 2", "Informatique"], [3.0, 1.0])), ms("Français ", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Mathématiques 1", 3.0), mc("Histo/Civique", 3.0, co(["Histoire", "Civique"], [2.0, 1.0])), ms("Physique", 3.0), ms("Chimie", 3.0), ms("Option", 2.0), ms("EduPhys", 1.0)])
		add("2CB", [mc("Mathé2/Info", 4.0, co(["Mathématiques 2", "Informatique"], [3.0, 1.0])), ms("Français ", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Latin", 3.0), ms("Mathématiques 1", 3.0), mc("Histo/Civique", 3.0, co(["Histoire", "Civique"], [2.0, 1.0])), ms("Physique", 3.0), ms("Chimie", 3.0), ms("Option", 2.0), ms("EduPhys", 1.0)])
		add("2MC", [ms("Biologie", 4.0), ms("Français ", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Mathématiques", 3.0), mc("Histo/Civique", 3.0, co(["Histoire", "Civique"], [2.0, 1.0])), ms("Physique", 3.0), ms("Chimie", 3.0), ms("Option", 2.0), ms("EduPhys", 1.0)])
		add("2CC", [ms("Biologie", 4.0), ms("Français ", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Latin", 3.0), ms("Mathématiques", 3.0), mc("Histo/Civique", 3.0, co(["Histoire", "Civique"], [2.0, 1.0])), ms("Physique", 3.0), ms("Chimie", 3.0), ms("Option", 2.0), ms("EduPhys", 1.0)])
		add("2MD", [ms("Economie", 4.0), ms("Français ", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Mathématiques", 3.0), mc("Histo/Civique", 3.0, co(["Histoire", "Civique"], [2.0, 1.0])), ms("EcoPol", 3.0), ms("Option", 2.0), ms("Philosphie", 2.0), ms("Géographie", 2.0), ms("EduPhys", 1.0)])
		add("2CD", [ms("Economie", 4.0), ms("Français ", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Latin", 3.0), ms("Mathématiques", 3.0), mc("Histo/Civique", 3.0, co(["Histoire", "Civique"], [2.0, 1.0])), ms("EcoPol", 3.0), ms("Option", 2.0), ms("EduPhys", 1.0)])
		add("2ME", [mc("Artistique 1", 4.0, co(["Dessin", "Graphisme"], [2.0, 2.0])), mc("Artistique 2", 3.0, co(["Conception 3D", "HistoArt"], [1.5, 1.5])), ms("Français ", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), mc("Histo/Civique", 3.0, co(["Histoire", "Civique"], [2.0, 1.0])), ms("Mathématiques", 2.0), ms("Economie", 2.0), ms("Chimie", 2.0), ms("EduMusic", 2.0), ms("Option", 2.0), ms("EduPhys", 1.0)])
		add("2CE", [mc("Artistique 1", 4.0, co(["Dessin", "Graphisme"], [2.0, 2.0])), mc("Artistique 2", 3.0, co(["Conception 3D", "HistoArt"], [1.5, 1.5])), ms("Français ", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Latin", 3.0), mc("Histo/Civique", 3.0, co(["Histoire", "Civique"], [2.0, 1.0])), ms("Mathématiques", 2.0), ms("Economie", 2.0), ms("Chimie", 2.0), ms("EduMusic", 2.0), ms("Option", 2.0), ms("EduPhys", 1.0)])
		add("2MF", [ms("EduMusic 1", 4.0), ms("EduMusic 2", 3.0), ms("Français", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), mc("Histo/Civique", 3.0, co(["Histoire", "Civique"], [2.0, 1.0])), ms("Mathématiques", 2.0), ms("Economie", 2.0), ms("Physique", 2.0), ms("Artistique", 2.0), ms("Option", 2.0), ms("EduPhys", 1.0)])
		add("2CF", [ms("EduMusic 1", 4.0), ms("EduMusic 2", 3.0), ms("Français", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Latin", 3.0), mc("Histo/Civique", 3.0, co(["Histoire", "Civique"], [2.0, 1.0])), ms("Mathématiques", 2.0), ms("Economie", 2.0), ms("Physique", 2.0), ms("Artistique", 2.0), ms("Option", 2.0), ms("EduPhys", 1.0)])
		add("2MG", [ms("Economie", 4.0), ms("Français", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), mc("Histo/Civique", 3.0, co(["Histoire", "Civique"], [2.0, 1.0])), ms("EcoPol", 2.0), ms("Philosophie", 2.0), ms("Mathématiques", 2.0), ms("Option", 2.0), ms("Géographie", 2.0), ms("EduMusic", 2.0), ms("Artistique", 2.0), ms("EduPhys", 1.0)])
		add("2CG", [ms("Economie", 4.0), ms("Français", 3.0), ms("Allemand", 3.0), ms("Anglais", 3.0), ms("Latin", 3.0), mc("Histo/Civique", 3.0, co(["Histoire", "Civique"], [2, 1])), ms("EcoPol", 2.0), ms("Philosophie", 2.0), ms("Mathématiques", 2.0), ms("Option", 2.0), ms("Géographie", 2.0), ms("EduMusic", 2.0), ms("Artistique", 2.0), ms("EduPhys", 1.0)])

		// technique
		add("4GSN", [ms("Biologie", 4.0), ms("Chimie", 4.0), ms("Physique", 4.0), ms("Mathématiques", 4.0), ms("Allemand", 3.0), ms("Français", 3.0), ms("Anglais", 3.0), ms("Informatique", 2.0), ms("EduArt&Music", 2.0), ms("EduCitoyen", 2.0), ms("VieSo", 2.0), ms("EduPhys", 1.0)])

	}
	
	
	
	// is called manually
	static func reset() {
		UserDefaults.standard.set(nil, forKey: "firstLaunch")
		print("reset successfully")
	}

}
