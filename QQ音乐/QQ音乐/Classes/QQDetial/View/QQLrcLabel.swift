//
//  QQLrcLabel.swift
//  QQ音乐
//
//  Created by rc on 2017/5/5.
//  Copyright © 2017年 rc. All rights reserved.
//

import UIKit

class QQLrcLabel: UILabel {

    var radio: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        super .draw(rect)
        
        UIColor.red.set()
        
        let fillRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width * radio, height: rect.height)
        
        UIRectFillUsingBlendMode(fillRect, CGBlendMode.sourceIn)
    }
 

}
