//
//  ResetPasswordController1.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/26/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper
import ProgressHUD
import GoogleSignIn

class ResetPasswordController1: UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var emailTextField: CustomTextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Custom
        let signInText = NSMutableAttributedString(string: "Have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)])
        
        let signInSubText = NSMutableAttributedString(string: "Sign In.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.black])
        
        signInText.append(signInSubText)
        signInButton.setAttributedTitle(signInText, for: UIControl.State.normal)
        
        resetButton.layer.cornerRadius = 7
        resetButton.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("SB: found user")
            performSegue(withIdentifier: "HomeView", sender: nil)
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: {(user, error) in
            if error != nil {
                print("Problem authenticating with Firebase - \(String(describing: error))")
            } else {
                print("Successfully authenticated with Firebase!")
                if let validUser = user {
                    //                    self.completeSignIn(id: validUser.uid, userData: ["provider": credential.provider])
                    self.performSegue(withIdentifier: "HomeView", sender: nil)
                }
            }
        })
    }
    
    func validateFields() {
        guard let email = self.emailTextField.text, !email.isEmpty else {
            ProgressHUD.showError("Please enter your email")
            return
        }
    }
    
    @IBAction func resetButtonpressed(_ sender: Any) {
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
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
