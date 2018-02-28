//
//  QQMusicmodel.swift
//  QQ音乐
//
//  Created by rc on 2017/4/22.
//  Copyright © 2017年 rc. All rights reserved.
//

import UIKit

class QQMusicmodel: NSObject {

    var name: String?
    
    var filename: String?
    
    var lrcname: String?
    
    var singer: String?
    
    var singerIcon: String?
    
    var icon: String?
    
    override init() {
        super.init()
    }
    
    init(dic: [String: AnyObject]) {
        super.init()
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
