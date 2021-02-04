//
//  MainTableViewController.swift
//  Design Inspiration
//
//  Created by Charel Kremer on 29.03.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return activeTrimester.subjects.count
	}
	
	func getCell(name: String, grade: String, color: UIColor = UIColor.lightGray) -> MainTableViewCell {
		let cell = mainTableView.dequeueReusableCell(withIdentifier: "Prototype") as! MainTableViewCell
        cell.subjectNameLabel.text = NSLocalizedString(name, comment: "Name of the subject")
		cell.subjectGradeLabel.text = grade
		cell.circle.backgroundColor = color
		return cell
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if !displaysYear {
			let sub = activeTrimester.subjects[indexPath.row]
			let name = sub.name
			if sub.isAvgCalculable() {
				let grade = sub.getFinalAvg()
				if let g = sub.goal {
//					let f = CGFloat(Float(grade) - g) / 10 + 0.5 // will be used for a later update
					return getCell(name: name, grade: "\(grade)", color: Float(grade) >= g ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1) )
				}
				return getCell(name: name, grade: "\(grade)")
			}
			return getCell(name: name, grade: "")
			
		}
		else {
			let name = MyData.activeYear.subjects[indexPath.row].name
			let grade = MyData.activeYear.isSubjectAvgCalculable(subject: indexPath.row) ?
			"\(MyData.activeYear.getSubjectFinalAvg(subject: indexPath.row))" : ""
			return getCell(name: name, grade: grade)
		}
	}
	
	func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return !displaysYear
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedIndexPath = indexPath
        performSegue(withIdentifier: "SubjectSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indxexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        
        let delta = offset - lastScrollOffset
        
        let minHeight: CGFloat = 175
        let maxHeight: CGFloat = 250
        
        if offset < 0 {
            // pinched from above
            let newHeight = min(avgLabelGroupHeightConstraint.constant - delta + 10, maxHeight) // add 10 else stagnates at 249.5
            avgLabelGroupHeightConstraint.constant = newHeight
        }

        else if avgLabelGroupHeightConstraint.constant > minHeight && lastScrollOffset >= 0 {
            // scrolling down
            avgLabelGroupHeightConstraint.constant -= offset
            if avgLabelGroupHeightConstraint.constant < minHeight {
                avgLabelGroupHeightConstraint.constant = minHeight
            }
            scrollView.contentOffset.y = 0
        }
        
        angleView.setNeedsDisplay()
//        TODO: change angleview angle?
        
        lastScrollOffset = offset
    }
	
	
}
