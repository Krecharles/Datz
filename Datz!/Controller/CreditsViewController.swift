//
//  CreditsViewController.swift
//  Datz!
//
//  Created by Charel Kremer on 15.05.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

    @IBAction func unwind(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func showGithub(_ sender: Any) {
        if let url = URL(string: "https://github.com/Krecharles/Datz") {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
