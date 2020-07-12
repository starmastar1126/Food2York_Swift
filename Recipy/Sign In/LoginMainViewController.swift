//
//  LoginMainViewController.swift
//  Recipy
//
//  Created by IBM on 7/24/19.
//  Copyright © 2019 AmauryVidal. All rights reserved.
//

import UIKit

class LoginMainViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        
        signInButton.layer.cornerRadius = 25
        signInButton.clipsToBounds = true
        
        signUpButton.layer.cornerRadius = 25
        signUpButton.clipsToBounds = true
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
