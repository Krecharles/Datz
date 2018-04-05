//
//  ClassConfigTableViewController.swift
//  Design Inspiration
//
//  Created by Charel Kremer on 02.04.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import UIKit

class ClassConfigTableViewController: UITableViewController {
	
	var didSegueFromMainView = false // means that it is the first launch
	
	var showsCustomYears = MyData.allNames.count > 0
	
	override func viewDidAppear(_ animated: Bool) {
		if !didSegueFromMainView {
			showGarantueeAlert()
		}
	}
	func showGarantueeAlert() {
		let a = UIAlertController(title: "The Averages are without Guarantee.", message: "They only give an estimate for the actual Average.", preferredStyle: .alert)
		a.addAction(UIAlertAction(title: "OK", style: .default))
		self.present(a, animated: true, completion: nil)
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return showsCustomYears ? 3 : 2
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			if showsCustomYears {
				return MyData.allNames.count
			}
			return MyData.presetYears.count
		case 1:
			if showsCustomYears {
				return MyData.presetYears.count
			}
			return 1 // make your own
		case 2:
			return 1
		default:
			print("Something went wrong")
			return 0
		}
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			if showsCustomYears {
				return "Choose your class"
			}
			return "Choose a pre-configurated class"
		case 1:
			if showsCustomYears {
				return "Choose a pre-configurated class"
			}
			return "Your class is not listed?"
		case 2:
			return "Your class is not listed?"
		default:
			return nil
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var name = ""
		switch indexPath.section {
		case 0:
			if showsCustomYears {
				name = MyData.allNames[indexPath.row]
			} else {
				name = MyData.presetYears[indexPath.row].name
			}
		case 1:
			if showsCustomYears {
				name = MyData.presetYears[indexPath.row].name
			} else {
				name = "Make your own class"
			}
		case 2:
			name = "Make your own class"
		default: break
		}
		
		let cell = UITableViewCell()
		cell.textLabel?.text = name
		cell.accessoryType = .disclosureIndicator
		return cell
		
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.section {
		case 0:
			if showsCustomYears {
				MyData.activeYear = MyData.getYear(name: MyData.allNames[indexPath.row])
				segue()
			} else {
				setYearFromPresets(indexPath: indexPath)
				segue()
			}
		case 1:
			if showsCustomYears {
				setYearFromPresets(indexPath: indexPath)
				segue()
			} else {
				performSegue(withIdentifier: "ClassMakerSegue", sender: self)
			}
		case 2: 
			performSegue(withIdentifier: "ClassMakerSegue", sender: self)
		default: break
		}
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		if showsCustomYears && indexPath.section == 0 && MyData.allNames.count > 0 {
			return true
		}
		return false
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let alert = UIAlertController(title: "Are you sure to delete \(MyData.allNames[indexPath.row])?", message: "All the grades that you set will be lost.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
				self.delete(indexPath: indexPath)
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
			}))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func delete(indexPath: IndexPath) {
		MyData.delete(yearName: MyData.allNames[indexPath.row])
		self.tableView.beginUpdates()
		self.tableView.deleteRows(at: [indexPath], with: .automatic)
		self.tableView.endUpdates()
	}
	
	func setYearFromPresets(indexPath: IndexPath) {
		MyData.activeYear = MyData.presetYears[indexPath.row]
		var i = 0
		let initName = MyData.activeYear.name
		while MyData.allNames.contains(MyData.activeYear.name) {
			i += 1
			MyData.activeYear.name = "\(initName) \(i)"
		}
		MyData.allNames.append(MyData.activeYear.name)
	}
	
	func segue() {
		if didSegueFromMainView {
			self.dismiss(animated: true)
		}
		else {
			performSegue(withIdentifier: "BackSegue", sender: self)
		}
	}
	
}




