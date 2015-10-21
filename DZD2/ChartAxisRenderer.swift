//
//  ChartAxisRenderer.swift
//  TryDrawChart
//
//  Created by 竹田 on 2015/10/6.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit


class ChartAxisRenderer {
    
    // MARK: - Properties

    internal var axis: ChartAxis!
    
    /// the component that handles the drawing area of the chart and it's offsets
    var viewPortHandler: ChartViewPortHandler!
    
    private var dayLabelY: CGFloat {
        switch self.axis.labelPosition {
        case .Top:
            return viewPortHandler.contentTop - axis.labelHeight + axis.labelOffset
        case .Bottom:
            return viewPortHandler.contentBottom + axis.labelOffset * 2 + axis.dayOfWeekLabelFont.lineHeight
        }
    }
    
    private var dayOfWeekLabelY: CGFloat {
        switch self.axis.labelPosition {
        case .Top:
            return viewPortHandler.contentTop - axis.labelHeight + axis.labelOffset * 2 + axis.dayLabelFont.lineHeight
        case .Bottom:
            return viewPortHandler.contentBottom + axis.labelOffset
        }
    }
    
    
    // MARK: - Initializers
    
    init(viewPortHandler: ChartViewPortHandler, axis: ChartAxis) {
        self.viewPortHandler = viewPortHandler
        self.axis = axis
    }
    
    
    // MARK: - Functions
    
    /// set the axis values
    func setAxis(dateRange: [NSDate]) {
        axis.entries = dateRange
    }
    
    func drawAxisLabels(context context: CGContext?) {
        var labelX = viewPortHandler.offsetLeft + axis.labelWidth / 2
        var dayLabelPt = CGPoint(x: labelX, y: dayLabelY)
        var dayOfWeekLabelPt = CGPoint(x: labelX, y: dayOfWeekLabelY)
        
        for entry in axis.entries {
            strokeVerticalLine(context: context, x: labelX)
            drawDayLabel(context: context, text: entry.day, pt: dayLabelPt)
            drawDayOfWeekLabel(context: context, text: entry.dayOfWeek, pt: dayOfWeekLabelPt)
            
            labelX += axis.labelWidth
            dayLabelPt.x = labelX
            dayOfWeekLabelPt.x = labelX
        }
    }
    
    internal func strokeVerticalLine(context context: CGContext?, x: CGFloat) {
        let frontLineX = x - axis.labelWidth/2
        let tailLineX  = x + axis.labelWidth/2
        
        let yFrom = viewPortHandler.contentTop + axis.strokeLineOffset
        let yTo = viewPortHandler.contentBottom - axis.strokeLineOffset
        
        let frontLineStartPoint = CGPoint(x: frontLineX, y: yFrom)
        let frontLineEndPoint   = CGPoint(x: frontLineX, y: yTo)
        let tailLineStartPoint  = CGPoint(x: tailLineX, y: yFrom)
        let tailLineEndPoint    = CGPoint(x: tailLineX, y: yTo)
        
        let lineSegments = [frontLineStartPoint, frontLineEndPoint, tailLineStartPoint, tailLineEndPoint]
        
        // draw lines
        CGContextSaveGState(context)
        CGContextSetStrokeColorWithColor(context, UIColor.lightGrayColor().CGColor)
        CGContextStrokeLineSegments(context, lineSegments, lineSegments.count)
        CGContextRestoreGState(context)
    }
    
    internal func drawDayOfWeekLabel(context context: CGContext?, text: String, pt: CGPoint) {
        ChartUtils.drawText(context: context, text: text, point: pt,
            align: .Center,
            attributes: [NSFontAttributeName: axis.dayOfWeekLabelFont, NSForegroundColorAttributeName: axis.dayOfWeekLabelTextColor])
    }
    
    internal func drawDayLabel(context context: CGContext?, text: String, pt: CGPoint) {
        ChartUtils.drawText(context: context, text: text, point: pt,
            align: .Center,
            attributes: [NSFontAttributeName: axis.dayLabelFont, NSForegroundColorAttributeName: axis.dayLabelTextColor])
    }
    
}