//
//  IZSingleVideoController.swift
//  ShakerApp
//
//  Created by Nikita Gil on 18.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Alamofire

enum VideoStatus  {
    case VideoStatusViewed(String)
    case VideoStatusSkiped(String)
}

class IZSingleVideoViewController : IZBaseViewController {
    
    //IBOutlet
    
    @IBOutlet weak var videoView                : UIView!
    @IBOutlet weak var sameAuthorTableView      : UITableView!
    @IBOutlet weak var videoListTableView       : UITableView!
    @IBOutlet weak var showMoreSameAuthorView   : UIView!
    @IBOutlet weak var showMoreVideoListView    : UIView!
    @IBOutlet weak var scrollView               : UIScrollView!
    
    @IBOutlet weak var titleSubjectLabel        : UILabel!
    @IBOutlet weak var titleUniversityLabel     : UILabel!
    @IBOutlet weak var detailLabel              : UILabel!
    @IBOutlet weak var favoriteImageView        : UIImageView!
    @IBOutlet weak var contentVideoView         : UIView!
    @IBOutlet weak var containerVideoView       : UIView!
    @IBOutlet weak var moreButton               : UIButton!
    @IBOutlet weak var moreLabel                : UILabel!
    @IBOutlet weak var newVideoContainerView    : UIView!
    @IBOutlet weak var shareButton              : UIButton!
    
 
    
    @IBOutlet weak var shakeImageWidthConstraint            : NSLayoutConstraint!
    @IBOutlet weak var shakeImageLeftConstraint             : NSLayoutConstraint!
    @IBOutlet weak var shakeImageRightConstraint            : NSLayoutConstraint!
    @IBOutlet weak var containerVideoHeightConstraint       : NSLayoutConstraint!
    @IBOutlet weak var videoViewHeightConstraint            : NSLayoutConstraint!
    @IBOutlet weak var sameAuthorTableViewHeightConstraint  : NSLayoutConstraint!
    @IBOutlet weak var videoListTableViewHeightConstraint   : NSLayoutConstraint!
    @IBOutlet weak var showMoreAuthorHeightConstraint       : NSLayoutConstraint!
    @IBOutlet weak var showMoreListHeightConstraint         : NSLayoutConstraint!
    @IBOutlet weak var titleViewHeightConstaraint           : NSLayoutConstraint!
    
    //var
    var singleVideo             : IZLandingModel?
    var paginationSameAuthor    : IZPaginationModel?
    var paginationVideoList     : IZPaginationModel?
  
    var sameAuthorDataSource    : IZVideoTableDataSource?
    var videoListDataSource     : IZVideoTableDataSource?
    
    var showMoreSameAuthorCellView  : IZShowMoreSeparatorCell?
    var showMoreVideoListCellView   : IZShowMoreSeparatorCell?
    
    // when player exit from fullscreen
    // mode dont reload video cell
    var currentOrientation : UIInterfaceOrientationMask = UIInterfaceOrientationMask.Portrait
    var currentOrientationValue = UIInterfaceOrientation.Portrait.rawValue
    
    var isPlayButtonPressed = false
    var isShakeActionDone = false
    let playerAudio : IZSoundManager = IZSoundManager()
    
    //video controller vars
    var playerController            : AVPlayerViewController?
    var player                      : AVPlayer?
    var observerCounter             : [String]?
    var videoViewHeight : CGFloat = 0
    var descriptionHeight : CGFloat = 0
    var expandedHeight : CGFloat = 0
    //var isExitedFullScreen = false
    private var isSimpleRotation = false
    private var isFullScreenButtonPressed = false
    private var AAPLPlayerViewControllerKVOContext :UInt8 = 1
    let observerString = "Observer Added"
    var isTextExpanded = false
    
    //
    let more = "mehr"
    let less = "weniger"
    let sameAuthorTitle = "AUCH VON "
    let videoListTitle = "ÄHNLICHE STUDIENGÄNGE"
    
    let leftRightMarginOfCell : CGFloat = 15.0
    let leftMarginOfHeaderSection : CGFloat = 15.0
    let rowInSection = 3
    
