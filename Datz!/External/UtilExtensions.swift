//
//  UtilExtensions.swift
//  Design Inspiration
//
//  Created by Charel Kremer on 02.04.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//
import UIKit

//https://stackoverflow.com/questions/38133853/how-to-add-a-return-key-on-a-decimal-pad-in-swift
extension UITextField {
	
	func addDoneToolbar(onDone: (target: Any, action: Selector)? = nil) {
		let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
		
		let toolbar: UIToolbar = UIToolbar()
		toolbar.barStyle = .default
		toolbar.items = [
			UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
			UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
		]
		toolbar.sizeToFit()
		
		self.inputAccessoryView = toolbar
	}
	
	// Default actions:
	@objc func doneButtonTapped() { self.resignFirstResponder() }
}

extension UIColor {
	
	//https://stackoverflow.com/questions/22868182/uicolor-transition-based-on-progress-value
	func interpolateRGBColorTo(_ end: UIColor, fraction: CGFloat) -> UIColor? {
		let f = min(max(0, fraction), 1)
		
		guard let c1 = self.cgColor.components, let c2 = end.cgColor.components else { return nil }
		
		let r: CGFloat = CGFloat(c1[0] + (c2[0] - c1[0]) * f)
		let g: CGFloat = CGFloat(c1[1] + (c2[1] - c1[1]) * f)
		let b: CGFloat = CGFloat(c1[2] + (c2[2] - c1[2]) * f)
		let a: CGFloat = CGFloat(c1[3] + (c2[3] - c1[3]) * f)
		
		return UIColor(red: r, green: g, blue: b, alpha: a)
	}
	
	// 0 is red, 1 is green
	static func redGreenLerp(fraction: CGFloat) -> UIColor {
		let r = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
		let g = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
		return r.interpolateRGBColorTo(g, fraction: fraction)!
	}
}

var formatter: NumberFormatter {
	let ns = NumberFormatter()
	ns.allowsFloats = true
	ns.decimalSeparator = ","
	ns.maximumFractionDigits = 4
	return ns
}

func format(_ x: Float) -> String {
	return formatter.string(from: NSNumber(value: x))!
}


extension String: Error {}
