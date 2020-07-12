//
//  ResetPasswordViewController.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/24/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit
import ProgressHUD
import FirebaseDatabase
import FirebaseAuth

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var rememberButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        resetButton.setTitle("RESET PASSWORD", for: UIControl.State.normal)
        resetButton.layer.cornerRadius = 25
        resetButton.clipsToBounds = true
        
        
        let rememberText = NSMutableAttributedString(string: "Remember Password? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)])
        
        let rememberSubText = NSMutableAttributedString(string: "Sign In.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.black])
        
        rememberText.append(rememberSubText)
        rememberButton.setAttributedTitle(rememberText, for: UIControl.State.normal)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func resetDidTapped(_ sender: Any) {
        guard let email = self.emailTextField.text, !email.isEmpty else {
            ProgressHUD.showError("Please enter your email to reset your password")
            return
        }
        
        resetPassword(email: email, onSuccess: {
            self.view.endEditing(true)
            ProgressHUD.showSuccess("We have just sent you a password reset email. Please check your inbox and follow the instructions to reset your password.")
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    
    func resetPassword(email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                onSuccess()
            } else {
                onError(error!.localizedDescription)
            }
        }
    }
    
}
