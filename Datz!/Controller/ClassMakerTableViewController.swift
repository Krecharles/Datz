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
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

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
        print("WHAT IS GOING ON?? SUBJECCTCOUNT\(subjectCount)")
		tableView.reloadData()
	}
	
	@IBAction func doneButtonPressed(_ sender: UIButton) {
		if let name = (tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! ClassNameTableViewCell).classNameTextField.text {
			print(name)
			var subs = [SubjectMeta]()
			for i in 0..<subjectCount {
				if let subName = (tableView.cellForRow(at: IndexPath(row: i, section: 2)) as! SubjectTableViewCell).subjectNameTextField.text,
					let coef = Float((tableView.cellForRow(at: IndexPath(row: i, section: 2)) as! SubjectTableViewCell).subjectCoefLabel.text!) {
					subs.append(SubjectMeta(name: subName, coef: coef))
				} else {
					showInvalid()
					return
				}
			}
			let year = Year(name: name, subjects: subs)
			setYear(year: year)
			navigateToMainView()
		} else {
			showInvalid()
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
    
    func showInvalid() {
        let a = UIAlertController(title: "Invalid Class", message: "Please enter a valid Class!", preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(a, animated: true, completion: nil)
    }
    
    func navigateToMainView() {
        performSegue(withIdentifier: "Unwind", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
