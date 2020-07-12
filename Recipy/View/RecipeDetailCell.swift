//
//  RecipeDetailCell.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/21/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import Foundation
import UIKit
import WebKit

protocol URLActionDelegate: UIWebViewDelegate {
    func showUrl(url: URL?)
}

class RecipeDetailCell: UITableViewCell {
    static let identifier = "RecipeDetailCellIdentifier"

    @IBOutlet weak var originalButton: UIButton!
    
    private weak var delegate: URLActionDelegate?
    private var instructionURL: URL?
    private var originalURL: URL?
    
    func configure(recipe: Recipe, delegate: URLActionDelegate) {
        self.delegate = delegate
//        publisherLabel.text = recipe.publisher
//        rankLabel.text = "Social rank: \(round(recipe.socialRank))"
//        instructionURL = recipe.f2fUrl
        originalURL = URL(string: recipe.sourceUrl)
        self.originalButton.layer.cornerRadius = 4.0
        self.originalButton.layer.masksToBounds = true
    }

    
    @IBAction func viewOriginal(_ sender: UIButton) {
        delegate?.showUrl(url: originalURL)
    }
}
