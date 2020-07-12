//
//  SignInViewController.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/24/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit
import ProgressHUD
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButtonDidTapped(_ sender: Any) {
        self.validateFields()
        
        if emailTextField.text! != "" && passwordTextField.text! != ""{
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }else{
                    self.performSegue(withIdentifier: "HomeView", sender: nil)
                }
            })
        }
    }
    
    
    func validateFields() {
        
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
        signInButton.setTitle("SIGN IN", for: UIControl.State.normal)
        signInButton.layer.cornerRadius = 25
        signInButton.clipsToBounds = true
        
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)])
        
        let attributedSubText = NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.black])
        
        attributedText.append(attributedSubText)
        signUpButton.setAttributedTitle(attributedText, for: UIControl.State.normal)
        
        let forgotText = NSMutableAttributedString(string: "Forgot Password? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)])
        
        let forgotSubText = NSMutableAttributedString(string: "Reset it.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.black])
        
        forgotText.append(forgotSubText)
        forgotButton.setAttributedTitle(forgotText, for: UIControl.State.normal)
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
