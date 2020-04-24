//
//  CreditsViewController.swift
//  Datz!
//
//  Created by Charel Kremer on 15.05.18.
//  Copyright © 2018 charelkremer. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    @IBAction func unwind(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        textView.text = NSLocalizedString("If you find a bug, your class is missing, a subject has the wrong coefficient or if you have an improvement idea, feel free to open an issue on GitHub. I will try my best to solve your problems. ", comment: "")
    }
    
    @IBAction func showGithub(_ sender: Any) {
        if let url = URL(string: "https://github.com/Krecharles/Datz") {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
