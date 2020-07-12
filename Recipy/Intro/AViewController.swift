//
//  ViewController.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/22/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//


import UIKit

//MARK: - UIPageViewControllerDataSource
extension AViewController : UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        
        
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        var index = pageContent.pageIndex
        
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        index -= 1;
        return getViewControllerAtIndex(index: index)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        var index = pageContent.pageIndex
        
        
        if (index == NSNotFound)
        {
            return nil;
        }
        index += 1;
        if (index == arrPageTitle.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index: index)
    }
}

class AViewController: UIPageViewController  {
    
    //MARK: - Properties
    var arrPageTitle =  ["You're going to find some delicious recipes with Foodr. Swipe to see how.", "Find some recipes by playing our swiping game. If you see a dish that you like, make sure to swipe right.","By swiping right on a meal you like, that recipe will be added to your personalized list.","You can also search for recipes based off products or the recipe name.", "You are now ready. Click the button below to begin."];
    var titleArray = ["Welcome.", "Pay attention.", "How it works.", "Search.", "You are ready."]
    let pageArray:[UIImage] = [ #imageLiteral(resourceName: "demo"), #imageLiteral(resourceName: "demo"),#imageLiteral(resourceName: "demo"),#imageLiteral(resourceName: "demo"),#imageLiteral(resourceName: "demo")]
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.setViewControllers([getViewControllerAtIndex(index: 0)] as [UIViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        
    }
    
    
    
    //MARK: - Custom Action
    func getViewControllerAtIndex(index: NSInteger) -> PageContentViewController
    {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        
        pageContentViewController.strTitle = "\(index)"
        pageContentViewController.strDesc = "\(arrPageTitle[index])"
        pageContentViewController.stringTitle = "\(titleArray[index])"
        
//        let image:UIImage? = self.pageArray[index]
//        pageContentViewController.image = image
        pageContentViewController.pageIndex = index
        
        return pageContentViewController
    }
}


