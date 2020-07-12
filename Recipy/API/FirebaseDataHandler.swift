//
//  FirebaseDataHandler.swift
//  Recipy
//
//  Created by Sebastian Jolly on 07/30/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import Foundation
import Firebase


class FirebaseDataHandler {
    
    
    private init() {}
    
    static let shared = FirebaseDataHandler()
    
    private let favouriteReference = Database.database().reference().child("Users")
    fileprivate let kFavourtie = "Favorites"
    
    var savedReceipes:[Recipe] = []
    
    var userID:String? {
        
        get {
            return Auth.auth().currentUser?.uid
        }
    }
    var email:String? {
        
        get {
            return Auth.auth().currentUser?.email
        }
    }
    func saveUserEmail() {
        
        if userID == nil {return}
        if email == nil {return}
        
        let ref = favouriteReference.child(userID!).child("Email")
        
        ref.setValue(email!)
        
    }
    func observeChangesInFirebase() {
        
        if userID == nil {return}
        let ref = favouriteReference.child(userID!).child(kFavourtie)
        
        ref.observe(DataEventType.childAdded) { (snapshot) in
            
        }
        
        ref.observe(DataEventType.childRemoved) { (snapshot) in
            
        }

    }
    func deleteAllFavourites() {
        if userID == nil {return}
        let ref = favouriteReference.child(userID!).child(kFavourtie)
        
        ref.setValue(nil)
        
    }
    
    func updateList() {
        
        self.getAllSavedRecipes { (list) in
            self.savedReceipes.removeAll()
            self.savedReceipes = list
        }
        
        
    }
    
    func getAllSavedRecipes(with completionHandler:@escaping(_ list:[Recipe])-> Void) {
        
        if userID == nil {return}
        let ref = favouriteReference.child(userID!).child(kFavourtie)
        self.savedReceipes.removeAll()
        ref.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            
            self.savedReceipes.removeAll()
            if snapshot.exists() {
                
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    if let recp = Recipe.init(json: item.value as! [String:Any]) {
                        self.savedReceipes.append(recp)
                    }
                }
            }
            completionHandler(self.savedReceipes)
            
            
        }
    }
    func saveListToStore(with completionHandler:@escaping(_ isBool:Bool)->Void) {
        
        //        let data1 = NSKeyedArchiver.archivedData(withRootObject: savedReceipes)
        //
        //        UserDefaults.standard.set(data1, forKey: "savedRecipes")
        //        UserDefaults.standard.synchronize()
        //        self.updateList()
        
        completionHandler(true)
        
        
        
    }
    func addRecipeToFirebase(with reciepe:Recipe,For completionHandler:@escaping(_ isBool:Bool)->Void) {
        
        if userID == nil {return}
        let ref = favouriteReference.child(userID!).child(kFavourtie)
        
        
        ref.child(reciepe.recipeId).setValue(reciepe.toJSONForFirebase()) { (err, _) in
            
            if !self.savedReceipes.contains(where: { (re) -> Bool in
                re.recipeId == reciepe.recipeId
            }) {
                
                self.savedReceipes.append(reciepe)
                
            }
            
            self.saveListToStore(with: completionHandler)
            
        }
        
    }
    func deleteRecipeToFirebase(with reciepe:Recipe,For completionHandler:@escaping(_ isBool:Bool)->Void) {
        
        
        
        if userID == nil {return}
        let ref = favouriteReference.child(userID!).child(kFavourtie)
        
        ref.child(reciepe.recipeId).setValue(nil) { (_, _) in
            if let index = self.savedReceipes.firstIndex(where: { (listobj) -> Bool in
                reciepe.recipeId == listobj.recipeId
            }) {
                
                self.savedReceipes.remove(at: index)
            }
            
        }
        
        
        self.saveListToStore(with: completionHandler)
        self.updateList()
        
        
    }
    func isContainRecipe(with recipeID: String) -> Bool {
        
        return self.savedReceipes.contains(where: { (re) -> Bool in
            return re.recipeId == recipeID
        })
        
    }
    
}
