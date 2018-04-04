//
//  Subjects.swift
//  Datz!
//
//  Created by Charel Kremer on 04.04.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import Foundation

class SubjectMeta: Codable {
	var name: String
	var coef: Float
	init(name: String, coef: Float) {
		self.name = name
		self.coef = coef
	}
}

class CombiSubjectMeta : SubjectMeta {
	var combiSubjects: [SubjectMeta]
	init(name: String, coef: Float, combiSubjects: [SubjectMeta]) {
		self.combiSubjects = combiSubjects
		super.init(name: name, coef: coef)
	}
	required init(from decoder: Decoder) throws {
		fatalError("init(from:) has not been implemented")
	}
}

protocol Subject: Codable {
	var name: String {get set}
	var coef: Float {get set}
	var goal: Float? {get set}
	var plusPoints: Float {get set}
	func getAvg() -> Float
	func getFinalAvg() -> Int
	func isAvgCalculable() -> Bool
}

struct SimpleSubject: Subject  {
	
	var name: String
	var tests : [Test]
	var coef: Float
	var plusPoints: Float
	var goal: Float?
	
	// Structs can't inherit structs, so I have to do this
	init(meta: SubjectMeta) {
		name = meta.name
		coef = meta.coef
		tests = []
		plusPoints = 0
	}
	
	/// only average of the tests, no up rounding but still bonus
	func getAvg() -> Float {
		var out: Float = 0.0
		for test in tests {
			out += test.grade/test.maxGrade
		}
		return out * 60.0 / Float(tests.count) + plusPoints
	}
	
	
	
	/// respects also pluspoints and up rounding
	func getFinalAvg() -> Int {
		let ceiled = ceil(getAvg())
		// weird line of code coz division sometimes is inaccurate
		if getAvg() - ceiled + 1 < 0.00001 {
			return Int(ceiled)-1
		}
		return Int(ceil(getAvg()))
	}
	
	func isAvgCalculable() -> Bool {
		return tests.count > 0
	}
	
}

struct CombiSubject: Subject {
	var name: String
	var subjects : [SimpleSubject]
	var coef: Float
	var plusPoints: Float
	var goal: Float?
	
	// Structs can't inherit structs, so I have to do this
	init(meta: CombiSubjectMeta) {
		name = meta.name
		coef = meta.coef
		subjects = []
		for m in meta.combiSubjects {
			subjects.append(SimpleSubject(meta: m))
		}
		plusPoints = 0
	}
	
	/// only average of the tests, no up rounding but still bonus
	func getAvg() -> Float {
		var out: Float = 0
		var gradeNumber: Float = 0
		for s in subjects {
			if !s.isAvgCalculable() { continue }
			out += Float(s.getFinalAvg()) * s.coef
			gradeNumber += s.coef
		}
		return out/gradeNumber + plusPoints
	}
	
	
	
	/// respects also pluspoints and up rounding
	func getFinalAvg() -> Int {
		let ceiled = ceil(getAvg())
		// weird line of code coz division sometimes is inaccurate
		if getAvg() - ceiled + 1 < 0.00001 {
			return Int(ceiled)-1
		}
		return Int(ceil(getAvg()))
	}
	
	func isAvgCalculable() -> Bool {
		for s in subjects {
			if s.isAvgCalculable() {
				return true
			}
		}
		return false
	}
}





