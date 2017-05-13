//
//  IZHeaderSingleVideoCell.swift
//  ShakerApp
//
//  Created by Nikita Gil on 17.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


protocol IZHeaderSingleVideoCellDelegate: NSObjectProtocol {
    
    func shakeButtonWasPressed()
    func shareButtonWasPressed(videoUrl :String)
    func addToFavoriteButtonWasPressed(videoId :Int, state : Bool)
    func playerExitFullScreenMode(isExitedFullScreen :Bool)
}


class IZHeaderSingleVideoCell: UIView {
    
    // @IBOutlet
    @IBOutlet weak var titleSubjectLabel        : UILabel!
    @IBOutlet weak var titleUniversityLabel     : UILabel!
    @IBOutlet weak var detailLabel              : UILabel!
    @IBOutlet weak var videoContainerView       : UIView!
    @IBOutlet weak var favoriteImageView        : UIImageView!
    
    // var
    var playerController            : AVPlayerViewController?
    var currentVideoLandingModel    : IZLandingModel?
    
    weak var delegate               : IZHeaderSingleVideoCellDelegate?
    weak var viewController         : IZSingleVideoViewController?
    var observerCounter             : [String]?
    
    let observerString = "Observer Added"
    var isExitedFullScreen = false
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.observerCounter = [String]()
    }

    deinit {

        self.removePlayer()
    }
    
    /**
     Get IZShowMoreSeparatorCell from xib
     
     - parameter bundle: bundle for search. Default nil
     
     - returns: object IZShowMoreSeparatorCell
     */
    
    class func loadFromXib(bundle : NSBundle? = nil) -> IZHeaderSingleVideoCell? {
        return UINib(
            nibName: IZRouterConstant.kIZHeaderSingleVideoCell,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? IZHeaderSingleVideoCell
    }
    
    //*****************************************************************
    // MARK: - Setup / Delete Player
    //*****************************************************************
    
    func pausePlayer() {
        self.playerController?.player?.pause()
    }
    
    func removePlayer() {
        
        if self.observerCounter?.count > 0 {
            
            if !self.isExitedFullScreen {
                self.exitFromFullScreen()
            }
            self.playerController!.player?.pause()
  
            self.playerController?.player?.removeObserver(self, forKeyPath: "actionAtItemEnd")
            self.playerController?.player?.currentItem?.removeObserver(self, forKeyPath: "status")
            self.playerController?.removeObserver(self, forKeyPath: "videoBounds") //crash ios8
            
            self.playerController?.view.removeFromSuperview()
            self.playerController = nil
            
            self.observerCounter?.removeLast()
            self.observerCounter?.removeLast()
            self.observerCounter?.removeLast()
        }
    }

    //*****************************************************************
    // MARK: - Set Data
    //*****************************************************************
    
    func updateData(item: IZLandingModel) {
        
        self.currentVideoLandingModel = item
        
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
        
        if let videoUrl = item.videoUrl as String? {
            self.createPlayer(videoUrl)
        } else {
            IZAlert.showAlertError(self.viewController, message: AlertText.NoURLMessage.rawValue, done: nil)
        }
        
        if let isFavorite = item.isFavorite as Bool? {
            self.favoriteButtonState(isFavorite)
        }
    }
    
    private func createPlayer(urlVideo : String) {
        let newUrl =  "http://cdn.gravlab.net/sparse/v1d30/2013/nightskyHLS/Lapse2.m3u8"
        let url = NSURL(string: newUrl)
        
        let asset: AVURLAsset = AVURLAsset(URL: url!, options: nil)
        let statusKey = "tracks"
        
        asset.loadValuesAsynchronouslyForKeys([statusKey], completionHandler: {
            var error: NSError? = nil
            
            dispatch_async(dispatch_get_main_queue(), {
                let status: AVKeyValueStatus = asset.statusOfValueForKey(statusKey, error: &error)
                
                if status == AVKeyValueStatus.Loaded{
                    
                    let playerItem = AVPlayerItem(asset: asset)
                    playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(), context: nil)
                    
                    let player = AVPlayer(playerItem: playerItem)
                    
                    //let playerLayer = AVPlayerLayer(player: player)
                   
                    self.playerController = AVPlayerViewController()
                    self.playerController?.player = player
                    self.playerController?.contentOverlayView!.addObserver(self, forKeyPath: "videoBounds", options: [NSKeyValueObservingOptions.New , NSKeyValueObservingOptions.Old], context: nil)
                    self.playerController?.player?.addObserver(self, forKeyPath: "actionAtItemEnd", options: [], context: nil)
                    
                    self.observerCounter?.append(self.observerString)
                    self.observerCounter?.append(self.observerString)
                    self.observerCounter?.append(self.observerString)
                    
                    self.playerController?.view.frame = CGRect(x: 0, y: 0, width: self.videoContainerView.frame.width, height: self.videoContainerView.frame.height)
                    self.playerController?.view.backgroundColor = UIColor.blackColor()
                    self.videoContainerView.addSubview(self.playerController!.view)
                    //self.videoContainerView.layer.addSublayer(playerLayer)
                   
                    player.volume = AVAudioSession.sharedInstance().outputVolume
                    player.play()
    
                } else {
                    print(error!.localizedDescription)
                    IZAlert.showAlertError(self.viewController, message: error!.localizedDescription, done: nil)
                }
            })
        })
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func shakeButtonPressed(sender: UIButton) {
        
        if let delegate = self.delegate as IZHeaderSingleVideoCellDelegate? {
            delegate.shakeButtonWasPressed()
        }
    }
    
    @IBAction func shareButtonPressed(sender: UIButton) {
        
        if let delegate = self.delegate as IZHeaderSingleVideoCellDelegate? {
            var url = ""
            if let link = self.currentVideoLandingModel?.links as String? {
                url = link
            } else {
                url = "url fehlt"
            }
            delegate.shareButtonWasPressed(url)
        }
    }
    
    @IBAction func favoriteButtonPressed(sender: UIButton) {
        
        if let delegate = self.delegate as IZHeaderSingleVideoCellDelegate? {
            delegate.addToFavoriteButtonWasPressed((self.currentVideoLandingModel?.idVideo)!, state: (self.currentVideoLandingModel?.isFavorite)!)
        }
    }
    
    //*****************************************************************
    // MARK: - Observer
    //*****************************************************************
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        test()
        if keyPath == "videoBounds" {
            
            if let  dict = change   {
                
                let newBounds = dict[NSKeyValueChangeNewKey]?.CGRectValue()

                if newBounds?.width == UIScreen.mainScreen().bounds.width {
                    
                    print("entered fullscreen")
                    let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appdelegate.shouldSupportAllOrientation = true
                    self.isExitedFullScreen = false
                    
                } else if newBounds?.width != UIScreen.mainScreen().bounds.width &&
                    newBounds?.width != UIScreen.mainScreen().bounds.height {
                    
                    print("exited fullscreen")
                    self.isExitedFullScreen = true
                    self.exitFromFullScreen()
                }
            }
        }
        if keyPath == "actionAtItemEnd" {
            
            if let player = object as! AVPlayer? {
                player.seekToTime(kCMTimeZero)
            }
            self.exitFromFullScreen()
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
    
    private func exitFromFullScreen() {
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.shouldSupportAllOrientation = false
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        if let delegate = self.delegate as IZHeaderSingleVideoCellDelegate? {
            delegate.playerExitFullScreenMode(self.isExitedFullScreen)
        }
    }
    
    func test() {
        let item = self.playerController?.player?.currentItem
        var fps :Float = 0.0
        for track in (item?.tracks)! {
            if track.assetTrack.mediaType == AVMediaTypeVideo {
                fps = track.currentVideoFrameRate
                print(fps)
            }
        }
    }
    
    //*****************************************************************
    // MARK: - favorite State
    //*****************************************************************

    func favoriteButtonState(state : Bool) {
        if state {
            self.favoriteImageView.image = UIImage(named: "fill_favorite_button")
        } else {
            self.favoriteImageView.image = UIImage(named: "favorite_button")
        }
    }
}