    let portWidth   : CGFloat = UIScreen.mainScreen().bounds.width
    let portHeight  : CGFloat = UIScreen.mainScreen().bounds.height
    
    let reachabilityStatusManager =  IZReachabilityStatusManager()
    var tap :UITapGestureRecognizer?
        
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init?(coder aDecoder: NSCoder) {
        
        self.sameAuthorDataSource = IZVideoTableDataSource()
        self.videoListDataSource = IZVideoTableDataSource()
        
        self.paginationSameAuthor = IZPaginationModel()
        self.paginationSameAuthor?.perPage = self.rowInSection
        
        self.paginationVideoList = IZPaginationModel()
        self.paginationVideoList?.perPage = self.rowInSection
        
        super.init(coder: aDecoder)
        
        self.sameAuthorDataSource?.parentViewController = self
        self.videoListDataSource?.parentViewController = self
        
        self.sameAuthorDataSource?.headerTitle = sameAuthorTitle
        self.videoListDataSource?.headerTitle = videoListTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSupportRotationDevice()
        
        self.observerCounter = [String]()
        
        // load Table Cell
        self.registerCellWithNib()
        
        //table setup
        self.setupTablesView()
        
        // get data
        self.updateVideoFromSameAuthor((self.paginationSameAuthor?.currentPage)!)
        self.updateVideoList((self.paginationVideoList?.currentPage)!)
        
        //set data to video cell
        self.createPlayer(self.singleVideo!.videoUrl!)
        self.updateVideoData(self.singleVideo!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(IZSingleVideoViewController.networkStatusChangedNotification(_:)) , name: NetworkStatusChanged, object: nil)
        
        self.tap = UITapGestureRecognizer(target: self, action: #selector(IZSingleVideoViewController.didTapDescriptionLabel(_:)))
        tap!.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.videoViewHeight = self.containerVideoView.frame.size.height
        self.countHeight()
       
        self.isShakeActionDone = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //load views
        self.loadShowMoreView()
        self.descriptionHeight = self.detailLabel.frame.size.height
        self.descriptionLabelSize()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.playerController?.player?.pause()
    }
    
    deinit {
        self.removePlayer{
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }
    
    private func addSupportRotationDevice() {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.shouldSupportAllOrientation = true
    }
    
    /**
     Assign Cell
     */
    
    private func registerCellWithNib() {
        
        let (classNameLandingCell ,nibLandingCell) = NSObject.classNibFromString(IZLangingPageTableViewCell)
        guard let nameLandingCell = classNameLandingCell as String?, let landingCellNib = nibLandingCell as UINib? else {
            return
        }
        self.sameAuthorTableView.registerNib(landingCellNib, forCellReuseIdentifier: nameLandingCell)
        self.videoListTableView.registerNib(landingCellNib, forCellReuseIdentifier: nameLandingCell)
    }
    
    /**
     Setup Tables
     */
    
    private func setupTablesView() {
        
        self.sameAuthorTableView.dataSource = self.sameAuthorDataSource
        self.sameAuthorTableView.delegate = self.sameAuthorDataSource
        
        self.videoListTableView.dataSource = self.videoListDataSource
        self.videoListTableView.delegate = self.videoListDataSource
    }
    
    private func countHeight() {
        
        if IZDeviceType.IS_IPAD {
            self.videoViewHeightConstraint.constant = UIScreen.mainScreen().bounds.height * 0.6
            self.containerVideoHeightConstraint.constant =  self.videoViewHeightConstraint.constant * 0.6
            shakeImageLeftConstraint.priority = 750
            shakeImageRightConstraint.priority = 750
            shakeImageWidthConstraint.priority = 999
        }
        
        self.sameAuthorTableViewHeightConstraint.constant = self.sameAuthorTableView.contentSize.height
        self.videoListTableViewHeightConstraint.constant = self.videoListTableView.contentSize.height
    }
    
    private func descriptionLabelSize() {
           
        let currentHeight : CGFloat = self.detailLabel.frame.size.height
        let requiredHeight : CGFloat = self.detailLabel.requiredHeight()
        
        if currentHeight < requiredHeight {
            self.moreButton.enabled = true
            self.moreLabel.hidden = false
        } else {
            self.moreButton.enabled = false
            self.moreLabel.hidden = true
        }
        
//        if detailLabel.lines() == 1 {
//            self.moreButton.enabled = false
//            self.moreLabel.hidden = true
//        } else {
//            self.moreButton.enabled = true
//            self.moreLabel.hidden = false
//        }
    }
    
    private func titleLabelSize() {
        
        let requiredHeight : CGFloat = self.titleSubjectLabel.requiredHeight()
        
        self.titleSubjectLabel.frame.size.height = requiredHeight
        self.titleViewHeightConstaraint.constant += requiredHeight
        self.videoViewHeightConstraint.constant += requiredHeight
    }
    
    /**
      Load Views
     */
    
    private func loadShowMoreView() {
        
        self.showMoreSameAuthorCellView?.setNeedsDisplay()
        self.showMoreSameAuthorCellView?.layoutIfNeeded()
        self.showMoreVideoListCellView?.setNeedsDisplay()
        self.showMoreVideoListCellView?.layoutIfNeeded()
        
        self.showMoreSameAuthorCellView = IZShowMoreSeparatorCell.loadFromXib()
        let frame = self.showMoreSameAuthorView.frame
        let width = UIScreen.mainScreen().bounds.width
        self.showMoreSameAuthorCellView?.frame = CGRectMake(0, 0, width, frame.height)
        self.showMoreSameAuthorCellView?.delegate = self
        self.showMoreSameAuthorCellView?.typeCell = ShowTypeCell.SameAuthorShowTypeCell
        self.showMoreSameAuthorView.addSubview(self.showMoreSameAuthorCellView!)
        
        self.showMoreVideoListCellView = IZShowMoreSeparatorCell.loadFromXib()
        self.showMoreVideoListCellView?.frame = CGRectMake(0, 0, width, frame.height)
        self.showMoreVideoListCellView?.delegate = self
        self.showMoreVideoListCellView?.typeCell = ShowTypeCell.VideoListShowTypeCell
        self.showMoreVideoListView.addSubview(self.showMoreVideoListCellView!)
    }
    
    private func showLess() {
        UIView.animateWithDuration(0.5, animations: {
            self.detailLabel.frame.size.height = self.descriptionHeight
            }, completion: { (_) in
                
                self.videoViewHeightConstraint.constant -= self.expandedHeight
                self.moreLabel.text = self.more
                self.isTextExpanded = false
                UIView.animateWithDuration(0.5, animations: {
                    self.scrollView.contentOffset.y = CGPointZero.y
                })
        })
    }
   
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************

    @IBAction func shakeButtonPressed(sender: UIButton) {
        
        let playedTime :Double = Double(CMTimeGetSeconds(self.currentTimePlayedVideo()))
        if playedTime < 0.5 /* && self.observerCounter!.count > 0*/ {
           return
        }
        
        if !self.isShakeActionDone {
            self.isShakeActionDone = true
            self.shakeAction()
        }
    }
    
    @IBAction func shareButtonPressed(sender: UIButton) {
        var videoUrl = ""
        if let link = self.singleVideo?.links as String? {
            videoUrl = link
        } else {
            videoUrl = "url fehlt"
        }
        IZSharing.showSharing(self, shareContent: videoUrl, action: {})
    }
    
    @IBAction func favoriteButtonPressed(sender: UIButton) {
        if ((self.singleVideo?.isFavorite)!) {
            self.removeVideoFromFavorite((self.singleVideo?.idVideo)!, state: (self.singleVideo?.isFavorite)!)
        } else {
            self.addVideoToFavorite((self.singleVideo?.idVideo)!, state:  (self.singleVideo?.isFavorite)!)
        }
    }
    
    @IBAction func moreButtonPressed(sender: UIButton) {
        if !isTextExpanded {
            self.expandedHeight = self.detailLabel.requiredHeight()
            self.videoViewHeightConstraint.constant += self.detailLabel.requiredHeight()
            self.detailLabel.frame.size.height = self.detailLabel.requiredHeight()
            self.moreLabel.text = self.less
            isTextExpanded = true
        } else {
            showLess()
        }
    }
    
    @IBAction func universityButtonPressed(sender: UIButton) {
        if let universityLink = self.singleVideo?.university?.link as String? {
            if let urlString = IZHelpConverter.URL(universityLink)  as String? {
                self.view.openURL(urlString)
            }
        }      
    }
    
    @IBAction func descriptionButtonPressed(sender: UIButton) {
        if let descriptionLink = self.singleVideo?.descriptionLink as String? {
            if let urlString = IZHelpConverter.URL(descriptionLink)  as String? {
                self.view.openURL(urlString)
            }
        }
    }
    
    
    //*****************************************************************
    // MARK: - Set Data to Video View
    //*****************************************************************
    
    func updateVideoData(item: IZLandingModel) {
        
//        if let videoUrl = self.singleVideo!.videoUrl as String? {
//            self.createPlayer(videoUrl)
//        } else {
//            IZAlert.showAlertError(self, message: AlertText.NoURLMessage.rawValue, done: nil)
//        }
        
        if let title = item.title as String? {
            self.titleSubjectLabel.text = title
        } else {
            self.titleSubjectLabel.text = ""
        }
        
        if let university = item.university?.title as String? {
            self.titleUniversityLabel.text = university.uppercaseString
        } else {
            self.titleUniversityLabel.text = ""
        }
        
        if let description = item.description as String? {
            self.detailLabel.text = description
        } else {
            self.detailLabel.text = ""
        }
        
        if let isFavorite = item.isFavorite as Bool? {
            self.favoriteButtonState(isFavorite)
        }
        
        if detailLabel.lines() == 1 {
            self.moreButton.enabled = false
            self.moreLabel.hidden = true
        } else {
            self.moreButton.enabled = true
            self.moreLabel.hidden = false
        }
        
        //self.titleLabelSize()
    }
    
    func favoriteButtonState(state : Bool) {
        if state {
            self.favoriteImageView.image = UIImage(named: "fill_favorite_button")
        } else {
            self.favoriteImageView.image = UIImage(named: "favorite_button")
        }
    }
    
    //*****************************************************************
    // MARK: - Create/Remove Player
    //*****************************************************************
    
    private func createPlayer(videoUrl : String) {
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.shouldSupportAllOrientation = true
        
        let url = NSURL(string: videoUrl)
        
        let asset: AVURLAsset = AVURLAsset(URL: url!, options: nil)
        let statusKey = "tracks"
        
        asset.loadValuesAsynchronouslyForKeys([statusKey], completionHandler: {
            var error: NSError? = nil
            
            dispatch_async(dispatch_get_main_queue(), {
                let status: AVKeyValueStatus = asset.statusOfValueForKey(statusKey, error: &error)
                
                if status == AVKeyValueStatus.Loaded{
                    
                    let playerItem = AVPlayerItem(asset: asset)
                    
                    self.player = AVPlayer(playerItem: playerItem)
                    self.playerController = AVPlayerViewController()
                    self.playerController?.player = self.player
               
                    self.player?.volume = AVAudioSession.sharedInstance().outputVolume
                    
                    
                    self.playerController?.view.frame = CGRect(x: 0, y: 0, width: self.newVideoContainerView.frame.width, height: self.newVideoContainerView.frame.height)
                    self.playerController?.view.backgroundColor = UIColor.blackColor()
                    
                    self.addChildViewController(self.playerController!)
                    self.newVideoContainerView.addSubview(self.playerController!.view)
                    self.playerController?.willMoveToParentViewController(self)
                    self.playerController?.didMoveToParentViewController(self)
                    self.playerController?.player?.seekToTime(kCMTimeZero)
                    self.playerController?.player?.play()
                    
                } else {
                    print(error!.localizedDescription)
                    self.isShakeActionDone = false
                }
            })
        })
    }
    
    private func removePlayer(complited:()->()) {
        
        self.playerController?.player?.pause()
        self.player?.replaceCurrentItemWithPlayerItem(nil)
        self.player = nil
        self.playerController?.player = nil
        
        self.playerController?.removeFromParentViewController()
        self.playerController?.view.removeFromSuperview()
        self.playerController = nil
      
        complited()
    }
    
    private func replacePlayer(videoUrl : String)  {
        
        self.playerController?.player?.pause()
        
        let url = NSURL(string: videoUrl)
        
        let asset: AVURLAsset = AVURLAsset(URL: url!, options: nil)
        let statusKey = "tracks"
        
        asset.loadValuesAsynchronouslyForKeys([statusKey], completionHandler: {
            var error: NSError? = nil
            
            dispatch_async(dispatch_get_main_queue(), {
                let status: AVKeyValueStatus = asset.statusOfValueForKey(statusKey, error: &error)
                
                if status == AVKeyValueStatus.Loaded{
                    
                    let playerItem = AVPlayerItem(asset: asset)
                    self.playerController?.player?.replaceCurrentItemWithPlayerItem(playerItem)
                    self.playerController?.player?.seekToTime(kCMTimeZero)
                    self.playerController?.player?.play()
                    
                } else {
                    print(error!.localizedDescription)
                    self.isShakeActionDone = false
                }
            })
        })
    }
    
    //*****************************************************************
    // MARK: - Observer
    //*****************************************************************
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
       
        
//        if keyPath == "bounds"        {
//            let rect = change!["new"] as! NSValue
//            
//            if let playerRect: CGRect = rect.CGRectValue() as CGRect {
//                if playerRect.size == UIScreen.mainScreen().bounds.size {
//                    print("Player in full screen ******")
////                    self.enterFullScreen()
//                } else {
//                    print("Player not in full screen ******")
//                    //self.isExitedFullScreen = true
////                    self.exitFromFullScreen()
//                }
//            }
//        }
//
        if keyPath == "videoBounds" {
            if let  dict = change   {
                
                let newBounds = dict[NSKeyValueChangeNewKey]?.CGRectValue()
                print(newBounds)
                if newBounds?.width == UIScreen.mainScreen().bounds.width {
                    
                    print("entered fullscreen")
                    
                } else if newBounds?.width != UIScreen.mainScreen().bounds.width &&
                    newBounds?.width != UIScreen.mainScreen().bounds.height {
                    print("exited fullscreen")
                }
            }
        }
        
        if let data: AVPlayerItem = object as? AVPlayerItem {
            if keyPath == "status" {
                
                switch data.status {
                case AVPlayerItemStatus.Failed , AVPlayerItemStatus.Unknown:
                    print("Stoped")
                case AVPlayerItemStatus.ReadyToPlay:
                    print("play now")
                }
            }
        }
    }
    
    func itemDidFinishPlaying(notification : NSNotification) {
        
        if self.playerController?.player != nil {
            self.playerController?.player!.seekToTime(kCMTimeZero)
            self.playerController?.player!.pause()
        }
    }
}

extension IZSingleVideoViewController : UIGestureRecognizerDelegate {
    //*****************************************************************
    // MARK: - TapGesture
    //*****************************************************************
    
