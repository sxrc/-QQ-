//
//  QQImageTool.swift
//  QQ音乐
//
//  Created by rc on 2017/5/5.
//  Copyright © 2017年 rc. All rights reserved.
//

import UIKit

class QQImageTool: NSObject {

    class func getNewImage(sourceImage: UIImage?, str: String?) -> UIImage? {
        
        guard let image = sourceImage else {
            return nil
        }
        guard let resultStr = str else {
            return nil
        }
        
        let size = image.size
//        let rect = image.accessibilityFrame
//        let size = rect.size
        // 开启图形上下文
        UIGraphicsBeginImageContext(size)
        
        // 绘制图片
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // 绘制文字
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let textRect = CGRect(x: 0, y: 0, width: size.width, height: 18)
        let textDic = [NSForegroundColorAttributeName: UIColor.red, NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSParagraphStyleAttributeName: style]
        
        (resultStr as NSString).draw(in: textRect, withAttributes: textDic)
        
        // 取出图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭图形上下文
        UIGraphicsEndImageContext()
        
        return resultImage
    }
    
}
