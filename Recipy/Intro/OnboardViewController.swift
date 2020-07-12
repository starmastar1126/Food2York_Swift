//
//  OnboardViewController.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/22/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit

import UIKit

//MARK: - controlOnboardDelegate
extension OnboardViewController : controlOnboardDelegate{
    func updatePageControl(index: Int) {
        pageControl.currentPage = index
        print("Update index",index)
    }
}
class OnboardViewController: UIViewController {
    @IBOutlet weak var btn: UIButton!
    
    //MARK: - IBOutlet Properties
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        btn.layer.cornerRadius = 7
        btn.clipsToBounds = true
        super.viewDidLoad()
        Helper.shared.onboardDelegate = self
        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBAction
    @IBAction func continueAction(_ sender: UIButton) {
    }
    
    
}
