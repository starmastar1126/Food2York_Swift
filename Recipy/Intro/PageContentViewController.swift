//
//  PageContentViewController.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/22/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {
    
    //MARK: - IBOutlet Properties
    @IBOutlet weak var labelDescription: UILabel!
//    @IBOutlet weak var InstructionImageView: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    //MARK: - Properties
    var pageIndex: Int = 0
    var strTitle: String!
    var strDesc: String!
    var stringTitle: String!
    var strColorName: UIColor!
//    var image: UIImage!
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelDescription.text = strDesc
//        InstructionImageView.image = image
        labelTitle.text = stringTitle
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Helper.shared.updateOnboardUI(index: pageIndex)
    }
    
    //MARK: - IBAction
    @IBAction func buttonAction(_ sender: UIButton) {
        print("Action")
    }
    
    
}

