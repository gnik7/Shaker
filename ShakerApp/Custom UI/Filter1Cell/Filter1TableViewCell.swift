//
//  Filter1TableViewCell.swift
//  ShakerApp
//
//  Created by Nikita Gil on 15.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class Filter1TableViewCell: UITableViewCell {
    
    // @IBOutlet
    
    @IBOutlet weak var categoryLabel    : UILabel!
    @IBOutlet weak var subCategoryLabel : UILabel!
    
    
    // let

    let defaultEgal = "Egal"
    let defaultColor = UIColor.init(colorLiteralRed: 209/255.0, green: 209/255.0, blue: 209/255.0, alpha: 1.0)
    let highlightedColor = UIColor.init(colorLiteralRed: 36/255.0, green: 196/255.0, blue: 172/255.0, alpha: 1.0)
    
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
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 10, 0, 0))
    }
    
    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    func updateData(title :String ,subItems: [String]?) {
        
        self.categoryLabel.text = title
        
        if let subItems = subItems as [String]? {
            if subItems.count > 0 {
                let fullString = subItems.joinWithSeparator(",")
                self.subCategoryLabel.text = fullString
                self.subCategoryLabel.textColor = highlightedColor
            }
        } else {
            self.subCategoryLabel.text = defaultEgal
            self.subCategoryLabel.textColor = defaultColor
        }
        
        
    }

    
}
