//
//  SubjectViewAnimations.swift
//  Design Inspiration
//
//  Created by Charel Kremer on 30.03.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import UIKit

extension SubjectViewController {
    
    func swipeInGrade() {
        
        UIView.animate(withDuration: 0.5, delay: 0.1, animations: {
            self.avgLabelGroup.transform = .identity
            self.avgLabelGroup.alpha = 1
        })
    }
    
}
