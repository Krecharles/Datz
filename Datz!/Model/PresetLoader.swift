/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Helpers for loading images and data.
*/

import UIKit
import SwiftUI
import CoreLocation

//let landmarkData: [Landmark] = load("landmarkData.json")

class PresetLoader {

    private static func load(filename: String) -> JSON {
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

    private static func readSubjectMeta(json: JSON, combiMeta: CombiMeta?) -> SubjectMeta {
        return SubjectMeta(name: json["name"].string!, coef: json["coef"].float!, combiMeta: combiMeta)
    }

    /// Loads all the preset years from the classes.json file
    /// it takes about 0.05 seconds
    static func readPresetYears() -> [Year] {
        var allYears = [Year]()
        allYears += readPresetFile(fileName: "classes.json", isPremiere: false)
        allYears += readPresetFile(fileName: "premiereClasses.json", isPremiere: true)
        return allYears
    }
    
    private static func readPresetFile(fileName: String, isPremiere: Bool) -> [Year] {
        let json = load(filename: fileName)
        var out = [Year]()
        for (_, year):(String, JSON) in json {
            var subjects = [SubjectMeta]()
            for (_, s) in year["subjects"] {
                if s["subSubjects"].exists() {
                    // it is a combi Subject
                    var subSubs = [SubjectMeta]()
                    for (_, subSub) in s["subSubjects"] {
                        subSubs.append(PresetLoader.readSubjectMeta(json: subSub, combiMeta: nil))
                    }
                    subjects.append(PresetLoader.readSubjectMeta(json: s, combiMeta: CombiMeta(subjects: subSubs)))
                } else {
                    subjects.append(PresetLoader.readSubjectMeta(json: s, combiMeta: nil))
                }
            }
            out.append(Year(name: year["name"].string!, subjects: subjects, isPremiere: isPremiere))
        }
        return out
    }


}
