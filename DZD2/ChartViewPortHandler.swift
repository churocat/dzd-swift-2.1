//
//  ChartViewPortHandler.swift
//  TryDrawChart
//
//  Created by 竹田 on 2015/10/6.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import Foundation
import CoreGraphics

class ChartViewPortHandler {
    
    // MARK: - Properties
    
    var chartWidth = CGFloat(0.0)
    var chartHeight = CGFloat(0.0)

    /// this rectangle defines the area in which graph values can be drawn
    var contentRect = CGRect()
    
    var contentWidth: CGFloat { return contentRect.size.width }
    var contentHeight: CGFloat { return contentRect.size.height }
    
    var contentTop: CGFloat { return contentRect.origin.y }
    var contentLeft: CGFloat { return contentRect.origin.x }
    var contentRight: CGFloat { return contentRect.origin.x + contentRect.size.width }
    var contentBottom: CGFloat { return contentRect.origin.y + contentRect.size.height }
    
    var offsetLeft: CGFloat { return contentRect.origin.x }
    var offsetRight: CGFloat { return chartWidth - contentRect.size.width - contentRect.origin.x }
    var offsetTop: CGFloat { return contentRect.origin.y }
    var offsetBottom: CGFloat { return chartHeight - contentRect.size.height - contentRect.origin.y }
    
    
    // MARK: - Functions
    
    func setChartDimens(width width: CGFloat, height: CGFloat) {
        let offsetLeft = self.offsetLeft
        let offsetTop = self.offsetTop
        let offsetRight = self.offsetRight
        let offsetBottom = self.offsetBottom
        
        chartHeight = height
        chartWidth = width
        
        restrainViewPort(offsetLeft: offsetLeft, offsetTop: offsetTop, offsetRight: offsetRight, offsetBottom: offsetBottom)
    }
    
    func restrainViewPort(offsetLeft offsetLeft: CGFloat, offsetTop: CGFloat, offsetRight: CGFloat, offsetBottom: CGFloat) {
        contentRect.origin.x = offsetLeft
        contentRect.origin.y = offsetTop
        contentRect.size.width = chartWidth - offsetLeft - offsetRight
        contentRect.size.height = chartHeight - offsetBottom - offsetTop
    }
    
}