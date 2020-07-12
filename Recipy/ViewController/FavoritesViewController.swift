//
//  FavoritesViewController.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/29/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit

class FavoritesViewController: UITableViewController {
    
    private let showDetailSegue = "showDetail1"
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel = RecipesListViewModel()
    
    var detailViewController: RecipeDetailViewController? = nil
    var loadingSpinner: UIActivityIndicatorView? // Spinner to show when we are loading more rows
    var loadingMore: Bool = false {
        didSet {
            if loadingMore {
                loadingSpinner?.startAnimating()
            } else {
                loadingSpinner?.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(red: 228/275, green: 105/275, blue: 76/275, alpha: 1)]
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? RecipeDetailViewController
        }
        
        let bbi =  UIBarButtonItem.init(title: "Clear", style: UIBarButtonItem.Style.plain, target: self, action: #selector(removeAllPressed))
        bbi.tintColor = UIColor(red: 228/275, green: 105/275, blue: 76/275, alpha: 1)
        self.navigationItem.rightBarButtonItem = bbi
        
        let bbi2 =  UIBarButtonItem.init(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editButtonPressed))
        bbi2.tintColor = UIColor(red: 228/275, green: 105/275, blue: 76/275, alpha: 1)
        self.navigationItem.leftBarButtonItem = bbi2
        
        addLoadingIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        navigationController?.isNavigationBarHidden = true
        if let selectedRow = tableView?.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        FirebaseDataHandler.shared.updateList()
        
        FirebaseDataHandler.shared.getAllSavedRecipes { (savedList) in
            
            let newList = savedList.sorted(by: { (r1, r2) -> Bool in
                
                return r1.addedToFavoriteOn > r2.addedToFavoriteOn
            })
            self.viewModel = RecipesListViewModel.init(recipes: newList, page: 1)
            self.tableView.reloadData()
        }
        
    }
    
    @objc func editButtonPressed() {
        
        if !self.tableView.isEditing {
            let bbi2 =  UIBarButtonItem.init(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(editButtonPressed))
            bbi2.tintColor = UIColor(red: 228/275, green: 105/275, blue: 76/275, alpha: 1)
            self.navigationItem.leftBarButtonItem = bbi2
        } else {
            let bbi2 =  UIBarButtonItem.init(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editButtonPressed))
            bbi2.tintColor = UIColor(red: 228/275, green: 105/275, blue: 76/275, alpha: 1)
            self.navigationItem.leftBarButtonItem = bbi2
        }
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
    
    @objc func removeAllPressed() {
        
        let alertVC = UIAlertController.init(title: "Are you sure?", message: "Do you really want to remove all your favorite recipes?", preferredStyle: UIAlertController.Style.alert)
        
        alertVC.addAction(UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.destructive, handler: { (_) in
            
            FirebaseDataHandler.shared.deleteAllFavourites()
            self.viewModel = RecipesListViewModel.init(recipes: [], page: 1)
            self.tableView.reloadData()
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showDetailSegue {
            if let indexPath = self.tableView.indexPathForSelectedRow,
                let recipe = viewModel.recipe(at: indexPath.row) {
                let controller = (segue.destination as! UINavigationController).topViewController as! RecipeDetailViewController
                controller.viewModel = RecipeDetailViewModel(recipe: recipe)
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                view.endEditing(true)
            }
        }
    }
    
    
}


// MARK: - UITableView
extension FavoritesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nbRecipes
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.identifier, for: indexPath) as! RecipeCell
        cell.textLabel?.text = viewModel.title(at: indexPath.row)
        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
//            let vc = UIAlertController.init(title: "Confirm?", message: "Do you want \(String(describing: self.viewModel.title(at: indexPath.row))) from your list?", preferredStyle: UIAlertController.Style.alert)
//
//            vc.addAction(UIAlertAction.init(title: "Yes", style: UIAlertAction.Style.destructive, handler: { (_) in
//
//                self.userConfirmationToDelete(with: indexPath)
//            }))
//            vc.addAction(UIAlertAction.init(title: "No", style: UIAlertAction.Style.default, handler: nil))
//            present(vc, animated: true, completion: nil)
            
            self.userConfirmationToDelete(with: indexPath)
            
        }
        
    }
    func userConfirmationToDelete(with indexPath:IndexPath) {
        
        if let mdl = viewModel.recipe(at: indexPath.row) {
            FirebaseDataHandler.shared.deleteRecipeToFirebase(with: mdl) { (_) in
                
                FirebaseDataHandler.shared.getAllSavedRecipes { (savedList) in
                    let newList = savedList.sorted(by: { (r1, r2) -> Bool in
                        
                        return r1.addedToFavoriteOn > r2.addedToFavoriteOn
                    })
                    self.viewModel = RecipesListViewModel.init(recipes: newList, page: 1)
                    self.tableView.reloadData()
                }
                
                
            }
            
        }
    }
}


// MARK: - Infinite Scroll
extension FavoritesViewController {
    
    /// Add a loading indicator when we are fetching more recipes
    func addLoadingIndicator() {
        if loadingSpinner == nil {
            loadingSpinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
            loadingSpinner?.color = UIColor(red: 228/255, green: 105/255, blue: 76/255, alpha: 1)
            loadingSpinner?.hidesWhenStopped = true
            tableView.tableFooterView = loadingSpinner
        }
    }
    
}


