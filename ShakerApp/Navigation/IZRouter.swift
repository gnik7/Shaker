//
//  IZRouter.swift
//  ShakerApp
//
//  Created by Nikita Gil on 15.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//


import UIKit

class IZRouter {
    
    private var navigationController : UINavigationController?
    
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    init(navigationController :UINavigationController)  {
       
        self.navigationController = navigationController
    }
    
    func popViewController(animated: Bool) {
        self.navigationController?.popViewControllerAnimated(animated)
    }
    
    func visibleViewController() -> UIViewController {
        return (self.navigationController?.visibleViewController)!
    }
    
    func setupLandingPageToRootViewController () {
        
        let mainViewController = self.viewControllerWithClass(IZRouterConstant.kLandingPageViewController, storybordName: StoryboardsConstant.kMain)
        
        UIApplication.sharedApplication().delegate?.window??.rootViewController = mainViewController
    }
    
    //*****************************************************************
    // MARK: - Private
    //*****************************************************************
    
    private func navigationControllerWithID(identifier :String, name :String) -> UINavigationController {
        
        let storyboard = UIStoryboard.init(name: name, bundle: nil)
        let navigationController = storyboard.instantiateViewControllerWithIdentifier(identifier) as! UINavigationController
        
        return navigationController
    }
        
    private func viewControllerWithClass(className: String, storybordName :String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: storybordName, bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier(String(className))
        return viewController
    }
    
    
    //*****************************************************************
    // MARK: - Show Controllers
    //*****************************************************************
    
    func popToRootViewController() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func searchViewController() -> IZSearchViewController {
        let viewController = self.viewControllerWithClass(IZRouterConstant.kSearchViewConroller, storybordName: StoryboardsConstant.kMain) as! IZSearchViewController
        return viewController
    }

    //Filter1 ViewController
    func showFilterOneViewController() {
        
        let filterViewController = self.viewControllerWithClass(IZRouterConstant.kFilter1ViewConroller, storybordName: StoryboardsConstant.kFilter) as! IZFilter1ViewConroller
        
        filterViewController.typeController = NameTypeViewController.FilterViewController
        self.navigationController?.pushViewController(filterViewController, animated: true)
    }
    
    //Filter2 ViewController
    func showFilterTwoViewController(item :IZFilterCategoryModel, currentSelf: IZFilter1ViewConroller ) {
    
        let filterViewController = self.viewControllerWithClass(IZRouterConstant.kFilter2ViewConroller, storybordName: StoryboardsConstant.kFilter) as! IZFilter2ViewConroller
        
        filterViewController.categoryItem = item
        filterViewController.delegate = currentSelf
        
        filterViewController.typeController = NameTypeViewController.FilterViewController
        self.navigationController?.pushViewController(filterViewController, animated: true)
    }
    
    //Single Video ViewController
    func showSingleVideoViewController( videoModel :IZLandingModel? ) {
        
        let viewController = self.viewControllerWithClass(IZRouterConstant.kSingleVideoViewController, storybordName: StoryboardsConstant.kVideo) as! IZSingleVideoViewController

        viewController.singleVideo = videoModel
        viewController.typeController = NameTypeViewController.SingleVideoController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //Favorite Video ViewController
    func showFavoriteViewController() {
        
        let viewController = self.viewControllerWithClass(IZRouterConstant.kIZFavoriteViewController, storybordName: StoryboardsConstant.kVideo) as! IZFavoriteViewController
        
        viewController.typeController = NameTypeViewController.FavoriteViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // Show search from filter
    func showSearchFromFilter() {
        
        let mainViewController = self.viewControllerWithClass(IZRouterConstant.kLandingPageViewController, storybordName: StoryboardsConstant.kMain) as? IZLandingPageViewController
        self.navigationController?.pushViewController(mainViewController!, animated: true, completion: { (_) in
            mainViewController!.searchButtonPressedInNavigationBar()
        })
    }
    
    //*****************************************************************
    // MARK: - Show Controllers
    //*****************************************************************
    
    class func topViewController() -> UIViewController {
        
        return (UIApplication.sharedApplication().keyWindow?.rootViewController)!
    }
    

}
