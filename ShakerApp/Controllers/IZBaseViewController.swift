//
//  IZBaseViewController.swift
//  ShakerApp
//
//  Created by Nikita Gil on 14.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

//Base for IZLandingPageViewController/ IZSingleVideoViewController / IZFavoriteViewController

class IZBaseViewController: UIViewController {
    
    // IBOutlet
    @IBOutlet weak var navigationView: UIView!

    
    //var
    lazy var router :IZRouter = IZRouter(navigationController: self.navigationController!)
    var checkedSubItems: [CheckedSubItemsModel]? = [CheckedSubItemsModel]()
    var typeController :NameTypeViewController = NameTypeViewController.LandingPageViewController
    
    var viewForSearch       :IZSearchViewController?
    var navigationBarView   :IZNavigationBar?
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load navigation
        self.navigationBarView = IZNavigationBar.loadFromXib()
        self.navigationBarView?.frame = navigationView.frame
        self.navigationBarView?.delegate = self
        self.navigationBarView?.changeButtonsOnViewController(typeController)
        
        if typeController == NameTypeViewController.FavoriteViewController  {
            self.navigationBarView?.changeStateOfFavorite(true)
        }
        navigationView.addSubview(self.navigationBarView!)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let countSelected = IZSelectedFiltersManager.sharedInstance.countSelectedCategories()
        self.navigationBarView?.updateFilterBadge(countSelected)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//*****************************************************************
// MARK: - NavigationBarDelegate
//*****************************************************************

extension IZBaseViewController: NavigationBarDelegate {
    
    func searchButtonPressedInNavigationBar() {

        self.viewForSearch = self.router.searchViewController()
        
        let viewFrame = self.view.frame
        viewForSearch!.view.frame = viewFrame
        viewForSearch!.view.opaque = false
        viewForSearch!.view.alpha = 0.0
        viewForSearch?.delegate = self
        self.view.addSubview(viewForSearch!.view)
       
        UIView.transitionWithView(viewForSearch!.view, duration: 0.4, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.viewForSearch!.view.alpha = 1.0
            self.viewForSearch!.view.backgroundColor = UIColor.init(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
            }, completion: { _ in
        })
    }
    
    func filterButtonPressedInNavigationBar() {

        self.router.showFilterOneViewController()
    }
    
    func backButtonPressedInNavigationBar() {
        
        self.router.popToRootViewController()
    }
    
    func favoriteButtonPressedInNavigationBar() {
        if let type = self.typeController as NameTypeViewController? {
            if type == NameTypeViewController.FavoriteViewController {
                return
            }
        }
        self.router.showFavoriteViewController()
    }
}

extension IZBaseViewController : SearchDelegate {
    
    func searchVideoSelected(videoModel :IZLandingModel?) {
        self.router.showSingleVideoViewController(videoModel)
    }
}

