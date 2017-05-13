//
//  IZLandingPageViewController.swift
//  ShakerApp
//
//  Created by Nikita Gil on 14.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit


class IZLandingPageViewController : IZBaseViewController {
    
    //IBOutlet
    @IBOutlet weak var landingTableView: UITableView!
    
    @IBOutlet weak var shakeButtonLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var shakeButtonRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shakeButtonWidthConstraint: NSLayoutConstraint!

    

    //var
    var landingArray        : [IZLandingModel]?
    var refreshControl      : UIRefreshControl?
    
    var pagination              : IZPaginationModel?
    var isNeedUpdate            : Bool!
    var isShakeButtonPressed    : Bool!
    
    let playerAudio : IZSoundManager = IZSoundManager()
    
    var heightCell          : CGFloat = 0.0
    var heightPhoneCell     : CGFloat = 80.0
    var heightPadCell       : CGFloat = 140.0
    
    let pageSize = 15
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.landingArray = self.getLandingArray()
        self.landingArray = [IZLandingModel]()
        
        self.pagination = IZPaginationModel()
        self.pagination?.perPage = pageSize
        
        
        self.defineHeightCell()
        
        // load Table Cell
        self.registerCellWithNib()
        
        //
        self.landingTableView.delegate = self
        self.landingTableView.dataSource = self
        
        //
        self.createRefreshControl()
        
        self.isNeedUpdate = false
        
        self.updateDataTable()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isNeedUpdate! {
            self.landingArray = [IZLandingModel]()
            self.pagination?.currentPage = 1
            self.pagination?.perPage = pageSize
            self.updateDataTable()
        }
        self.isShakeButtonPressed = false
        IZHelpConverter.portraitOrientation()
        
//        if IZDeviceType.IS_IPAD {
//            shakeButtonLeftConstraint.priority = 750
//            shakeButtonRightConstraint.priority = 750
//            shakeButtonWidthConstraint.priority = 999
//        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.isNeedUpdate = true
    }
    
    /**
     Create refresh control
     */
    
    func createRefreshControl() {
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor.clearColor()
        self.refreshControl?.addTarget(self, action: #selector(updateVideoList), forControlEvents: UIControlEvents.ValueChanged)
        self.landingTableView.addSubview(self.refreshControl!)
    }
    
    /**
     Asign Cell
     */
    
    private func registerCellWithNib() {
        
        let (classNameLandingCell ,nibLandingCell) = NSObject.classNibFromString(IZLangingPageTableViewCell)
        guard let nameLandingCell = classNameLandingCell as String?, let landingCellNib = nibLandingCell as UINib? else {
            return
        }
        self.landingTableView.registerNib(landingCellNib, forCellReuseIdentifier: nameLandingCell)
    }
    
    /**
     Define heght Cell
     */
    
    private func defineHeightCell() {
        
        if IZDeviceType.IS_IPAD   {
            self.heightCell = self.heightPadCell
        } else {
            self.heightCell = self.heightPhoneCell
        }
    }
    
    func updateVideoList() {
        self.refreshControl?.endRefreshing()
        self.landingArray = [IZLandingModel]()
        self.pagination?.currentPage = 1
        self.pagination?.perPage = pageSize
        self.updateDataTable()
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func shakeButtonPressed(sender: UIButton) {
        if self.isShakeButtonPressed == true {
            return
        }
        self.isShakeButtonPressed = true
        self.updateRandomVideo()
        self.playerAudio.playSound()
    }    
}


extension IZLandingPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.landingArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return heightCell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSObject.classFromString(IZLangingPageTableViewCell)!, forIndexPath: indexPath) as! IZLangingPageTableViewCell
        
        if self.landingArray?.count > 0 {
            cell.updateData(self.landingArray![indexPath.row], typeController: .LandingPageViewController, cellIndex: indexPath.row)
            cell.delegate = self
        }
        
        return cell        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = indexPath.row
        let lastRow = (self.landingArray?.count)! - 1
        
        if row == lastRow && self.pagination?.currentPage != self.pagination?.totalPages {
            if self.pagination?.currentPage < self.pagination?.totalPages {
                self.pagination?.currentPage = (self.pagination?.currentPage)! + 1
                self.updateDataTable()
            }
        }
    }
}

extension IZLandingPageViewController: LangingPageTableViewCellDelegate {
    
    //*****************************************************************
    // MARK: - LangingPageTableViewCellDelegate - play button pressed
    //*****************************************************************
    
    func playButtonPressedInLangingPage(item: IZLandingModel) {
        if self.isShakeButtonPressed == true {
            return
        }
        self.isShakeButtonPressed = true
        self.router.showSingleVideoViewController(item)
    }
    
    func favoriteButtonPressedInLangingPage(videoId: Int, index : Int) {}
}


extension IZLandingPageViewController {
    
    //*****************************************************************
    // MARK: - Shaker block
    //*****************************************************************
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override internal func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            self.playerAudio.playSound()
            self.updateRandomVideo()
        }
    }
      
    //*****************************************************************
    // MARK: - Api Calls
    //*****************************************************************
    
    func updateDataTable() {
        
        if !IZReachabilityManager.sharedManager().checkInternetConnection() {
            IZAlert.showAlert(self, title: AlertText.TitleNoInternet.rawValue, message: AlertText.NoInternetMessage.rawValue, action: nil)
            self.refreshControl?.endRefreshing()
            return
        }
        
        var indexesArray :[Int]?
        if let indexes = IZSelectedFiltersManager.sharedInstance.selectedSubCategoriesIndexes() as [Int]? {
            indexesArray = indexes
            if indexesArray?.count == 0 {
                let idVideoArray = IZHelpConverter.convertLandingArrayToIntArray(self.landingArray)
                IZRestLandingApiOperation.videoListCall(idVideoArray, pageNumber: (self.pagination?.currentPage)! , pageSize: (self.pagination?.perPage)! , completed:{ (responseObject, response) in
                    
                    self.refreshControl?.endRefreshing()
                    
                    if response == true {
                        
                        let tmpArray = self.landingArray
                        self.landingArray? = tmpArray! + (responseObject?.itemsArray)! //need test
                        self.landingTableView.reloadData()
                        
                        if let page = responseObject?.pagination as IZPaginationModel? {
                            self.pagination = page
                        }
                    }
                })
            } else {
                IZRestLandingApiOperation.filteredVideoListOperation(nil, filter: indexesArray, pageNumber: (self.pagination?.currentPage)!, pageSize: (self.pagination?.perPage)!, completed: { (responseObject, response) in
                    
                    self.refreshControl?.endRefreshing()
                    
                    if response == true {
                        
                        let tmpArray = self.landingArray
                        self.landingArray? = tmpArray! + (responseObject?.itemsArray)! //need test
                        self.landingTableView.reloadData()
                        
                        if let page = responseObject?.pagination as IZPaginationModel? {
                            self.pagination = page
                        }
                    }
                })
            }
        }
    }
    
    func updateRandomVideo() {
        
        if !IZReachabilityManager.sharedManager().checkInternetConnection() {
            IZAlert.showAlert(self, title: AlertText.TitleNoInternet.rawValue, message: AlertText.NoInternetMessage.rawValue, action: nil)
            return
        }
        
        IZRestLandingApiOperation.randomVideoOperation { (responseObject, response) in
            
            if response {
                if let singleVideo = responseObject as IZLandingModel? {
                    self.router.showSingleVideoViewController(singleVideo)
                }
            }
        }
    }
}




