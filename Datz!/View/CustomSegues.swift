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