    func didTapDescriptionLabel(sender: UITapGestureRecognizer) {
    }
}

extension IZSingleVideoViewController: IZShowMoreSeparatorCellDelegate {
    
    //*****************************************************************
    // MARK: - IZShowMoreSeparatorCellDelegate
    //*****************************************************************
    
    func showMoreButtonPressed(type :ShowTypeCell) {
        print("Show more")
        
        if type == ShowTypeCell.SameAuthorShowTypeCell {
            if self.paginationSameAuthor?.currentPage != self.paginationSameAuthor?.totalPages {
                self.paginationSameAuthor?.perPage = self.rowInSection
                self.paginationSameAuthor?.currentPage = (self.paginationSameAuthor?.currentPage)! + 1
                self.updateVideoFromSameAuthor((self.paginationSameAuthor?.currentPage)!)
            } else {
                IZAlert.showAlert(self, title: "", message: AlertText.NoMoreVideos.rawValue, action: nil)
            }
        } else if type == ShowTypeCell.VideoListShowTypeCell {
            if self.paginationVideoList?.currentPage != self.paginationVideoList?.totalPages {
                self.paginationVideoList?.perPage = self.rowInSection
                self.paginationVideoList?.currentPage = (self.paginationVideoList?.currentPage)! + 1
                self.updateVideoList((self.paginationVideoList?.currentPage)!)
            } else {
                IZAlert.showAlert(self, title: "", message: AlertText.NoMoreVideos.rawValue, action: nil)
            }
        }
    }
}

extension IZSingleVideoViewController: LangingPageTableViewCellDelegate {
    
