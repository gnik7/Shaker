//
//  Filter2TableViewCell.swift
//  ShakerApp
//
//  Created by Nikita Gil on 15.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

protocol Filter2TableViewCellDelegate: NSObjectProtocol {
    
    func checkedCategoryInFilter2(categoryId: Int, categoryName: String?, isNew :Bool)
}


class Filter2TableViewCell: UITableViewCell {

    //IBOutlet
    @IBOutlet weak var checkboxImageView    : UIImageView!
    @IBOutlet weak var titleLabel           : UILabel!
    
    
    //var
    var isChecked           :Bool?
    var checkedCategoryId   : Int?
    weak var delegate       : Filter2TableViewCellDelegate?
    
    
//*****************************************************************
// MARK: - Init
//*****************************************************************
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
    
    func updateData(itemIndex: Int, item:String, state :Bool) {
        self.titleLabel.text = item
        self.checkedCategoryId = itemIndex
        self.isChecked = state
        
        if self.isChecked! {
            self.checkboxImageView.image = UIImage(named: "checkbox_checked")
        } else {
            self.checkboxImageView.image = UIImage(named: "checkbox")
        }
    }
    
//************************************************s*****************
// MARK: - Action
//*****************************************************************
    
    @IBAction func checkButtonPressed(sender: UIButton) {
        
        if self.isChecked! {
            
            isChecked = false
            
            if let delegate = delegate as Filter2TableViewCellDelegate? {
                delegate.checkedCategoryInFilter2(checkedCategoryId! , categoryName: nil, isNew: false)
            }
            
            UIView.animateWithDuration(0.3, animations: {
                self.checkboxImageView.alpha = 0
            }, completion: { (_) in
                  UIView.animateWithDuration(0.3, animations: {
                    self.checkboxImageView.image = UIImage(named: "checkbox")
                    self.checkboxImageView.alpha = 1
                  })
            })
        } else {
            
            isChecked = true
            
            if let delegate = delegate as Filter2TableViewCellDelegate? {
                delegate.checkedCategoryInFilter2(checkedCategoryId!  , categoryName: self.titleLabel.text, isNew: true)
            }
            
            UIView.animateWithDuration(0.3, animations: {
                self.checkboxImageView.alpha = 0
                }, completion: { (_) in
                    UIView.animateWithDuration(0.3, animations: {
                        self.checkboxImageView.image = UIImage(named: "checkbox_checked")
                        self.checkboxImageView.alpha = 1
                    })
            })
        }
    }
    
}
