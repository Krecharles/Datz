/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Helpers for loading images and data.
*/

import UIKit
import SwiftUI
import CoreLocation

//let landmarkData: [Landmark] = load("landmarkData.json")

func load(filename: String) -> JSON {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let json = try JSON(data: data)
        return json
    } catch {
        fatalError("Couldn't parse \(filename):\n\(error)")
    }
}

func readSubjectMeta(json: JSON, combiMeta: CombiMeta?) -> SubjectMeta {
    if let co = combiMeta {
        print(co)
    }
    return SubjectMeta(name: json["name"].string!, coef: json["coef"].float!, combiMeta: combiMeta)
}

/// Loads all the preset years from the classes.json file
/// it takes about 0.05 seconds
func readPresetYears() -> [Year] {
    let json = load(filename: "classes.json")
    var out = [Year]()
    for (_, year):(String, JSON) in json {
        var subjects = [SubjectMeta]()
        for (_, s) in year["subjects"] {
            if s["subSubjects"].exists() {
                // it is a combi Subject
                var subSubs = [SubjectMeta]()
                for (_, subSub) in s["subSubjects"] {
                    subSubs.append(readSubjectMeta(json: subSub, combiMeta: nil))
                }
                subjects.append(readSubjectMeta(json: s, combiMeta: CombiMeta(subjects: subSubs)))
            } else {
                subjects.append(readSubjectMeta(json: s, combiMeta: nil))
            }
        }
        if let isPremiere = year["isPremiere"].bool {
            out.append(Year(name: year["name"].string!, subjects: subjects, isPremiere: isPremiere))
        } else {
            out.append(Year(name: year["name"].string!, subjects: subjects, isPremiere: false))
        }
        
    }
    return out
}
