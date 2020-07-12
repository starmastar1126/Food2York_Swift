//
//  LoginMainViewController.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/24/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit

class LoginMainViewController1: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        
        signInButton.layer.cornerRadius = 7
        signInButton.clipsToBounds = true

        signUpButton.layer.cornerRadius = 7
        signUpButton.clipsToBounds = true
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
