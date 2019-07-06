//
//  ViewController.swift
//  TextSphere-Example
//
//  Created by cagricolak on 2.07.2019.
//  Copyright © 2019 cagricolak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textSphere: TextSphere!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textSphere.backgroundColor = .yellow
        textSphere.characterLimit = 100
        textSphere.upperTextColor = .red
        textSphere.upperText = "whats my name ?"
        textSphere.placeholderText = "write my name"
        
        textSphere.borderWidth = 1
        textSphere.borderColor = UIColor.red.cgColor
        textSphere.layer.cornerRadius = 2
        
    }
}

