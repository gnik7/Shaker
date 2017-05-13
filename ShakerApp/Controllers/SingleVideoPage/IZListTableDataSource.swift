//
//  IZListTableDataSource.swift
//  ShakerApp
//
//  Created by Nikita Gil on 07.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit


class IZVideoTableDataSource : NSObject {
    
    weak var parentViewController   : IZSingleVideoViewController?
    var videoItemsArray             : [IZLandingModel]?
    
    var headerTitle = ""
    
    var videoHeightCell :CGFloat = 0.0
    let videoHeightPadCell :CGFloat = 140.0
    let videoHeightPhoneCell :CGFloat = 80.0
    
    var headerSectionHeight :CGFloat = 0.0
    let headerSectionPadHeight :CGFloat = 32.0
    let headerSectionPhoneHeight :CGFloat = 22.0
    let leftMarginOfHeaderSection : CGFloat = 15.0
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override init() {
        super.init()
        self.videoItemsArray = [IZLandingModel]()
        self.defineHeightCell()
    }
    
    private func defineHeightCell() {
        
        if IZDeviceType.IS_IPAD   {
            self.videoHeightCell = self.videoHeightPadCell
            self.headerSectionHeight = self.headerSectionPadHeight
        } else {
            self.videoHeightCell = self.videoHeightPhoneCell
            self.headerSectionHeight = self.headerSectionPhoneHeight
        }
    }
    
}


extension IZVideoTableDataSource : UITableViewDataSource, UITableViewDelegate {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.videoItemsArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return videoHeightCell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
 
        var universityTitle = self.headerTitle + (self.videoItemsArray?.first?.university?.title ?? "")
        if self.headerTitle == "ÄHNLICHE STUDIENGÄNGE" {
            universityTitle = self.headerTitle
        }
        let title = (universityTitle).uppercaseString ?? ""
        return title
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSObject.classFromString(IZLangingPageTableViewCell)!, forIndexPath: indexPath) as! IZLangingPageTableViewCell
        
        if self.videoItemsArray?.count > 0 {
            cell.delegate = parentViewController
            cell.updateData(self.videoItemsArray![indexPath.row], typeController: NameTypeViewController.SingleVideoController, cellIndex: indexPath.row)
        }
        
        return cell
    }
    
    //*****************************************************************
    // MARK: - UITableViewDelegate
    //*****************************************************************
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let tmpTitle = self.videoItemsArray?.first?.university?.title as String? else {
            return UIView()
        }
        var universityTitle = self.headerTitle + tmpTitle
        
        if self.headerTitle == "ÄHNLICHE STUDIENGÄNGE" {
            universityTitle = self.headerTitle
        }
        
        
        let title = (universityTitle).uppercaseString ?? ""
        
        let headerLabel = IZHelpConverter.createUILabelForSectionTitle(self.leftMarginOfHeaderSection , width: tableView.frame.width, text:title)
        let header = UIView()
        header.addSubview(headerLabel)
        
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerSectionHeight
    }
    
}
