//
//  AngleView.swift
//  Design Inspiration
//
//  Created by Charel Kremer on 29.03.18.
//  Copyright © 2018 https://stackoverflow.com/questions/41269309/create-a-diagonal-custom-uiview-in-swift. All rights reserved.
//

import UIKit

@IBDesignable
class AngleView: UIView {
	
	@IBInspectable public var heightA: CGFloat = 0
	@IBInspectable public var heightB: CGFloat = 0
	
	override func draw(_ rect: CGRect) {
		// Drawing code
		// Get Height and Width
        // note: the +30 is there because if the user scrolls the modal up, there is a small space between
        // the bottom of this view and the bottom of the screen that is not rendered.
		let layerHeight = layer.frame.height + 30
		let layerWidth = layer.frame.width
		// Create Path
		let bezierPath = UIBezierPath()
		//  Points
		let pointA = CGPoint(x: 0, y: heightA)
		let pointB = CGPoint(x: layerWidth, y: heightB)
		let pointC = CGPoint(x: layerWidth, y: layerHeight)
		let pointD = CGPoint(x: 0, y: layerHeight)
		// Draw the path
		bezierPath.move(to: pointA)
		bezierPath.addLine(to: pointB)
		bezierPath.addLine(to: pointC)
		bezierPath.addLine(to: pointD)
		bezierPath.close()
		// Mask to Path
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = bezierPath.cgPath
		layer.mask = shapeLayer
	}
}
