//
//  MasterViewController.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/21/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit

class RecipesListViewController: UIViewController {
    
    private let showDetailSegue = "showDetail"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var viewModel = RecipesListViewModel()
    
    var detailViewController: RecipeDetailViewController? = nil
    var savedFavourites:[Recipe] = []
    var cellSize  = CGSize.zero
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
        
        
        self.collectionView.register(UINib.init(nibName: "RecipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "rcpCell")
        //        if let split = self.splitViewController {
        //            let controllers = split.viewControllers
        //            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? RecipeDetailViewController
        //        }
        self.loadForFirstTime()
        addLoadingIndicator()
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        let width = self.collectionView.frame.size.width > self.collectionView.frame.size.height ? self.collectionView.frame.size.height : self.collectionView.frame.size.width
        
        cellSize = CGSize.init(width: width/2.0 - 4.0, height: width/2.0 - 4.0)
        // navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let width = self.collectionView.frame.size.width > self.collectionView.frame.size.height ? self.collectionView.frame.size.height : self.collectionView.frame.size.width
        self.navigationController?.isNavigationBarHidden = true
        cellSize = CGSize.init(width: width/2.0 - 4.0, height: width/2.0 - 4.0)
        FirebaseDataHandler.shared.updateList()
        FirebaseDataHandler.shared.getAllSavedRecipes { (list) in
            
            self.savedFavourites = list
            self.collectionView.reloadData()
        }
    }
    
    func loadForFirstTime() {
        
//        RecipeAPI.shared.getRecipesSortedByRating(page: 1) { (list) in
//            DispatchQueue.main.async {
//                self.insertRecipes(recipes: list.shuffled())
//                self.collectionView.reloadData()
//            }
//        }
        RecipeAPI_new.shared.getRandomRecipes(randomcount: 10) { (list) in
            DispatchQueue.main.async {
                self.insertRecipes(recipes: list.shuffled())
                self.collectionView.reloadData()
            }
        }
        
    }
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showDetailSegue, let recipe  = sender as? Recipe {
            
            let controller = segue.destination as! RecipeDetailViewController
            controller.viewModel = RecipeDetailViewModel(recipe: recipe)
            controller.isComingFromSearch = true
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
            view.endEditing(true)
            
        }
    }
    
    
    // MARK: - API
    
    func fetchRecipes(query: String) {
        // Display an indicator that we're fetching from network
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        viewModel.recipes(matching: query) { recipes in
            DispatchQueue.main.async {
                // Update the tableview from the main thread
                self.insertRecipes(recipes: recipes)
                
                // Hide the indicator
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.loadingMore = false
            }
        }
    }
    
    func insertRecipes(recipes: [Recipe]) {
        if recipes.count > 0 {
            //            self.tableView.beginUpdates()
            viewModel = viewModel.added(recipes: recipes)
            var indexPathsToInsert = [IndexPath]()
            //            let start = self.tableView.numberOfRows(inSection: 0)
            //            let end = start + recipes.count - 1
            //            for i in start...end {
            //                indexPathsToInsert += [IndexPath(row: i, section: 0)]
            //            }
            //            self.tableView.insertRows(at: indexPathsToInsert, with: .automatic)
            self.collectionView.reloadData()
        }
    }
}


// MARK: - UITableView
extension RecipesListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nbRecipes
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.identifier, for: indexPath) as! RecipeCell
        cell.textLabel?.text = viewModel.title(at: indexPath.row)
        
        if let recp = viewModel.recipe(at: indexPath.row),FirebaseDataHandler.shared.isContainRecipe(with: recp.recipeId) {
            
            cell.imageView?.image = UIImage.init(named: "icons8-ok-96")
            
            
        } else {
            
            cell.imageView?.image = UIImage.init(named: "icons8-add-96")
            
        }
        
        cell.imageView?.isUserInteractionEnabled = true
        cell.imageView?.tag = indexPath.row
        cell.imageView?.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(addToList(with:))))
        
        return cell
    }
    
    @objc func addToList(with recogniser:UITapGestureRecognizer) {
        
        
        
        
        if let toSaveObject = viewModel.recipe(at: recogniser.view!.tag) {
            
            FirebaseDataHandler.shared.addRecipeToFirebase(with: toSaveObject) { (val) in
                self.collectionView.reloadData()
            }
        }
    }
}

extension RecipesListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.nbRecipes
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rcpCell", for: indexPath) as! RecipeCollectionViewCell
        if let recp = viewModel.recipe(at: indexPath.row) {
            cell.configureCell(with: recp, AndSetFavoorite: FirebaseDataHandler.shared.isContainRecipe(with: recp.recipeId))
            
        }
        cell.statusImageView.isUserInteractionEnabled = true
        cell.statusImageView.tag = indexPath.row
        cell.statusImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(addToList(with:))))
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let recp = viewModel.recipe(at: indexPath.row) {
            self.performSegue(withIdentifier: showDetailSegue, sender: recp)
        }
    }
    
}

// MARK: - Infinite Scroll
extension RecipesListViewController {
    
    /// Add a loading indicator when we are fetching more recipes
    func addLoadingIndicator() {
        /*
         if loadingSpinner == nil {
         loadingSpinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
         loadingSpinner?.color = UIColor(red: 228/255, green: 105/255, blue: 76/255, alpha: 1)
         loadingSpinner?.hidesWhenStopped = true
         collectionView.bottomRefreshControl = loadingSpinner
         }*/
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // calculates where the user is in the y-axis
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height,
            loadingMore == false,
            !viewModel.noMoreResults,
            let query = searchBar.text {
            
            loadingMore = true
            viewModel = viewModel.incrementedPage()
            fetchRecipes(query: query)
        }
    }
}

// MARK: - Search Bar Delegate
extension RecipesListViewController: UISearchBarDelegate {
    // On return button launch the search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, !query.isEmpty {
            
            // Clear previous results
            viewModel = viewModel.reseted()
            self.collectionView.reloadData()
            view.endEditing(true)
            
            fetchRecipes(query: query)
        }
    }
}