    //*****************************************************************
    // MARK: - LangingPageTableViewCellDelegate -  buttons pressed
    //*****************************************************************
    
    func playButtonPressedInLangingPage(item: IZLandingModel) {
        if isTextExpanded {
            self.showLess()
        }
        let currentPlayVideo = self.singleVideo?.idVideo
        self.singleVideo = item
        //self.removePlayer {
        self.isPlayButtonPressed = true
            self.replacePlayer((self.singleVideo?.videoUrl!)!)
            self.updateVideoData(self.singleVideo!)
            
            let playedTime :Double = Double(CMTimeGetSeconds(self.currentTimePlayedVideo()))
            if playedTime > 0.5 /*&& self.observerCounter!.count > 0*/ {
                self.updateSingleVideo(playedTime, videoId: currentPlayVideo! , followUpId: self.singleVideo?.idVideo)
            }
            
            self.paginationVideoList?.currentPage = 1
            self.paginationSameAuthor?.currentPage = 1
            
            self.updateVideoList((self.paginationVideoList?.currentPage)!)
            self.updateVideoFromSameAuthor((self.paginationSameAuthor?.currentPage)!)
        //}
    }
    
    func favoriteButtonPressedInLangingPage(videoId: Int, index : Int) {}
}

extension IZSingleVideoViewController : UINavigationControllerDelegate {
    
