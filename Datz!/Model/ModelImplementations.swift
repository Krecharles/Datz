//
//  ModelImplementations.swift
//  Datz!
//
//  Created by Charel Kremer on 23/12/2019.
//  Copyright © 2019 charelkremer. All rights reserved.
//

import Foundation

//struct _Year: YearProtocol {
//
//    var name: String
//
//    var subjects: [SubjectProtocol]
//
//    var sections: [YearSectionProtocol]
//
//    init(name: String, subjects: [SubjectProtocol]) {
//
//        self.name = name
//        self.subjects = subjects
//
//        /// create YearSections with the given SubjectProtocols
//        var subs = [Subject]()
//        for s in subjects {
//            subs.append(Subject(meta: s))
//        }
//
//        trimesters = []
//        for _ in 0..<trimesterCount {
//            trimesters.append(Trimester(subjects: subs))
//        }
//    }
//
//    func isAvgCalculable() -> Bool {
//        <#code#>
//    }
//
//    func getAvg() -> Float {
//        <#code#>
//    }
//
//    func getFinalAvg() {
//        <#code#>
//    }
//
//
//}
//
//struct _Subject: SubjectProtocol  {
//    
//    var combiSubjects: [SubjectProtocol]?
//    var name: String
//    var tests : [Test]
//    var coef: Float
//    var plusPoints: Float
//    var goal: Float?
//
//    init(meta: _SubjectMeta) {
//        name = meta.name
//        coef = meta.coef
//        tests = []
//        plusPoints = 0
//        if let c = meta.combiSubjects {
//            combiSubjects = [_Subject]()
//            for s in c {
//                combiSubjects?.append(_Subject(meta: s))
//            }
//        }
//    }
//
//    /// only average of the tests, no up rounding but still bonus
//    /// crashes if avg not calculable
//    func getAvg() -> Float {
//        if let combiSubs = combiSubjects {
//            var out: Float = 0.0
//            var coefSum: Float = 0.0
//            for c in combiSubs {
//                if c.isAvgCalculable() {
//                    out += c.getAvg() * c.coef
//                    coefSum += c.coef
//                }
//            }
//            return out * 60 / coefSum + self.plusPoints
//        }
//        var out: Float = 0.0
//        for test in tests {
//            out += test.grade/test.maxGrade
//        }
//        return out * 60.0 / Float(tests.count) + plusPoints
//    }
//
//
//
//    /// respects also pluspoints and up rounding
//    func getFinalAvg() -> Int {
//        let ceiled = ceil(getAvg())
//        // weird line of code coz division sometimes is inaccurate
//        if getAvg() - ceiled + 1 < 0.00001 {
//            return Int(ceiled)-1
//        }
//        return Int(ceil(getAvg()))
//    }
//
//    func isAvgCalculable() -> Bool {
//        if let combiSubs = combiSubjects {
//            for c in combiSubs {
//                if c.isAvgCalculable() {
//                    // if there is at least one avg calculable,
//                    // then the whole avg is calculable
//                    return true
//                }
//            }
//            // if the code gets to here, then
//            // it is a combi subject and no subject is calculable
//            return false
//        }
//        // if it is not a combi subject
//        return tests.count > 0
//    }
//
//}
