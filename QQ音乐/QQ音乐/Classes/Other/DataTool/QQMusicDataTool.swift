//
//  QQMusicDataTool.swift
//  QQ音乐
//
//  Created by rc on 2017/4/22.
//  Copyright © 2017年 rc. All rights reserved.
//

import UIKit

class QQMusicDataTool: NSObject {

    class func getMusicMs (result: ([QQMusicmodel])->()) {
        
        guard let path = Bundle.main.path(forResource: "Musics.plist", ofType: nil) else {
            result([QQMusicmodel]())
            return
        }
        
        guard let array = NSArray(contentsOfFile: path) else {
            result([QQMusicmodel]())
            return
        }
        
        var models = [QQMusicmodel]()
        
        for dic in array {
            let model = QQMusicmodel(dic: dic as! [String : AnyObject])
            models.append(model)
        }
        
        result(models)
    }


    class func getLrcMs(lrcName: String?) -> [QQLrcModel] {
        
        if lrcName == nil {
            return [QQLrcModel]()
        }
        
        // 获取文件路径
        guard let path = Bundle.main.path(forResource: lrcName, ofType: nil) else {
            return[QQLrcModel]()
        }
        
        // 读取文件
        var lrcContect = ""
        do {
            lrcContect = try String(contentsOfFile: path)

        } catch {
            print(error)
            return[QQLrcModel]()
        }
        
        // 解析：转换成歌曲模型
//        print(lrcContect)
        let timeContentArray = lrcContect.components(separatedBy: "\n")
        
        var resultMs = [QQLrcModel]()
        for timeContentStr in timeContentArray {
            
            // 过滤垃圾数据
            if timeContentStr.contains("[ti:") || timeContentStr.contains("[ar:") || timeContentStr.contains("[al:") {
                continue
            }
            
            // 拿到有用数据
            let resultLrcStr = timeContentStr.replacingOccurrences(of: "[", with: "")
//            print(resultLrcStr)
            
            // 02:18.64]
            // 02:22.00]为什么难过　有什么难过　为什么难过
            let timeAndContent = resultLrcStr.components(separatedBy: "]")
            
//            print(timeAndContent)
            if timeAndContent.count != 2 {
                continue
            }
            
            let time = timeAndContent[0]
            let content = timeAndContent[1]
            
            // 创建模型赋值
            let lrcM = QQLrcModel()
            resultMs.append(lrcM)
            lrcM.beginTime = QQTimeTool.getTimeinterval(formantTime: time)
            lrcM.lrcContent = content
        }
        
        let count = resultMs.count
        for i in 0..<count {
            if i == count - 1 {
                continue
            }
            
            let lrcM = resultMs[i]
            let nextlrcM = resultMs[i+1]
            lrcM.endTime = nextlrcM.beginTime
    
        }
        
//        print(resultMs)
        // 返回结果
        return resultMs
    }

    class func getCurrentLrcM(currentTime: TimeInterval, lrcMs: [QQLrcModel]) -> (row: Int, lrcM: QQLrcModel) {
        
        var index = 0
        
        for lrcM in lrcMs {
            
            if currentTime >= lrcM.beginTime && currentTime <= lrcM.endTime {
                return (index, lrcM)
            }
            index += 1
        }
        
        return (0, lrcMs.first!)
    }

}