    //*****************************************************************
    // MARK: - UINavigationControllerDelegate
    //*****************************************************************

    //*****************************************************************
    // MARK: - Rotation
    //*****************************************************************
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        print("viewWillTransition")
        coordinator.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in
            print(#function)
            
            if UIDevice.currentDevice().orientation.isPortrait.boolValue {
                //need exit from full screen
                
                let frame = self.playerController?.contentOverlayView?.frame
                print(frame)
                print(UIScreen.mainScreen().bounds)
                print(self.view.frame)
                if max(frame!.width, frame!.height) == max(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height) {
                    print("FULL SCREEN")
                    //переворот после нажатой кнопки по прежднему полно экранный
                    if self.isSimpleRotation {
                        self.isSimpleRotation = false
                        self.playerController?.dismissViewControllerAnimated(false, completion: {
                            self.playerController?.view.frame = CGRect(x: 0, y: 0, width: self.newVideoContainerView.frame.width, height: self.newVideoContainerView.frame.height)
                            self.addChildViewController(self.playerController!)
                            self.newVideoContainerView.addSubview(self.playerController!.view)
                            self.playerController?.willMoveToParentViewController(self)
                            self.playerController?.didMoveToParentViewController(self)
                            self.playerController?.player?.play()
                        })
                    }
                    if self.isFullScreenButtonPressed {
                        self.isFullScreenButtonPressed = false
                        
                        self.playerController?.dismissViewControllerAnimated(false, completion: {
                            self.player?.pause()
                            self.playerController = nil
                            self.playerController = AVPlayerViewController()
                            self.playerController?.player = self.player
                            self.playerController?.view.frame = CGRect(x: 0, y: 0, width: self.newVideoContainerView.frame.width, height: self.newVideoContainerView.frame.height)
                            self.addChildViewController(self.playerController!)
                            self.newVideoContainerView.addSubview(self.playerController!.view)
                            self.playerController?.willMoveToParentViewController(self)
                            self.playerController?.didMoveToParentViewController(self)
                            self.player?.play()
                        })
                    }
                    self.sameAuthorTableView.reloadData()
                    self.videoListTableView.reloadData()
                } else {
                    print("PORTRAIT")
                }
            }
            
            if UIDevice.currentDevice().orientation.isLandscape.boolValue {
                //need enter to full screen
                
                let frame = self.playerController?.contentOverlayView?.frame
                print(frame)
                print(UIScreen.mainScreen().bounds)
                print(self.view.frame)
                if max(frame!.width, frame!.height) == max(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height) {
                    print("FULL SCREEN")
                    //тут когда кнопка нажалась и перевернул
                   self.isFullScreenButtonPressed = true
                } else {
                    print("PORTRAIT")
                    //тут просто переворот
                    self.isSimpleRotation = true
                    self.playerController?.removeFromParentViewController()
                    self.playerController?.modalPresentationStyle = .OverFullScreen
                    self.presentViewController(self.playerController!, animated: false, completion: nil)
                }
            }
           
            }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
           
