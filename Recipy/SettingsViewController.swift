//
//  FavoritesViewController.swift
//  Recipy
//
//  Created by Sucharu on 7/29/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper
import ProgressHUD
import GoogleSignIn
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var privacyBtn: UIButton!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var rateBtn: UIButton!
    
    @IBAction func logout_TouchUpInside(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "LoginMainViewController1")
            self.present(signInVC, animated: true, completion: nil)

        } catch let logoutError {
            print(logoutError)
        }
    }

    
    
    override func viewDidLoad() {
        
        helpBtn.layer.cornerRadius = 7
        helpBtn.clipsToBounds = true
        
        privacyBtn.layer.cornerRadius = 7
        privacyBtn.clipsToBounds = true
        
        rateBtn.layer.cornerRadius = 7
        rateBtn.clipsToBounds = true
        
        termsBtn.layer.cornerRadius = 7
        termsBtn.clipsToBounds = true
        
        shareBtn.layer.cornerRadius = 7
        shareBtn.clipsToBounds = true
        
        logoutBtn.layer.cornerRadius = 7
        logoutBtn.clipsToBounds = true
        
        super.viewDidLoad()
        
    }
    
    @IBAction func helpPressed(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["foodrcontact@gmail.com"])
            mail.setSubject("Feedback")
            mail.setMessageBody("Message here.", isHTML: false)
            present(mail, animated: true, completion: nil)
        } else {
            print("Cannot send mail")
            // give feedback to the user
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Saved")
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
        case MFMailComposeResult.failed.rawValue:
            print("Error: \(String(describing: error?.localizedDescription))")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func sharedPressed(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: ["Check out Foodr on the App Store. It's helping me find tons of brand new recipes!"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    @IBAction func ratePressed(_ sender: Any) {
//        var url  = NSURL(string: "")
//
//        if UIApplication.shared.canOpenURL(url! as URL) {
//            UIApplication.shared.openURL(url! as URL)
//        }
        
        let Username =  "foodr.app" // Your Instagram Username here
        let appURL = URL(string: "instagram://user?username=\(Username)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            let webURL = URL(string: "https://instagram.com/\(Username)")!
            application.open(webURL)
        }
    }
}


