//
//  ViewController.swift
//  Design Inspiration
//
//  Created by Charel Kremer on 29.03.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var expandMenu: UIViewX!
	@IBOutlet weak var mainTableView: UITableView!
	
	@IBOutlet weak var hamburgerButton: UIButtonX!
	@IBOutlet weak var trimester1Button: UIButtonX!
	@IBOutlet weak var trimester2Button: UIButtonX!
	@IBOutlet weak var trimester3Button: UIButtonX!
	@IBOutlet weak var yearButton: UIButtonX!
	
	@IBOutlet weak var yearNameLabel: UILabel!
	@IBOutlet weak var trimesterIndicatorLabel: UILabel!
	@IBOutlet weak var finalAvgLabel: UILabel!
	@IBOutlet weak var exactAvgLabel: UILabel!
	
	var displaysYear = false
	
    var trimIndex = 0 {
        didSet {
            UserDefaults.standard.set(trimIndex, forKey: "trimIndex")
        }
    }
	var activeTrimester: Trimester! {
		get {
			return MyData.activeYear.trimesters[trimIndex]
		}
		set {
			MyData.activeYear.trimesters[trimIndex] = newValue
		}
	}
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
		mainTableView.delegate = self
		mainTableView.dataSource = self
		mainTableView.backgroundColor = .clear
        
        if MyData.isKeyPresentInUserDefaults(key: "trimIndex")  {
            trimIndex = UserDefaults.standard.integer(forKey: "trimIndex")
        } else {
            trimIndex = 0
        }
        
        setInfo()
        
        expandMenu.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		setInfo()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "SubjectSegue" {
			let des = segue.destination as! SubjectViewController
			des.trimIndex = trimIndex
			des.subjectIndex = mainTableView.indexPathForSelectedRow!.row
		}
		if segue.identifier == "ClassConfigSegue" {
			MyData.save()
			let des = segue.destination as! ClassConfigTableViewController
			des.didSegueFromMainView = true
		}
	}
	
	func setInfo() {
		yearNameLabel.text = MyData.activeYear.name
		if !displaysYear {
			finalAvgLabel.text = activeTrimester.isAvgCalculable() ? "\(activeTrimester.getFinalAvg())" : ""
			exactAvgLabel.text = activeTrimester.isAvgCalculable() ? "\(format(activeTrimester.getAvg()))" : ""
		}
		else {
			finalAvgLabel.text = MyData.activeYear.isAvgCalculable() ? "\(MyData.activeYear.getFinalAvg())" : ""
			exactAvgLabel.text = MyData.activeYear.isAvgCalculable() ? "\(format(MyData.activeYear.getAvg()))" : ""
		}
		
		trimesterIndicatorLabel.text = displaysYear ? "Year Average" : "Trimester \(trimIndex+1)"
		
		mainTableView.reloadData()
	}
	
	@IBAction func hamburgerPressed(_ sender: UIButtonX) {
		animateMenuButton()
	}

	@IBAction func trimester1ButtonPressed(_ sender: UIButtonX) {
		trimIndex = 0
		displaysYear = false
		setInfo()
		animateMenuButton()
		animateTrimesterIndicatorLabel()
	}
	
	@IBAction func trimester2ButtonPressed(_ sender: UIButtonX) {
		trimIndex = 1
		displaysYear = false
		setInfo()
		animateMenuButton()
		animateTrimesterIndicatorLabel()
	}
	
	@IBAction func trimester3ButtonPressed(_ sender: UIButtonX) {
		trimIndex = 2
		displaysYear = false
		setInfo()
		animateMenuButton()
		animateTrimesterIndicatorLabel()
	}
	
	@IBAction func yearButtonPressed(_ sender: UIButtonX) {
		displaysYear = true
		setInfo()
		animateMenuButton()
		animateTrimesterIndicatorLabel()
	}
	
}





