//
//  ModelProtocols.swift
//  Datz!
//
//  Created by Charel Kremer on 23/12/2019.
//  Copyright © 2019 charelkremer. All rights reserved.
//

import Foundation

/// A year is composed of 3 normal sections and 1 summary section.
/// The summary section is implemented in the year itself and not its own class
/// Usually, the 3 normal sections are 3 trimesters, but for 1ère,
/// the sections are 2 Semesters and 1 Examen section
protocol YearProtocol: Codable {

    var name: String { get }
    var subjects: [SubjectProtocol] { get }
    var sections: [YearSectionProtocol] { get } // of length 3
    
    init(name: String, subjects: [SubjectProtocol])
    
    func isAvgCalculable() -> Bool
    
    /// returns the year average, not rounded
    func getAvg() -> Float
    
    /// returns the year average rounded, as it appears on the zensur
    func getFinalAvg() -> Int

}

protocol YearSectionProtocol: Codable {
    
    var subjects: [SubjectProtocol] { get }
    
    /// also called ponderation
    /// indicates how much this section contributes to the summary.
    /// For ordinary year this is 3x1, for 1ere 2x1 and 1x6
    var weight: Float { get }
    
    func isAvgCalculable() -> Bool
    
    /// returns the year average, not rounded
    func getAvg() -> Float
    
    /// returns the year average rounded, as it appears on the zensur
    func getFinalAvg() -> Int
    
}


protocol SubjectProtocol: Codable {
    
    var name: String { get }
    var coef: Float { get }
    var tests: [Test] { get }
    var plusPoints: Float { get set }
    var goal: Float? { get set }
    
    /// is null if it is a simple subject,
    /// but if it is not, this is a combi subject
    /// UI is not capable to show deep nested subjects
    var combiSubjects: [SubjectProtocol]? { get }
    
    func isCombiSubject() -> Bool
    
    func isAvgCalculable() -> Bool
    
    /// returns the year average, not rounded
    func getAvg() -> Float
    
    /// returns the year average rounded, as it appears on the zensur
    func getFinalAvg() -> Int

}

/// the information that defines a subject without user data
struct _SubjectMeta : Codable {
    var name: String // Mathématiques
    var coef: Float // 4
    var combiSubjects: [_SubjectMeta]? // if nil this is a simple subject, else combined
    
    init(name: String, coef: Float, combiSubjects: [_SubjectMeta]?) {
        self.name = name
        self.coef = coef
        self.combiSubjects = combiSubjects
    }

    init(name: String, coef: Float) {
        self.init(name: name, coef: coef, combiSubjects: nil)
    }
    
}

extension SubjectProtocol {
    func isCombiSubject() -> Bool {
        // this has to be an extension, as swift does not allow
        // function implementation in protocols
        return self.combiSubjects == nil
    }
}

//protocol TestProtocol: Codable {
//
//    var grade: Float { get }
//    var maxGrade: Float { get }
//
//    init(grade: Float, maxGrade: Float)
//
//}

