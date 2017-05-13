//
//  IZNavigationBar.swift
//  ShakerApp
//
//  Created by Nikita Gil on 14.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

protocol NavigationBarDelegate: NSObjectProtocol {
    
    func searchButtonPressedInNavigationBar()
    func filterButtonPressedInNavigationBar()
    func favoriteButtonPressedInNavigationBar()
    func backButtonPressedInNavigationBar()
    
}

enum NameTypeViewController : String{
    case SingleVideoController
    case LandingPageViewController
    case FilterViewController
    case FavoriteViewController
}


class IZNavigationBar: UIView {
    
    // @IBOutlet
    
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var filterImage: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    

    @IBOutlet weak var badgeFilterView: UIView!
    @IBOutlet weak var badgeFilterLabel: UILabel!
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
   
    // var
    weak var delegate           : NavigationBarDelegate?
    var nameTypeViewControler   : NameTypeViewController?
   
//*****************************************************************
// MARK: - Init
//*****************************************************************
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.badgeFilterView.layer.cornerRadius = self.badgeFilterView.frame.width / 2
        self.badgeFilterView.layer.borderWidth = 1.0
        self.badgeFilterView.layer.borderColor = UIColor.whiteColor().CGColor
        self.badgeFilterView.hidden = true
        
        self.hideBackButton()
        
        if let type = self.nameTypeViewControler as NameTypeViewController? {
            self.changeButtonsOnViewController(type)
        }
        
    }
    
    /**
     Get IZNavigationBar from xib
     
     - parameter bundle: bundle for search. Default nil
     
     - returns: object IZNavigationBar
     */
    
    class func loadFromXib(bundle : NSBundle? = nil) -> IZNavigationBar? {
        return UINib(
            nibName: IZRouterConstant.kNavigationBar,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? IZNavigationBar
    }
    
//*****************************************************************
// MARK: - Action
//*****************************************************************
    
    @IBAction func searchButtonPressed(sender: UIButton) {
        
        if let delegate = delegate {
            delegate.searchButtonPressedInNavigationBar()
        }
    }
    
    @IBAction func filterButtonPressed(sender: AnyObject) {
        if let delegate = delegate {
            delegate.filterButtonPressedInNavigationBar()
        }
    }
    
    @IBAction func favoriteButtonPressed(sender: UIButton) {

        if let delegate = delegate {
            delegate.favoriteButtonPressedInNavigationBar()
        }
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        if let delegate = delegate {
            delegate.backButtonPressedInNavigationBar()
        }
    }
}

extension IZNavigationBar {
    
    //*****************************************************************
    // MARK: - Buttons State
    //*****************************************************************
    
    func updateFilterBadge(number :Int) {
        if number > 0 {
            self.badgeFilterLabel.text = String(number)
            self.badgeFilterView.hidden = false

        } else if number == 0 {
            self.badgeFilterLabel.text = ""
            self.badgeFilterView.hidden = true
        }
    }
    
    func changeStateOfFilter(isActive :Bool) {
        
        if isActive {
            self.filterImage.image = UIImage(named: "filter_active_nav_bar")
            self.filterButton.enabled = false
        } else {
            self.filterImage.image = UIImage(named: "filter_inactive_nav_bar")
            self.filterButton.enabled = true
        }
    }
    
    func changeStateOfFavorite(isActive :Bool) {
        
        if isActive {
            self.favoriteImageView.image = UIImage(named: "favorite_active_nav_bar")
        } else {
            self.favoriteImageView.image = UIImage(named: "favorite_inactive_nav_bar")
        }
    }
    
    private func hideBackButton() {
        
        self.logoImageView.hidden = false
        self.backImageView.hidden = true
        self.backButton.enabled = false
    }
    
    private func showBackButton() {
        
        self.logoImageView.hidden = true
        self.backImageView.hidden = false
        self.backButton.enabled = true
    }
    
    func changeButtonsOnViewController(type :NameTypeViewController) {
        
        switch type {
            case NameTypeViewController.SingleVideoController:
                self.showBackButton()
            case NameTypeViewController.LandingPageViewController:
                self.hideBackButton()
            case NameTypeViewController.FilterViewController:
                //self.searchButton.enabled = false
                self.showBackButton()
            case NameTypeViewController.FavoriteViewController:
                self.showBackButton()
        }
    }
    
}

