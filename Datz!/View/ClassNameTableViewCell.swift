//
//  ClassMakerTableViewCells.swift
//  Design Inspiration
//
//  Created by Charel Kremer on 02.04.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import UIKit

class ClassNameTableViewCell: UITableViewCell {
	
	@IBOutlet weak var classNameTextField: UITextField!
}

class SubjectCountTableViewCell: UITableViewCell {

	@IBOutlet weak var subjectCountStepper: UIStepper!
	
}

class SubjectTableViewCell: UITableViewCell {

	@IBOutlet weak var subjectNameTextField: UITextField!
	@IBOutlet weak var subjectCoefStepper: UIStepper!
	@IBOutlet weak var subjectCoefLabel: UILabel!
	@IBAction func subjectCoefStepperChanged(_ sender: UIStepper) {
		subjectCoefLabel.text = "\(Int(sender.value))"
	}
}