                if UIDevice.currentDevice().orientation.isPortrait.boolValue {
                    //need enter to full screen
                    print("Rotation complited")
                    self.sameAuthorTableView.reloadData()
                    self.videoListTableView.reloadData()
                }
        })
    }
}

extension IZSingleVideoViewController {
    
    /**
     Notification of lost internet connection
     */
    
    func networkStatusChangedNotification(notification :NSNotification) {
        
        let userinfo : Dictionary<String, String!> = notification.object as! Dictionary<String, String!>
        let status  = userinfo["Info"]! as String
        
        switch status {
        case NetworkStatusChangedReachable : break
            
        case NetworkStatusChangedNotReachable :
            dispatch_async(dispatch_get_main_queue(), { 
                self.playerController!.player?.pause()
            })
        default : break
        }
    }
    
    /**
      Get played time current video
     */
    
    private func currentTimePlayedVideo() -> CMTime {

        if let playerControl = self.playerController as AVPlayerViewController? {
            
            guard let player = playerControl.player as AVPlayer? else {
                 return kCMTimeZero
            }
            
            guard let playerItem = player.currentItem as AVPlayerItem? else {
                return kCMTimeZero
            }
            let currentTime :CMTime = playerItem.currentTime()
            return currentTime
        }
        return kCMTimeZero
    }
    
