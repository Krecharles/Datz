//
//  MainViewAnimations.swift
//  Design Inspiration
//
//  Created by Charel Kremer on 30.03.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import UIKit

extension ViewController {
	
	func animateMenuButton() {
		let isCollapsing = expandMenu.transform == .identity
		
		UIView.animate(withDuration: 0.3, animations: {
			if isCollapsing {
				// collapse
				self.expandMenu.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
				self.hamburgerButton.backgroundColor = #colorLiteral(red: 0.994995892, green: 0.2154319584, blue: 0.4105567634, alpha: 1)
			} else {
				// expand
				self.expandMenu.transform = .identity
				self.hamburgerButton.backgroundColor = #colorLiteral(red: 0.8944122779, green: 0.289709499, blue: 0.4752039495, alpha: 1)
			}
		})
		
		UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
			if !isCollapsing {
				self.trimester1Button.transform = CGAffineTransform(translationX: 0, y: 10)
			} else {
				self.trimester1Button.transform = .identity
			}
		}, completion: nil)
		
		UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
			if !isCollapsing {
				self.trimester2Button.transform = CGAffineTransform(translationX: 7, y: 7)
			} else {
				self.trimester2Button.transform = .identity
			}
		}, completion: nil)
		
		UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
			if !isCollapsing {
				self.trimester3Button.transform = CGAffineTransform(translationX: 10, y: 0)
			} else {
				self.trimester3Button.transform = .identity
			}
		}, completion: nil)
		
		UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
			if !isCollapsing {
				self.yearButton.transform = CGAffineTransform(translationX: 0, y: -10)
			} else {
				self.yearButton.transform = .identity
			}
		}, completion: nil)
	}
	
	func animateTrimesterIndicatorLabel() {
		UIView.animate(withDuration: 0.1, animations:{
			self.trimesterIndicatorLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.3)
		}, completion: { _ in
			UIView.animate(withDuration: 0.1, animations:{
				self.trimesterIndicatorLabel.transform = CGAffineTransform.identity
			})
		})
	}
	
}




