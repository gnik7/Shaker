//
//  IZLangingPageTableViewCell.swift
//  ShakerApp
//
//  Created by Nikita Gil on 14.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit
import Kingfisher


protocol LangingPageTableViewCellDelegate: NSObjectProtocol {
    
    func playButtonPressedInLangingPage(item: IZLandingModel)
    func favoriteButtonPressedInLangingPage(videoId: Int, index : Int)
}

class IZLangingPageTableViewCell: UITableViewCell {
    
    // @IBOutlet
    
    @IBOutlet weak var newView                  : UIView!
    @IBOutlet weak var favoriteStarImageView    : UIImageView!
    @IBOutlet weak var mainImageView            : UIImageView!
    @IBOutlet weak var titleLabel               : UILabel!
    @IBOutlet weak var descriptionLabel         : UILabel!
    @IBOutlet weak var activityIndicatorView    : UIActivityIndicatorView!
    @IBOutlet weak var playButton               : UIButton!
    @IBOutlet weak var favoriteButton           : UIButton!
    
    
    @IBOutlet weak var rightMargingCellConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftMargingCellConstraint: NSLayoutConstraint!
   
    // var
    
    weak var delegate           : LangingPageTableViewCellDelegate?
    private var currentVideo    : IZLandingModel?
    private var idCell          : Int?
    private var indexCell       : Int?
    private var videoUrlCell    : String?
    
//*****************************************************************
// MARK: - Init
//*****************************************************************
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.newView.layer.cornerRadius = 3
        self.selectionStyle = .None
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(5, 0, 5, 0))
    }
    
//*****************************************************************
// MARK: - Set Data
//*****************************************************************
    
    func updateData(item: IZLandingModel, typeController: NameTypeViewController, cellIndex : Int) {
        
        self.currentVideo = item
        self.indexCell = cellIndex
        print(item.idVideo)
        if let id = item.idVideo as Int? {
            self.idCell = id
        }
        
        if let title = item.title as String? {
            self.titleLabel.text = title
        }
        
        if let description = item.university?.title as String? {
            self.descriptionLabel.text = description
        }
        
        if let videoUrl = item.videoUrl as String? {
            self.videoUrlCell = videoUrl
        }
        
        if let isNew = item.isNew as Bool? {
            if isNew {
                self.newView.hidden = false
            } else {
                self.newView.hidden = true
            }
        }
        
        if let isFavorite = item.isFavorite as Bool? {
            if isFavorite {
                self.favoriteStarImageView.hidden = false
            } else {
                self.favoriteStarImageView.hidden = true
            }
        }
        
        if let mainImageUrl = item.cover as String? {
            
            self.activityIndicatorView.hidden = false
            self.activityIndicatorView.startAnimating()
            //if let urlString = NSURL(string: IZHelpConverter.URL(mainImageUrl)) as NSURL? {
            if let urlString = NSURL(string: mainImageUrl) as NSURL? {
                
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.hidden = true
                self.mainImageView.kf_setImageWithURL(urlString , placeholderImage: nil, completionHandler: { (image, error, cacheType, imageURL) in
                    print(error)
                    self.activityIndicatorView.stopAnimating()
                    self.activityIndicatorView.hidden = true
                })
            }
        }
    }
    
    // margin left/right sides
    func updateDataConstraints(dimention :CGFloat) {
        self.rightMargingCellConstraint.constant = dimention
        self.leftMargingCellConstraint.constant = dimention
        
        self.needsUpdateConstraints()
        self.setNeedsLayout()
    }
    
//*****************************************************************
// MARK: - Action
//*****************************************************************
    
    @IBAction func playButtonPressed(sender: UIButton) {
        
        if let delegate = self.delegate as LangingPageTableViewCellDelegate? {
            delegate.playButtonPressedInLangingPage(self.currentVideo!)
        }
    }
    
    @IBAction func favoriteButtonPressed(sender: UIButton) {
        
        if let delegate = self.delegate as LangingPageTableViewCellDelegate? {
            delegate.favoriteButtonPressedInLangingPage((currentVideo?.idVideo)!, index: indexCell!)
        }
    }
}

