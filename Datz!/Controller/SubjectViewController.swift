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
	@IBOutlet weak var bonusLabel: UILabel!
	@IBOutlet weak var bonusStepper: UIStepper!
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var goalTextField: UITextField!
	
	@IBOutlet weak var testsTableView: UITableView!
	
	var trimIndex = 0
	var activeTrimester: Trimester! {
		get {
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
		if subject.plusPoints < 0 {
			bonusLabel.text = "Bonus \(Int(subject.plusPoints))"
		}
		else if subject.plusPoints > 0 {
			bonusLabel.text = "Bonus +\(Int(subject.plusPoints))"
		}
		else {
			bonusLabel.text = "Bonus"
		}
	
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
	
	override func viewDidLoad() {
        super.viewDidLoad()

		subjectNameLabel.text = subject.name
		coefLabel.text = "coef: \(Int(subject.coef))"
		
		
		bonusStepper.value = Double(subject.plusPoints)
		goalTextField.addDoneToolbar()
		if let g = subject.goal {
			goalTextField.text = "\(format(g))"
		}
		
		
		testsTableView.dataSource = self
		testsTableView.delegate = self
		testsTableView.backgroundColor = .clear
	
		setInfos()
		
		avgLabelGroup.transform = CGAffineTransform(translationX: 400, y: 0)
		
		if let img = UIImage(named: subject.name.folding(options: .diacriticInsensitive, locale: .current)) {
			backgroundImageView.image = img
		} else {
			backgroundImageView.image = #imageLiteral(resourceName: "LearnWallpaper")
			print("There is no file named '\(subject.name)'")
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		swipeInGrade()
	}
	
	@IBAction func bonusStepperChanged(_ sender: UIStepper) {
		subject.plusPoints = Float(sender.value)
		setInfos()
	}
	
	@IBAction func goalTextChanged(_ sender: UITextField) {
		
		if let v = Float(sender.text!) {
			subject.goal = v
		}
		else if sender.text == "" {
			subject.goal = nil
		}
		else {
			sender.text = nil
			let a = UIAlertController(title: "Unable to parse your goal.", message: "Please enter a valid goal!", preferredStyle: .alert)
			a.addAction(UIAlertAction(title: "OK", style: .default))
			self.present(a, animated: true, completion: nil)
		}
		
		setInfos()
		
	}
	
	@IBAction func addTestButtonPressed(_ sender: Any) {
		
		let alert = UIAlertController(title: "Add a new Test", message: "", preferredStyle: .alert)
		alert.addTextField(configurationHandler: { (textField) in
			textField.placeholder = "Enter Test Grade"
			textField.textAlignment = .center
			textField.keyboardType = .decimalPad
		})
		alert.addTextField(configurationHandler: { (textField) in
			textField.text = "60"
			textField.textAlignment = .center
			textField.keyboardType = .decimalPad
		})
		alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
			if let grade = Float(alert.textFields![0].text!.replacingOccurrences(of: ",", with: ".")),
				let maxGrade = Float(alert.textFields![1].text!) {
				self.subject.tests.append(Test(grade: grade, maxGrade: maxGrade))
				self.setInfos()
			} else {
				let a = UIAlertController(title: "Unable to parse your grade.", message: "Please enter a valid grade!", preferredStyle: .alert)
				a.addAction(UIAlertAction(title: "OK", style: .default))
				self.present(a, animated: true, completion: nil)
			}
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
		}))
		
		for i in 0...2 {
			alert.addAction(UIAlertAction(title: "title", style: .default))
		}
		self.present(alert, animated: true, completion: nil)
	}
	
	@IBAction func unwind(_ sender: Any) {
	
		dismiss(animated: true, completion: nil)
	
	}
	

}
