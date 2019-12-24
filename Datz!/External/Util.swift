//
//  Util.swift
//  Poubelle
//
//  Created by Charel Kremer on 06.05.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import UIKit



extension CGFloat {
	
	func random() -> CGFloat {
		return CGFloat(arc4random() / UINT32_MAX) * self
	}
	
    static func map(value: CGFloat, istart: CGFloat, istop: CGFloat, ostart: CGFloat, ostop: CGFloat) -> CGFloat {
        return ostart + (ostop - ostart) * ((value - istart) / (istop - istart))
    }
    
    func map(istart: CGFloat, istop: CGFloat, ostart: CGFloat, ostop: CGFloat) -> CGFloat {
        return ostart + (ostop - ostart) * ((self - istart) / (istop - istart))
    }
    
	
}

class Benchmark {
	
	private static var beginTime: Date?
	
	static func start() {
		beginTime = Date()
	}
	
	static func stop() {
		guard let bt = beginTime else { return }
		print("[Benchmark]: \(Date().timeIntervalSince(bt)) Seconds")
	}
}

class Defaults {
	
	static func valueExists(for key: String) -> Bool {
		return UserDefaults.standard.value(forKey: key) != nil
	}
	
}
