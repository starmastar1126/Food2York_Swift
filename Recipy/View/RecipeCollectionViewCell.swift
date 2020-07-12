//
//  RecipeCollectionViewCell.swift
//  Recipy
//
//  Created by Sucharu on 11/08/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit
import SDWebImage

class RecipeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        self.foodImageView.layer.cornerRadius = 8.0
        self.foodImageView.layer.masksToBounds = true
    }
    func configureCell(with rcp:Recipe, AndSetFavoorite isFavourite:Bool) {
        
        self.name.text = rcp.title
        self.source.text  = rcp.sourceName
        self.foodImageView.sd_setImage(with: URL(string: rcp.imageUrl)) { (image, _, _, _) in
            
            if image != nil {
                self.foodImageView.image = image
                self.foodImageView.contentMode = .scaleAspectFill
                self.foodImageView.clipsToBounds = true
            }
        }
        if isFavourite {
            
            self.statusImageView.image = UIImage.init(named: "icons8-ok-96")
            
            
        } else {
            
            self.statusImageView.image = UIImage.init(named: "icons8-add-96")
            
        }
        
    }
    
    
    
}
