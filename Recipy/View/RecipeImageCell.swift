//
//  RecipeImageCell.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/21/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import Foundation
import UIKit

class RecipeImageCell: UITableViewCell {
    static let identifier = "RecipeImageCellIdentifier"
    
    @IBOutlet weak var recipeImageView: UIImageView!
    
    func configure(image: UIImage?) {
        recipeImageView.image = image
    }
}
