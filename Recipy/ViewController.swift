//
//  ViewController.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/20/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit
import Koloda
import SDWebImage


private var numberOfCards: Int = 4

class ViewController: UIViewController {
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    fileprivate var availableReciepies:[Recipe] = []
    
    var currentPage:Int = 1
    var isLoading = false
    fileprivate var dataSource: [UIImage] = {
        var array: [UIImage] = []
        for index in 0..<numberOfCards {
            array.append(UIImage(named: "cards_\(index + 1)")!)
        }
        
        return array.shuffled()
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        FirebaseDataHandler.shared.saveUserEmail() 
        super.viewDidLoad()
        
        self.kolodaView.backgroundCardsTopMargin = 2.0
        self.kolodaView.countOfVisibleCards = 2
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
//        loadRecepiesFromFork()
        loadRandomRecipiesFromSpoonacular()
    }
    
    func loadRecepiesFromFork() {
        
        self.isLoading = true
        RecipeAPI.shared.getRecipesSortedByRating(page: currentPage) { (list) in
                self.isLoading = false
            if self.currentPage == 1 {
                self.availableReciepies = list.shuffled()
                DispatchQueue.main.async {
                    
                    self.kolodaView.delegate = self
                    self.kolodaView.dataSource = self
                    self.kolodaView.reconfigureCards()
                    self.kolodaView.reloadData()
                }
         
            } else {
                self.availableReciepies.append(contentsOf: list.shuffled())
            }
            self.currentPage += 1
        }
        
    }
    
    func loadRandomRecipiesFromSpoonacular() {
        
//        let limitLicense : NSNumber = true
//        let tags = "vegetarian, dessert"
//        let number : NSNumber = 1
//        var apiInstance = OAIDefaultApi()
//
//        apiInstance.getRandomRecipes(withLimitLicense: limitLicense, tags: tags, number: number) { (output, error) in
//            if ((output) != nil) {
//                print("\(output)")
//            }
//            if ((error) != nil) {
//                print("Error calling OAIDefaultApi->getRandomRecipes: \(error)")
//            }
//        }
        self.isLoading = true
        RecipeAPI_new.shared.getRandomRecipes(randomcount: 10) { (list) in
            self.isLoading = false
            if self.currentPage == 1 {
                self.availableReciepies = list.shuffled()
                DispatchQueue.main.async {
                    self.kolodaView.delegate = self
                    self.kolodaView.dataSource = self
                    self.kolodaView.reconfigureCards()
                    self.kolodaView.reloadData()
                }
            }
            else {
                self.availableReciepies.append(contentsOf: list.shuffled())
            }
            self.currentPage += 1
        }
    }
    
    
    // MARK: IBActions
    
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
}

// MARK: KolodaViewDelegate

extension ViewController: KolodaViewDelegate {
    
    //
    //
    // Run out of cards
    //
    //
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView, viewForCardAt index: Int) {
        
    }
    
    
    /*
     WHERE YOU WILL PUT THE PRESSED ACTION
     */
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        
        if direction == .left {
            
            
        } else if direction == .right {
            
            let toSaveObject = self.availableReciepies[index]
            
            FirebaseDataHandler.shared.addRecipeToFirebase(with: toSaveObject) { (_) in
                
            }
            
            //            var savedList = [Recipe]()
            //
            //            if let data = UserDefaults.standard.data(forKey: "savedRecipes") {
            //                if let list = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Recipe]{
            //
            //                    savedList = list
            //
            //                }
            //            }
            //
            //            if !savedList.contains(where: { (re) -> Bool in
            //                re.recipeId == toSaveObject.recipeId
            //            }) {
            //
            //                savedList.append(toSaveObject)
            //
            //            }
            //
            //            let data1 = NSKeyedArchiver.archivedData(withRootObject: savedList)
            //
            //            UserDefaults.standard.set(data1, forKey: "savedRecipes")
            //            UserDefaults.standard.synchronize()
            
        }
        
        
    }
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        
        let toSaveObject = self.availableReciepies[index]
        
        FirebaseDataHandler.shared.addRecipeToFirebase(with: toSaveObject) { (_) in
        }
        
    }
}

// MARK: KolodaViewDataSource

extension ViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return availableReciepies.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let frm = self.kolodaView.frame

        let vw = UIView(frame: CGRect.init(x: 0.0, y: 0.0, width: frm.size.width, height: frm.height))

        let imageView = UIImageView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: frm.size.width, height: frm.size.height))
        imageView.image = dataSource[0]
        
        imageView.backgroundColor = UIColor.gray
        imageView.sd_setImage(with: URL(string: availableReciepies[index].imageUrl), placeholderImage: dataSource[0], options: SDWebImageOptions.highPriority) { (image, _, _, _) in
            
            DispatchQueue.main.async {
                if  image != nil {
                   // imageView.image = image
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    vw.sendSubviewToBack(imageView)
                }
                
            }
        }
        
        if (index + 10) > self.availableReciepies.count && !self.isLoading {
            self.loadRecepiesFromFork()
        }
        
        imageView.backgroundColor =  UIColor.red
        
        let lbl  = UILabel(frame: CGRect.init(x: 0.0, y: frm.size.height - 40.0, width: frm.size.width, height: 40.0))
        lbl.text = availableReciepies[index].title
        lbl.backgroundColor = UIColor.white
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 20.0)
        lbl.font = UIFont(name: "Proxima Nova Alt", size: 20)
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        
        let heightToAdjust = lbl.intrinsicContentSize.height + 24.0
        print("recipe Title",availableReciepies[index].title)
        imageView.frame.size.height = frm.height - heightToAdjust
        lbl.frame.origin.y  = frm.height - heightToAdjust
        lbl.frame.size.height = heightToAdjust - 18.0
        lbl.frame.size.width = frm.width
        lbl.layoutIfNeeded()
        lbl.backgroundColor = UIColor.white
        vw.backgroundColor = .white
        vw.addSubview(imageView)
        vw.addSubview(lbl)
        vw.bringSubviewToFront(lbl)
        vw.layoutIfNeeded()
        vw.layoutSubviews()
        return vw
    }
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        
        if let vw = Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)![0] as? OverlayView {

              return vw
        }
        
      return nil
        
    }
}

