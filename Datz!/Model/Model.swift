//
//  Data.swift
//  Grades
//
//  Created by Charel Kremer on 22.03.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import Foundation

struct Year : Codable {
	var name: String // 3MB
	var subjects: [SubjectMeta]
	var trimesters: [Trimester]
	
	init(name: String, subjects: [SubjectMeta], trimesterCount: Int = 3) {
		self.name = name
		self.subjects = subjects
		
		var subs = [Subject]()
		for s in subjects {
			if let c = s as CombiSubjectMeta {
				subs.append(c)
			}
			else {
				subs.append(Subject(meta: s))
			}
		}
		
		trimesters = []
		for _ in 0..<trimesterCount {
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
		for t in trimesters {
			if t.subjects[subject].isAvgCalculable() {
				valids += 1
				out += t.subjects[subject].getAvg()
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
				out += Float(getSubjectAvg(subject: i) * subjects[i].coef)
				gradeNumber += subjects[i].coef
			}
			
		}
		
		return out/gradeNumber
		
	}
	
	func getFinalAvg() -> Int {
		return Int(ceil(getAvg()))
	}
	
}

//protocol SubjectMeta : Codable {
//	var name: String {get set}// Mathématiques
//	var coef: Float  {get set}// 4
//}

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

struct Test: Codable {
	var grade: Float
	var maxGrade: Float
	
	init(grade: Float, maxGrade: Float = 60) {
		self.grade = grade
		self.maxGrade = maxGrade
	}
	
}




