//
//  AppDelegate.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/21/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import CoreData
import FacebookCore
import FirebaseCore
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        var navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor(red: 164/275, green: 164/275, blue: 164/275, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(red: 228/275, green: 105/275, blue: 76/275, alpha: 1)]
        
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self 
        
        let authListener = Auth.auth().addStateDidChangeListener { auth, user in

            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            if user == nil {
                //
                let controller = storyboard.instantiateViewController(withIdentifier: "OnboardViewController") as! OnboardViewController
                self.window?.rootViewController = controller
                self.window?.makeKeyAndVisible()
            } else {
                let controller = storyboard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
                self.window?.rootViewController = controller
                self.window?.makeKeyAndVisible()
            }
    
        }
        
        // Override point for customization after application launch.
        guard let splitViewController = self.window?.rootViewController as? UISplitViewController,
            let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as? UINavigationController else {
                return false
        }
        navigationController.topViewController?.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self
        return true
    }
    
    
    func application(_app: UIApplication, open url: URL,options:[UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool{
        return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    }
    
    //    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    //        if let error = error{
    //            print(error.localizedDescription)
    //            return
    //        }
    //        let deneme = user.authentication
    //        let credentials =  GoogleAuthProvider.credential(withIDToken: (deneme?.idToken)!, accessToken: (deneme?.accessToken)!)
    //        Auth.auth().signIn(with: credentials) { (user, error) in
    //            print("deneme")
    //        }
    //
    //    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("Running sign in")
        if let error = error {
            print("\(error.localizedDescription)")
            return
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print(fullName)
        }
        
        // Firebase sign in
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        print("Google signin credentials -> \(credential)")
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("Firebase sign in error")
                print(error)
                return
            }
            print("User is signed in with Firebase")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
            
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        print("User has disconnected")
        
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        return handled
    }
    
    
}


// MARK: - Split view
extension AppDelegate: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? RecipeDetailViewController else { return false }
        if topAsDetailController.viewModel == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
}

