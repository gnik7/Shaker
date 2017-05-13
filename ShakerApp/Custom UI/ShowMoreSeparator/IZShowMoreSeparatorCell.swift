//
//  IZShowMoreSeparatorCell.swift
//  ShakerApp
//
//  Created by Nikita Gil on 18.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

enum ShowTypeCell {
    case SameAuthorShowTypeCell
    case VideoListShowTypeCell
}

protocol IZShowMoreSeparatorCellDelegate: NSObjectProtocol {
    
    func showMoreButtonPressed(type :ShowTypeCell)
}

class IZShowMoreSeparatorCell: UIView {
    
    // var
    var typeCell        : ShowTypeCell?
    weak var delegate   : IZShowMoreSeparatorCellDelegate?
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    /**
     Get IZShowMoreSeparatorCell from xib
     
     - parameter bundle: bundle for search. Default nil
     
     - returns: object IZShowMoreSeparatorCell
     */
    
    class func loadFromXib(bundle : NSBundle? = nil) -> IZShowMoreSeparatorCell? {
        return UINib(
            nibName: IZRouterConstant.kIZShowMoreSeparatorCell,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? IZShowMoreSeparatorCell
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func showMoreButtonPressed(sender: AnyObject) {
        
        if let delegate = self.delegate {
            delegate.showMoreButtonPressed(self.typeCell!)
        }
    }
    
}
