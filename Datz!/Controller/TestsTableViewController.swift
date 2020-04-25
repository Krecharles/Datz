//
//  TestsTableViewController.swift
//  Design Inspiration
//
//  Created by Charel Kremer on 30.03.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import UIKit

extension SubjectViewController : UITableViewDataSource, UITableViewDelegate {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		if let c = subject.combiSubjects {
			return c.subjects.count
		}
		return 1
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if let c = subject.combiSubjects {
			return "    \(NSLocalizedString(c.subjects[section].name, comment: "")) | coef: \(format(c.subjects[section].coef))/\(format(c.getCombiCoefSum()))"
		}
		return ""
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let c = subject.combiSubjects {
			return c.subjects[section].tests.count
		}
		return subject.tests.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let test: Test!
		if let c = subject.combiSubjects {
			test = c.subjects[indexPath.section].tests[indexPath.row]
		} else {
			test = subject.tests[indexPath.row]
		}
		let cell = tableView.dequeueReusableCell(withIdentifier: "Prototype") as! TestTableViewCell
		let ns = formatter
		cell.testLabel.text = "\(ns.string(from: NSNumber(value: test.grade))!) / \(ns.string(from: NSNumber(value: test.maxGrade))!)"
		if let g = subject.goal {
			cell.circle.backgroundColor = Float(test.grade) >= g ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
		return .delete
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if subject.combiSubjects != nil {
			subject.combiSubjects!.subjects[indexPath.section].tests.remove(at: indexPath.row)
		} else {
			subject.tests.remove(at: indexPath.row)
		}
		tableView.deleteRows(at: [indexPath], with: .automatic)
		setInfos()
	}

}
