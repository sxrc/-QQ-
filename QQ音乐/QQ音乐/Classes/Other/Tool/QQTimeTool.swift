//
//  QQTimeTool.swift
//  QQ音乐
//
//  Created by rc on 2017/5/3.
//  Copyright © 2017年 rc. All rights reserved.
//

import UIKit

class QQTimeTool: NSObject {

    class func getFormatTime(timeInterval: TimeInterval) -> String {
        
        let  min = Int(timeInterval) / 60
        let sec = Int(timeInterval) % 60
        
        return String(format: "%02d: %02d", min, sec)
    }
    
    class func getTimeinterval(formantTime: String) -> TimeInterval {
        
        let minSec = formantTime.components(separatedBy: ":")
        
        if minSec.count != 2 {
            return 0
        }
        
        let min = Double(minSec.first!) ?? 0.0
        let sec = Double(minSec.last!) ?? 0.0
        
        return min * 60 + sec
        
    }

}