    //*****************************************************************
    // MARK: - Shaker block
    //*****************************************************************
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
  
    override internal func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
 
            if !self.isShakeActionDone {
                self.isShakeActionDone = true
                self.isPlayButtonPressed = false
                self.shakeAction()
            }
        }
    }
    
    private func shakeAction() {
        let playedTime :Double = Double(CMTimeGetSeconds(self.currentTimePlayedVideo()))
        if playedTime > 1.0 /*&& self.observerCounter!.count > 0 */{
            if isTextExpanded {
                self.showLess()
            }
            self.playerAudio.playSound()
            self.updateSingleVideo(playedTime, videoId: (self.singleVideo?.idVideo)! , followUpId: nil)
        } else {
            self.isShakeActionDone = false
        }
    }
    //*****************************************************************
    // MARK: - Api Call
    //*****************************************************************
    
    /**
     Get next video when shake
     */
    
    func updateSingleVideo(duration : Double, videoId : Int, followUpId :Int?) {
        
        if !IZReachabilityManager.sharedManager().checkInternetConnection() {
            IZAlert.showAlert(self, title: AlertText.TitleNoInternet.rawValue, message: AlertText.NoInternetMessage.rawValue, action: nil)
            self.isShakeActionDone = false
            return
        }
        
        IZRestVideoApiOperation.shakeEventOperation(videoId, followUpId: followUpId, duration: duration, completed: { (responseObject, responseStatus) in
            
            if responseStatus == true {
                if !self.isPlayButtonPressed {
                    self.singleVideo = responseObject as IZLandingModel
                    
                    if self.playerController != nil {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.replacePlayer((self.singleVideo?.videoUrl)!)
                            self.updateVideoData(self.singleVideo!)
                        })
                    } else {
                        self.removePlayer {
                            self.updateVideoData(self.singleVideo!)
                            self.createPlayer((self.singleVideo?.videoUrl)!)
                        }
                    }
                }
                self.isPlayButtonPressed = false
                self.paginationSameAuthor?.currentPage = 1
                self.updateVideoFromSameAuthor((self.paginationSameAuthor?.currentPage)!)
                self.isShakeActionDone = false
                
                self.paginationVideoList?.currentPage = 1
                self.updateVideoList((self.paginationVideoList?.currentPage)!)              
            }
        })
    }
    
    /**
     Get Video List
     */
    
    func updateVideoList(pageNumber : Int) {
        if !IZReachabilityManager.sharedManager().checkInternetConnection() {
            IZAlert.showAlert(self, title: AlertText.TitleNoInternet.rawValue, message: AlertText.NoInternetMessage.rawValue, action: nil)
            return
        } 
        
        let currentVideoId = self.singleVideo?.idVideo
        IZRestVideoApiOperation.videoSimilarOperation(currentVideoId!, currentPage: pageNumber , pageSize: self.rowInSection , completed:{ (responseObject, response) in
            
            if response == true {
                
                let model = responseObject as IZLandingItemsModel?
                let itemsArray = model?.itemsArray
                self.videoListDataSource?.videoItemsArray = itemsArray
                dispatch_async(dispatch_get_main_queue(), {
                    self.videoListTableView.reloadData()
                    self.view.layoutIfNeeded()
                    self.countHeight()
                })
                
                if let page = responseObject?.pagination as IZPaginationModel? {
                    self.paginationVideoList = page
                }
            }
        })
    }
    
    /**
     Get Video From Same Author
     */
    
    func updateVideoFromSameAuthor(pageNumber : Int) {
        if !IZReachabilityManager.sharedManager().checkInternetConnection() {
            IZAlert.showAlert(self, title: AlertText.TitleNoInternet.rawValue, message: AlertText.NoInternetMessage.rawValue, action: nil)
            return
        }
        
        var skipID = 0
        if let skipId = self.singleVideo?.idVideo {
            skipID = skipId
        }
        
        IZRestVideoApiOperation.videoFromTheSameAuthorOperation((self.singleVideo?.university?.id)!,
                                                                currentPage: pageNumber,
                                                                pageSize: self.rowInSection,
                                                                skipId: skipID,
                                                                completed: { (responseObject, response) in
            if response {
                
                let model = responseObject as IZLandingItemsModel?
                let itemsArray = model?.itemsArray
                self.sameAuthorDataSource?.videoItemsArray = itemsArray
                self.sameAuthorTableView.reloadData()
                self.view.layoutIfNeeded()
                self.countHeight()
                
                if let page = responseObject!.pagination as IZPaginationModel? {
                    self.paginationSameAuthor = page
                }
            }
        })
    }
    
    /**
     Add Video to favorite
     */
    
    func addVideoToFavorite(videoId : Int, state : Bool) {
        if !IZReachabilityManager.sharedManager().checkInternetConnection() {
            IZAlert.showAlert(self, title: AlertText.TitleNoInternet.rawValue, message: AlertText.NoInternetMessage.rawValue, action: nil)
            return
        }
        
        IZRestFavoriteApiOperation.addToFavoriteVideoListCall(videoId, completed:  { (response) in
            if response {
                self.favoriteButtonState(!state)
                self.singleVideo?.isFavorite = true
            }
        })
    }
    
    /**
     Remove from favorite Video
     */

    func removeVideoFromFavorite(videoId : Int, state : Bool) {
        if !IZReachabilityManager.sharedManager().checkInternetConnection() {
            IZAlert.showAlert(self, title: AlertText.TitleNoInternet.rawValue, message: AlertText.NoInternetMessage.rawValue, action: nil)
            return
        }
        IZRestFavoriteApiOperation.deleteFromFavoriteVideoListCall(videoId, completed: { (response) in
            if response  {
                self.favoriteButtonState(!state)
                self.singleVideo?.isFavorite = false
            }
        })
    }
}



