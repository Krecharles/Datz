//
//  Data.swift
//  Datz!
//
//  Created by Charel Kremer on 22.03.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import Foundation

struct Year : Codable {
	var name: String // 3MB
	var subjects: [SubjectMeta]
	var trimesters: [Trimester]
    var isPremiere: Bool? // needs to be a optional to load old classes who don't have this field
	
    init(name: String, subjects: [SubjectMeta], isPremiere: Bool = false) {
		self.name = name
		self.subjects = subjects
        self.isPremiere = isPremiere
		
		var subs = [Subject]()
		for s in subjects {
			subs.append(Subject(meta: s))
		}   
		
		trimesters = []
		for _ in 0..<3 {
			trimesters.append(Trimester(subjects: subs))
		}
		
	}
	
	func isSubjectAvgCalculable(subject: Int) -> Bool {
		for t in trimesters {
			if t.subjects[subject].isAvgCalculable() {
				return true
			}
		}
		return false
	}
	
	func getSubjectAvg(subject: Int) -> Float {
		var out: Float = 0
		var valids: Float = 0
        for (i, t) in trimesters.enumerated() {
			if t.subjects[subject].isAvgCalculable() {
                if isTrue(self.isPremiere) && i == 2{
                    // this is the examen
                    valids += 4
                    out += Float(t.subjects[subject].getFinalAvg()) * 4
                }
                else {
                    valids += 1
                    out += Float(t.subjects[subject].getFinalAvg())
                }
			}
		}
		return out/valids
	}
	
	func getSubjectFinalAvg(subject: Int) -> Int {
		return Int(ceil(getSubjectAvg(subject: subject)))
	}
	
	func isAvgCalculable() -> Bool {
		for i in 0..<subjects.count {
			if isSubjectAvgCalculable(subject: i) {
				return true
			}
		}
		return false
	}
	
	func getAvg() -> Float {
		
		var out = Float(0)
		var gradeNumber: Float = 0
		
		for i in 0..<subjects.count {
			
			if isSubjectAvgCalculable(subject: i) {
				out += Float(getSubjectFinalAvg(subject: i)) * subjects[i].coef
				gradeNumber += subjects[i].coef
			}
			
		}
		
		return out/gradeNumber
		
	}
	
	func getFinalAvg() -> Int {
		return Int(ceil(getAvg()))
	}
	
}

struct SubjectMeta : Codable {
	var name: String // Mathématiques
	var coef: Float // 4
	var combiMeta: CombiMeta?
	
	init(name: String, coef: Float, combiMeta: CombiMeta?) {
		self.name = name
		self.coef = coef
		self.combiMeta = combiMeta
	}
	
	init(name: String, coef: Float) {
		self.init(name: name, coef: coef, combiMeta: nil)
	}
	
}

struct CombiMeta : Codable {
	var subjects: [SubjectMeta]
}

struct Trimester : Codable {

	var subjects: [Subject]

	func getFinalAvg() -> Int {
		return Int(ceil(getAvg()))
	}

	func getAvg() -> Float {
		var out: Float = 0
		var gradeNumber: Float = 0
		for s in subjects {
			if !s.isAvgCalculable() { continue }
			out += Float(s.getFinalAvg()) * s.coef
			gradeNumber += s.coef
		}
		return out/gradeNumber
	}

	func isAvgCalculable() -> Bool {

		if subjects.count == 0 {
			return false
		}

		var out = false
		for s in subjects {
			if s.isAvgCalculable() { out = true }
		}
		return out

	}
}

struct CombiSubject: Codable {
	
	var subjects: [Subject]
	
	init() {
		subjects = []
	}
	
	func getAvg() -> Float {
		var out: Float = 0
		var gradeNumber: Float = 0
		for s in subjects {
			if !s.isAvgCalculable() { continue }
			out += Float(s.getFinalAvg()) * s.coef
			gradeNumber += s.coef
		}
		return out/gradeNumber
	}
	
    func getCombiCoefSum() -> Float {
        var coefSum = Float(0)
        for c in subjects {
            coefSum += c.coef
        }
        return coefSum
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

struct Subject: Codable  {

	var name: String
	var tests : [Test]
	var coef: Float
	var plusPoints: Float
	var goal: Float?
    // this should be called combiSubject without s but i cannot change it because of the Codable protocol
	var combiSubjects: CombiSubject?
	
	// Structs can't inherit structs, so I have to do this
	init(meta: SubjectMeta) {
		name = meta.name
		coef = meta.coef
		tests = []
		plusPoints = 0
		if let c = meta.combiMeta {
			combiSubjects = CombiSubject()
			for s in c.subjects {
				combiSubjects?.subjects.append(Subject(meta: s))
			}
		}
	}

	/// only average of the tests, no up rounding but still bonus
	func getAvg() -> Float {
		if let combi = combiSubjects {
			if combi.isAvgCalculable() {
				return combi.getAvg() + plusPoints
			}
		}
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
		if let combi = combiSubjects {
			return combi.isAvgCalculable()
		}
		return tests.count > 0
	}

}

struct Test: Codable {
	var grade: Float
	var maxGrade: Float
	
	init(grade: Float, maxGrade: Float = 60) {
		self.grade = grade
		self.maxGrade = maxGrade
	}
	
}

let EMPTY_YEAR = Year(name: "XXX", subjects: [])


