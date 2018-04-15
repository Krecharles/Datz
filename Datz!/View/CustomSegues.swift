//
//  CustomSegues.swift
//  Design Inspiration
//
//  Created by Charel Kremer on 29.03.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import UIKit

class TranslateSegue: UIStoryboardSegue {
	
	override func perform() {
		
		let containerView = source.view.superview
		let originalCenter = source.view.center
		
		destination.view.center = originalCenter
		destination.view.transform = CGAffineTransform(translationX: destination.view.frame.width, y: 0)
		
		containerView?.addSubview(destination.view)
		
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
			self.destination.view.transform = CGAffineTransform.identity
			self.source.view.transform = CGAffineTransform(translationX: -self.source.view.frame.width, y: 0)
		}, completion: { succes in
			self.source.present(self.destination, animated: false, completion: nil)
		})
	}
	
}

class FadeUpSegue: UIStoryboardSegue {
	
	static var viewToAnimate: MainTableViewCell?
	
	override func perform() {
		
		let containerView = source.view.superview!
		
		destination.view.frame = containerView.frame
		destination.view.alpha = 0
		containerView.addSubview(destination.view)
		
		let sourceVC = source as! ViewController
		let cell = sourceVC.getCell(name: FadeUpSegue.viewToAnimate!.subjectNameLabel.text!, grade: FadeUpSegue.viewToAnimate!.subjectGradeLabel.text!)
		cell.frame = FadeUpSegue.viewToAnimate!.frame
		let cellOrigin = FadeUpSegue.viewToAnimate!.superview!.convert(cell.frame.origin, to: nil)
		cell.frame.origin = cellOrigin
		cell.circle.alpha = 0
		containerView.addSubview(cell)
		
		let desVC = destination as! SubjectViewController
		let otherLabelOrigin = desVC.subjectNameLabel!.superview!.convert(desVC.subjectNameLabel!.frame.origin, to: nil)
		
		// I don't know why i have to do this
		// I got so many questions this part is so weird
		let label = cell.subjectNameLabel!
		let newLabel = UILabel(frame: label.frame)
		newLabel.frame.origin.y += cellOrigin.y
		newLabel.frame.size.width += 200
		newLabel.font = label.font
		newLabel.text = label.text
		newLabel.textColor = label.textColor
		containerView.addSubview(newLabel)
		label.removeFromSuperview()
		let newLabelOrigin = newLabel.superview!.convert(newLabel.frame.origin, to: nil)
		
		desVC.subjectNameLabel!.alpha = 0
		FadeUpSegue.viewToAnimate!.alpha = 0
		
		UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
			cell.transform = CGAffineTransform(translationX: 0, y: -newLabelOrigin.y + otherLabelOrigin.y)
			newLabel.transform = CGAffineTransform(translationX: 0, y: -newLabelOrigin.y + otherLabelOrigin.y)
			self.destination.view.alpha = 1
			cell.alpha = 0
		}, completion: { succes in
			self.source.present(self.destination, animated: false, completion: nil)
			cell.removeFromSuperview()
			newLabel.removeFromSuperview()
			desVC.subjectNameLabel!.alpha = 1
			FadeUpSegue.viewToAnimate!.alpha = 1
		})
	}
	
}
