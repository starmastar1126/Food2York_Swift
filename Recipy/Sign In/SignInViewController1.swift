//
//  SignInViewController1.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/25/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper
import ProgressHUD
import GoogleSignIn

class SignInViewController1: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet var emailTextField: CustomTextField!
    @IBOutlet var passwordTextField: CustomTextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    
    @IBOutlet weak var orLabel: UILabel!
    
    @IBOutlet weak var screenTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Custom
        
        GIDSignIn.sharedInstance().uiDelegate = self as GIDSignInUIDelegate
        //GIDSignIn.sharedInstance().signInSilently()
//        let gSignIn = GIDSignInButton(frame: CGRect(x: 57.6, y: 160, width: 259.5, height: 56))
        let screenSize: CGRect = UIScreen.main.bounds
        
        
        let cntr = (self.orLabel.frame.origin.y - self.screenTitle.frame.origin.y) / 2.0 + self.screenTitle.frame.origin.y + self.screenTitle.frame.height + -30.0
        print(cntr)
        print(self.orLabel.frame.origin.y, self.screenTitle.frame.origin.y)
        let gSignIn = GIDSignInButton(frame: CGRect(x: 58, y: cntr, width: screenSize.width-116, height: 50))
        view.addSubview(gSignIn)
        
        signInButton.layer.cornerRadius = 7
        signInButton.clipsToBounds = true
        
        
        let forgotText = NSMutableAttributedString(string: "Forgot Password? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)])
        let forgotSubText = NSMutableAttributedString(string: "Reset it.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.black])
        forgotText.append(forgotSubText)
        forgotButton.setAttributedTitle(forgotText, for: UIControl.State.normal)
        
        let signUpText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)])
        
        let signUpSubText = NSMutableAttributedString(string: "Sign Up.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.black])
        
        signUpText.append(signUpSubText)
        signUpButton.setAttributedTitle(signUpText, for: UIControl.State.normal)
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
        
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            ProgressHUD.showError("Please enter your password")
            return
        }
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
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
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.dataService.createFirebaseDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Saved to Keychain")
        performSegue(withIdentifier: "HomeView", sender: nil)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
