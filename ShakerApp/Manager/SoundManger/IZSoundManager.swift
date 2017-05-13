//
//  IZSoundManager.swift
//  ShakerApp
//
//  Created by Nikita Gil on 22.08.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit
import AudioToolbox

class IZSoundManager  : NSObject {
    
    var player     : AVAudioPlayer?
    var itemsArray : [NSURL]?
    
    override init() {
        super.init()
        
        guard let url1 = NSBundle.mainBundle().URLForResource("Sound1", withExtension: "wav"),
            let url2 = NSBundle.mainBundle().URLForResource("Sound2", withExtension: "wav"),
            let url3 = NSBundle.mainBundle().URLForResource("Sound3", withExtension: "wav"),
            let url4 = NSBundle.mainBundle().URLForResource("Sound4", withExtension: "wav"),
            let url5 = NSBundle.mainBundle().URLForResource("Sound5", withExtension: "wav"),
            let url6 = NSBundle.mainBundle().URLForResource("Sound6", withExtension: "wav"),
            let url7 = NSBundle.mainBundle().URLForResource("Sound7", withExtension: "wav"),
            let url8 = NSBundle.mainBundle().URLForResource("Sound8", withExtension: "wav"),
            let url9 = NSBundle.mainBundle().URLForResource("Sound9", withExtension: "wav"),
            let url10 = NSBundle.mainBundle().URLForResource("Sound10", withExtension: "wav"),
            let url11 = NSBundle.mainBundle().URLForResource("Sound11", withExtension: "wav"),
            let url12 = NSBundle.mainBundle().URLForResource("Sound12", withExtension: "wav"),
            let url13 = NSBundle.mainBundle().URLForResource("Sound13", withExtension: "wav"),
            let url14 = NSBundle.mainBundle().URLForResource("Sound14", withExtension: "wav")  else {
            return
        }
        self.itemsArray = [url1, url2, url3, url4, url5, url6, url7, url8, url9, url10, url11, url12, url13, url14]
    }
    
    func playSound() {
        
        if self.player != nil {
            self.player?.stop()
        }
        self.vibrateDevice()
        let random : UInt32 = arc4random_uniform(14);
        print(random)
        let item = self.itemsArray![Int(random)]
        
        do{
            try self.player = AVAudioPlayer(contentsOfURL: item)
            self.player?.volume = 1.0
            self.player?.numberOfLoops = 0
            self.player?.prepareToPlay()
            self.player?.play()
        }catch let error as NSError {
            print(error)
        }
    }
    
    func playerStop(){
        self.player?.stop()
    }
    
    func vibrateDevice() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}

/*
 http://stackoverflow.com/questions/34105022/ios-9-how-to-detect-silent-mode
 */

