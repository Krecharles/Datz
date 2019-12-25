//
//  ClassMakerTableViewController.swift
//  Design Inspiration
//
//  Created by Charel Kremer on 02.04.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import UIKit

class ClassMakerTableViewController: UITableViewController, UITextFieldDelegate {

	var subjectCount = 4

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		switch section {
        case 0: return 2
        case 1: return subjectCount
        case 2: return 1
		default: return 0
		}
		
	}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.section == 2 {
			return tableView.dequeueReusableCell(withIdentifier: "Done")!
		}
		
		if indexPath.section == 0 {
			if indexPath.row == 0 {
				let cell = tableView.dequeueReusableCell(withIdentifier: "ClassName") as! ClassNameTableViewCell
                cell.classNameTextField.delegate = self // necessary for dismissing the keyboard
				return cell
			} else {
				let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCount") as! SubjectCountTableViewCell
                cell.subjectCountStepper.value = Double(subjectCount)
				return cell
			}
		}
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "Subject", for: indexPath) as! SubjectTableViewCell
        cell.subjectNameTextField.delegate = self
        return cell
	}
	
	@IBAction func subjectCountStepperValueChanged(_ sender: UIStepper) {
		subjectCount = Int(sender.value)
		tableView.reloadData()
	}
	
    func parseClassInput(name: String?, subjects: [(String?, String?)]) throws -> Year {
        
        guard let yearName = name else {
            throw "Something went wrong."
        }
        
        if yearName == "" { throw "Class Name must not be empty." }
        if yearName.count > 5 { throw "Class Name must not be longer than 5 characters." }
        
        var out = [SubjectMeta]()
        for sub in subjects {
            guard let subName = sub.0 else { throw "Subject Name must not be empty." }
            guard let subCoef = Float(sub.1!) else { throw "Something went wrong." }
            out.append(SubjectMeta(name: subName, coef: subCoef))
        }
        
        return Year(name: yearName, subjects: out)
    }
    
	@IBAction func doneButtonPressed(_ sender: UIButton) {
		
        let name = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ClassNameTableViewCell).classNameTextField.text
        var subs = [(String?, String?)]()
        for i in 0..<subjectCount {
            let subName = (tableView.cellForRow(at: IndexPath(row: i, section: 1)) as! SubjectTableViewCell).subjectNameTextField.text
            let coef = (tableView.cellForRow(at: IndexPath(row: i, section: 1)) as! SubjectTableViewCell).subjectCoefLabel.text
            subs.append((subName, coef))
        }
        
        do {
            let year = try parseClassInput(name: name, subjects: subs)
            setYear(year: year)
            navigateToMainView()
        } catch {
            showInvalid(errorMessage: "\(error)")
        }

    }
	
	func setYear(year: Year) {
		MyData.activeYear = year
		var i = 0
		let initName = MyData.activeYear.name
		while MyData.allNames.contains(MyData.activeYear.name) {
			i += 1
			MyData.activeYear.name = "\(initName) \(i)"
		}
		MyData.allNames.append(MyData.activeYear.name)
	}
    
    func showInvalid(errorMessage: String) {
        let a = UIAlertController(title: "Invalid Class", message: errorMessage, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(a, animated: true, completion: nil)
    }
    
    func navigateToMainView() {
        self.presentingViewController!.presentingViewController!.dismiss(animated: true, completion: nil)
        viewControllerInstance.notifyComingHome()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
