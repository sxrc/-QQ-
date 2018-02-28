//
//  QQMusicTool.swift
//  QQ音乐
//
//  Created by rc on 2017/5/2.
//  Copyright © 2017年 rc. All rights reserved.
//

import UIKit
import AVFoundation

let kPlayFinishNotification = "playFinish"

class QQMusicTool: NSObject {

    override init() {
        super.init()
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch  {
            print(error)
            return
        }
        
        do {
            try session.setActive(true)
        } catch  {
            print(error)
            return
        }
        
        
    }
    
    var player: AVAudioPlayer?
    
    func seekToTime(time: TimeInterval) -> () {
        
        player?.currentTime = time
    }
    
    func playMusic(musicName: String) -> () {
        
        // 获取需要播放的音乐文件路径
        guard let url = Bundle.main.url(forResource: musicName, withExtension: nil) else {
            
            return
        }
        
        if player?.url == url {
            player?.play()
            return
        }
        
        // 创建播放器
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            // 准备播放
            player?.prepareToPlay()
            
            // 开始播放
            player?.play()
        } catch  {
            print(error)
            return
        }
        
    }
 
    func pauseMusic() -> () {
        
        player?.pause()
    }
}

extension QQMusicTool: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) -> () {
        
        print("播放完成")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPlayFinishNotification), object: nil)
    }
}
