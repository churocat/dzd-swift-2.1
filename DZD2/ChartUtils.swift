//
//  ChartUtils.swift
//  TryDrawChart
//
//  Created by 竹田 on 2015/10/5.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import Foundation
import UIKit

internal class ChartUtils {
    
    internal class func drawText(context context: CGContext?, text: String, var point: CGPoint, align: NSTextAlignment, attributes: [String : AnyObject]?) {
        if align == .Center {
            point.x -= text.sizeWithAttributes(attributes).width / 2.0
        } else if align == .Right {
            point.x -= text.sizeWithAttributes(attributes).width
        }
        
        UIGraphicsPushContext(context)
        (text as NSString).drawAtPoint(point, withAttributes: attributes)
        UIGraphicsPopContext()
    }
    
    internal class func calcDays(ts1 ts1: Int, ts2: Int) -> Int {
        let ts1ZeroAM = NSDate(timeIntervalSince1970: NSTimeInterval(ts1)).unixtimeZeroAM
        let ts2ZeroAM = NSDate(timeIntervalSince1970: NSTimeInterval(ts2)).unixtimeZeroAM
        return abs(ts1ZeroAM - ts2ZeroAM) / 86400
    }
    
}



public func UIGraphicsPushContext(context: CGContext?) {
    
    guard let context = context else {
        return
    }
    
    UIGraphicsPushContext(context)
    
}
