//
//  SubjectViewController.swift
//  Design Inspiration
//
//  Created by Charel Kremer on 29.03.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import UIKit

class SubjectViewController: UIViewController {

	@IBOutlet weak var subjectNameLabel: UILabel!
	@IBOutlet weak var avgLabelGroup: UIView!
	@IBOutlet weak var finalAvgLabel: UILabel!
	@IBOutlet weak var exactAvgLabel: UILabel!
	@IBOutlet weak var coefLabel: UILabel!
	@IBOutlet weak var bonusStepper: ValueStepper!
	@IBOutlet weak var backgroundImageView: UIImageView!
	
	@IBOutlet weak var testsTableView: UITableView!
    
	var trimIndex = 0
	var activeTrimester: Trimester! {
		get {
            MyData.save() // Quick fix. Thus the data displayed in the subject view is always equal to the saved data. 
			return MyData.activeYear.trimesters[trimIndex]
		}
		set {
			MyData.activeYear.trimesters[trimIndex] = newValue
		}
	}
	
	var subjectIndex = 0
	var subject: Subject! {
		get {
			return activeTrimester.subjects[subjectIndex]
		}
		set {
			activeTrimester.subjects[subjectIndex] = newValue
		}
	}
	
	func setInfos() {
		if subject.isAvgCalculable() {
			finalAvgLabel.text = "\(subject.getFinalAvg())"
			exactAvgLabel.text = "\(format(subject.getAvg()))"
		}
		else {
			finalAvgLabel.text = ""
			exactAvgLabel.text = ""
		}
		testsTableView.reloadData()
	}
	
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
		subjectNameLabel.text = NSLocalizedString(subject.name, comment: "")
		coefLabel.text = "coef: \(Int(subject.coef))"
		
		bonusStepper.value = Double(subject.plusPoints)
        
		testsTableView.dataSource = self
		testsTableView.delegate = self
		testsTableView.backgroundColor = .clear
	
		setInfos()
		
		backgroundImageView.image = getBackgroundImage(for: subject.name)
	}
	
	func getBackgroundImage(for name: String) -> UIImage {
		// TODO: implement this better and add more images
		let dic: [String: String] = ["Chimie/Physique": "ChimiePhysique",
									 "Mathématiques 1": "Mathematiques",
									 "Artistique 1": "Artistique",
									 "Artistique 2": "Artistique",
									 "EduMusic 1": "EduMusic",
									 "EduMusic 2": "EduMusic",
									 "Français " : "Francais"]
		
		if let fileName = dic[name] {
			if let image =  UIImage(named: fileName) {
				return image
			} else {
				print("ERROR: image named \(fileName) does not exist!")
				return #imageLiteral(resourceName: "LearnWallpaper")
			}
		}
		
		let simplified = name.folding(options: .diacriticInsensitive, locale: .current)
		
		if let img = UIImage(named: simplified) {
			return img
		} else {
			print("There is no file named '\(simplified)'")
			return #imageLiteral(resourceName: "LearnWallpaper")
		}
		
	}
	
    @IBAction func bonusStepperChanged(_ sender: ValueStepper) {
        subject.plusPoints = Float(sender.value)
        setInfos()
    }
    
	@IBAction func addTestButtonPressed(_ sender: Any) {
		
		let alert = UIAlertController(title: NSLocalizedString("Add a new Test", comment: ""), message: "", preferredStyle: .alert)
        
        // presentation propreties shared between combi an non combi subjects
		alert.addTextField(configurationHandler: { (textField) in
			textField.placeholder = NSLocalizedString("Enter Test Grade", comment: "")
			textField.textAlignment = .center
			textField.keyboardType = .decimalPad
		})
		alert.addTextField(configurationHandler: { (textField) in
			textField.text = "60"
			textField.textAlignment = .center
			textField.keyboardType = .decimalPad
		})
		alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { action in
		}))
		
        // differentiate if it is a combi subject or not
		if let c = subject.combiSubjects {
			for (i, s) in c.subjects.enumerated() {
				alert.addAction(UIAlertAction(title: "\(NSLocalizedString("Add to", comment: "")) \(NSLocalizedString(s.name, comment: ""))", style: .default, handler: { action in
                    if let (grade, maxGrade) = self.checkValidGrade(grade: alert.textFields![0].text!, maxGrade: alert.textFields![1].text!) {
                        self.subject.combiSubjects!.subjects[i].tests.append(Test(grade: grade, maxGrade: maxGrade))
                        self.setInfos()
                    }
				}))
			}
		} else {
			alert.addAction(UIAlertAction(title: NSLocalizedString("Add", comment: "Add a test"), style: .default, handler: { action in
                if let (grade, maxGrade) = self.checkValidGrade(grade: alert.textFields![0].text!, maxGrade: alert.textFields![1].text!) {
					self.subject.tests.append(Test(grade: grade, maxGrade: maxGrade))
					self.setInfos()
                }
            }))
		}
			
			
		self.present(alert, animated: true, completion: nil)
	}
	
    func checkValidGrade(grade: String, maxGrade: String) -> (Float, Float)? {
        if let numGrade = Float(grade),
            let numMaxGrade = Float(maxGrade) {
            if (numMaxGrade != 0) {
                return (numGrade, numMaxGrade)
            }
        }

        // I think either the above or below replacements are obsolete
        let gradeStr = grade.replacingOccurrences(of: ",", with: ".")
        let maxGradeStr = maxGrade.replacingOccurrences(of: ",", with: ".")
        if let numGrade = Float(gradeStr),
            let numMaxGrade = Float(maxGradeStr) {
            
            if (numMaxGrade != 0) {
                return (numGrade, numMaxGrade)
            }
            
        }
        
        
        let a = UIAlertController(title: NSLocalizedString("Unable to parse your grade.", comment: ""),
                                  message: NSLocalizedString("Please enter a valid grade!", comment: ""),
                                  preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(a, animated: true, completion: nil)
        return nil
    }
    
	@IBAction func unwind(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewControllerInstance.notifyComingHome()
    }

}
