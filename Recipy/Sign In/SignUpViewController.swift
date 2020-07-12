//
//  SignUpViewController.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/24/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import ProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    @IBAction func signUpButtonDidTapped(_ sender: Any) {
        self.validateFields()
        
        if emailTextField.text! != "" && passwordTextField.text! != ""{
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil{
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                } else{
                    self.performSegue(withIdentifier: "HomeView", sender: nil)
                }
            })
        }
    }
    
    func validateFields() {
        guard let username = self.nameTextField.text, !username.isEmpty else {
            ProgressHUD.showError("Please enter your username")
            return
        }
        
        guard let email = self.emailTextField.text, !email.isEmpty else {
            ProgressHUD.showError("Please enter your email")
            return
        }
        
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            ProgressHUD.showError("Please enter your password")
            return
        }
    }
    
    func setupUI() {

        signUpButton.setTitle("SIGN UP", for: UIControl.State.normal)
        signUpButton.layer.cornerRadius = 25
        signUpButton.clipsToBounds = true
        
        let attributedText = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)])
        
        let attributedSubText = NSMutableAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.black])
        
        attributedText.append(attributedSubText)
        signInButton.setAttributedTitle(attributedText, for: UIControl.State.normal)
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
