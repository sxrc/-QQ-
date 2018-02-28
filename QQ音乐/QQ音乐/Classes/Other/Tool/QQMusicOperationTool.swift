//
//  QQMusicOperationTool.swift
//  QQ音乐
//
//  Created by rc on 2017/5/2.
//  Copyright © 2017年 rc. All rights reserved.
//

import UIKit
import MediaPlayer

class QQMusicOperationTool: NSObject {

    private var musicModel = QQMusicMessageModel()
    func getMusicMessageModel() -> QQMusicMessageModel {
        
        musicModel.musicM = musicMs[currentPlayIndex]
        musicModel.costTime = (tool.player?.currentTime) ?? 0
        musicModel.totalTime = tool.player?.duration ?? 0
        
        musicModel.isPlaying = (tool.player?.isPlaying) ?? false
        
        return musicModel
    }
    
    var currentPlayIndex = 0 {
        didSet {
            if currentPlayIndex < 0 {
                currentPlayIndex = musicMs.count - 1
            }
            if currentPlayIndex > musicMs.count - 1 {
                currentPlayIndex = 0
            }
        }
    }
    static let shareInstance = QQMusicOperationTool()
    
    //  音乐模型列表
    var musicMs: [QQMusicmodel] = [QQMusicmodel]()
    
    let tool: QQMusicTool = QQMusicTool()
    
    func playMusic(musicM: QQMusicmodel) -> () {
        
        tool.playMusic(musicName: musicM.filename!)
        currentPlayIndex = musicMs.index(of: musicM)!
    }
    
    // 暂停音乐
    func pauseCurrentMusic() -> () {
        
        tool.pauseMusic()
    }
    
    // 开始
    func playCurrentMusic() -> () {
        
        let model = musicMs[currentPlayIndex]
        playMusic(musicM: model)
    }
    
    // 下一首
    func nextMusic() -> () {
        
        currentPlayIndex += 1
        let model = musicMs[currentPlayIndex]
        
        playMusic(musicM: model)
    }
    
    // 上一首
    func preMusic() -> () {
        
        currentPlayIndex -= 1
        let model = musicMs[currentPlayIndex]
        
        playMusic(musicM: model)
    }
    
    var artWork: MPMediaItemArtwork?
    
    func setupLockMessage() -> () {
        
        let musicMessageM = getMusicMessageModel()
        
        let center = MPNowPlayingInfoCenter.default()
        
        // MPMediaItemPropertyAlbumTitle
        // MPMediaItemPropertyAlbumTrackCount
        // MPMediaItemPropertyAlbumTrackNumber
        // MPMediaItemPropertyArtist
        // MPMediaItemPropertyArtwork
        // MPMediaItemPropertyComposer
        // MPMediaItemPropertyDiscCount
        // MPMediaItemPropertyDiscNumber
        // MPMediaItemPropertyGenre
        // MPMediaItemPropertyPersistentID
        // MPMediaItemPropertyPlaybackDuration
        // MPMediaItemPropertyTitle
        
        let musicName = musicMessageM.musicM?.name ?? ""
        let singerName = musicMessageM.musicM?.singer ?? ""
        let costTime = musicMessageM.costTime
        let totalTime = musicMessageM.totalTime
        let imageName = musicMessageM.musicM?.icon ?? ""
        
        let image = UIImage(named: imageName)
        // 1. 获取当前正在播放的歌词
        
        let lrcFileName = musicMessageM.musicM?.lrcname
        let lrcMs = QQMusicDataTool.getLrcMs(lrcName: lrcFileName)
        let lrcMRow = QQMusicDataTool.getCurrentLrcM(currentTime: musicMessageM.costTime, lrcMs: lrcMs)
        let lrcM = lrcMRow.lrcM
        
        // 1 60
        
        
//        print(lrcM?.lrcContent)
        
//         2. 绘制到图片, 生成一个新的图片
        
        var resultImage: UIImage?
        var lastRow: Int?
        // 0 != -1  0 == 0
        if lastRow != lrcMRow.row {
            lastRow = lrcMRow.row
            resultImage = QQImageTool.getNewImage(sourceImage: image, str: lrcM.lrcContent)
        }
        
        // 3. 设置专辑图片
        if resultImage != nil {
            artWork = MPMediaItemArtwork(image: resultImage!)
        }
        
        let dic: NSMutableDictionary = [
            
            MPMediaItemPropertyAlbumTitle: musicName,
            MPMediaItemPropertyArtist: singerName,
            MPMediaItemPropertyPlaybackDuration: totalTime,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: costTime
            
        ]
        
        if artWork != nil {
            dic.setValue(artWork, forKey: MPMediaItemPropertyArtwork)
        }
        
        let dicCopy = dic.copy()
        center.nowPlayingInfo = dicCopy as? [String: AnyObject]
        

////        if image != nil {
//        
//          let artWork = MPMediaItemArtwork(image: image!)
////        }
//        
//        
//        center.nowPlayingInfo = [MPMediaItemPropertyAlbumTitle: musicName, MPMediaItemPropertyArtist:singerName, MPMediaItemPropertyPlaybackDuration: totalTime, MPNowPlayingInfoPropertyElapsedPlaybackTime: costTime, MPMediaItemPropertyArtwork: artWork]
        
        // 接受远程事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    func seekToTime(time: TimeInterval) -> () {
        
        tool.seekToTime(time: time)
    }
    
}
