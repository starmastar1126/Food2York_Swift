//
//  DetailViewController.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/21/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit
import SafariServices

// Tableview Sections
enum Sections: Int {

    case image = 0
    case ingredients = 1
    case details = 2
    
    
    var title: String? {
        switch self {
        

        case .image: return nil
        case .ingredients: return "Ingredients"
        case.details: return "Recipe"
        }
    }
    
    var height: CGFloat {
        switch self {
        
        case .image: return UIScreen.main.bounds.height / 2
        case .ingredients: return 44
        case.details: return 88
        }
    }
}

class RecipeDetailViewController: UITableViewController {
    
    var viewModel: RecipeDetailViewModel?
    var image: UIImage?
    var isComingFromSearch = false
    
    override func viewDidLoad() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(red: 228/275, green: 105/275, blue: 76/275, alpha: 1)]
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(red: 228/275, green: 105/275, blue: 76/275, alpha: 1)]
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = false

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isComingFromSearch && self.isMovingToParent {
        
            navigationController?.isNavigationBarHidden = true
        
        }
        // If there is still an image downloading, cancel it
        viewModel?.cancelImageDownload()
    }
    
    /// Update the user interface for the detail item.
    func configureView() {
        if let viewModel = viewModel {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(red: 228/275, green: 105/275, blue: 76/275, alpha: 1)]
            navigationItem.title = viewModel.title
            viewModel.image { (image) in
                self.image = image
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: Sections.image.rawValue)], with: .automatic)
                }
            }
            
            // retreive the ingredients
            fetchRecipeIngredients()
        }
    }
    
    
    // MARK: - Network
    
    // Fetch additionals detail about the recipe
    func fetchRecipeIngredients() {
        viewModel?.details { (viewModelRecipeDetail) in
            self.viewModel = viewModelRecipeDetail
            // Upate the view with the retrieved details
            DispatchQueue.main.async {
                self.updateIngredients()
            }
        }
    }
    
    func updateIngredients() {
        tableView.reloadSections(IndexSet(integer: Sections.ingredients.rawValue), with: .automatic)
    }
}


// MARK: - UITableView
extension RecipeDetailViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section), let viewModel = viewModel else { return 0 }
        return section == .ingredients ? viewModel.nbIngredients : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Sections(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
//        case .name:
//
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeNameCell", for: indexPath) as? RecipeNameCellI, let lbl = cell.viewWithTag(101) as? UILabel {
//
//                lbl.numberOfLines = 0
//                lbl.text = viewModel!.recipe.title
//                lbl.font = UIFont.boldSystemFont(ofSize: 26.0)
//                lbl.textColor = UIColor.black
//                lbl.textAlignment = .center
//                lbl.sizeToFit()
//                return cell
//            }
//            return UITableViewCell()
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: RecipeImageCell.identifier, for: indexPath) as! RecipeImageCell
            cell.configure(image: image)
            return cell
        case .ingredients:
            let cell = tableView.dequeueReusableCell(withIdentifier: RecipeIngredientCell.identifier, for: indexPath) as! RecipeIngredientCell
            cell.textLabel?.text = String(describing: viewModel?.ingredient(at: indexPath.row))
            return cell
        case .details:
            let cell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailCell.identifier, for: indexPath) as! RecipeDetailCell
            if let viewModel = viewModel {
                cell.configure(recipe: viewModel.recipe, delegate: self)
            }
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Sections(rawValue: section) else { return nil }
        return section.title
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Sections(rawValue: indexPath.section) else { return 0 }
        return section.height
    }
}

// MARK: - URL Action Delegate
extension RecipeDetailViewController: URLActionDelegate {
    func showUrl(url: URL?) {
        if let url = url {
            
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            vc.loadURL = url
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }

}
