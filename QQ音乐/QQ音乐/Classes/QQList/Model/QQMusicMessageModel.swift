//
//  QQMusicMessageModel.swift
//  QQ音乐
//
//  Created by rc on 2017/5/3.
//  Copyright © 2017年 rc. All rights reserved.
//

import UIKit

class QQMusicMessageModel: NSObject {

    var musicM: QQMusicmodel?
    
    // 已经播放时长
    var costTime: TimeInterval = 0
    // 总时长
    var totalTime: TimeInterval = 0
    // 播放状态
    var isPlaying: Bool = false
}
