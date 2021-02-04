//
//  ViewController.swift
//  Design Inspiration
//
//  Created by Charel Kremer on 29.03.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import UIKit

// really bad code but fuck apple
var viewControllerInstance: ViewController!

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
	
    @IBOutlet weak var avgLabelGroupHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var angleView: AngleView!
    
    var displaysYear = false
    
    var lastScrollOffset: CGFloat = 0
    
    var selectedIndexPath: IndexPath?
	
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
        
        viewControllerInstance = self
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        if MyData.isFirstLaunch() {
            // the first time the app is opened it imposes to choose a year
            performSegue(withIdentifier: "ClassConfigSegue", sender: self)
        }
        
    }
	
    func notifyComingHome() {
        print("Coming Home")
        setInfo()
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "SubjectSegue" {
			let des = segue.destination as! SubjectViewController
			des.trimIndex = trimIndex
            des.subjectIndex = self.selectedIndexPath!.row
		}
		if segue.identifier == "ClassConfigSegue" {
			MyData.save()
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
		
        if isTrue(MyData.activeYear.isPremiere) {
            trimester1Button.setTitle("S1", for: .normal)
            trimester2Button.setTitle("S2", for: .normal)
            trimester3Button.setTitle("EX", for: .normal)
            if displaysYear {
                trimesterIndicatorLabel.text = NSLocalizedString("Year Average", comment: "")
            } else {
                trimesterIndicatorLabel.text = [
                    "\(NSLocalizedString("Semester", comment: "")) 1",
                    "\(NSLocalizedString("Semester", comment: "")) 2",
                    NSLocalizedString("Examen", comment: "")][trimIndex]
            }
        } else {
            trimester1Button.setTitle("T1", for: .normal)
            trimester2Button.setTitle("T2", for: .normal)
            trimester3Button.setTitle("T3", for: .normal)
            if displaysYear {
                trimesterIndicatorLabel.text = NSLocalizedString("Year Average", comment: "")
            } else {
                trimesterIndicatorLabel.text = [
                "\(NSLocalizedString("Trimester", comment: "")) 1",
                "\(NSLocalizedString("Trimester", comment: "")) 2",
                "\(NSLocalizedString("Trimester", comment: "")) 3"][trimIndex]
            }
        }
        
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

