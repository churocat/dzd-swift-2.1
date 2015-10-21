//
//  LineChartRenderer.swift
//  TryDrawChart2
//
//  Created by 竹田 on 2015/10/13.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import Foundation
import UIKit

protocol LineChartDataRendererDelegate {
    func lineChartDataRendererGetData(renderer: LineChartDataRenderer) -> ChartData!
    func lineChartDataRendererGetTransformer(renderer: LineChartDataRenderer) -> ChartTransformer!
}

class LineChartDataRenderer: ChartDataRenderer {

    var delegate: LineChartDataRendererDelegate?
    
    init(delegate: LineChartDataRendererDelegate?, viewPortHandler: ChartViewPortHandler) {
        super.init(viewPortHandler: viewPortHandler)
        
        self.delegate = delegate
    }

    override func drawData(context context: CGContext?) {
        let lineData = delegate!.lineChartDataRendererGetData(self)
        
        if lineData === nil {
            return
        }
        
        for dataSet in lineData.dataSets {
            drawDataSet(context: context, dataSet: dataSet as! LineChartDataSet, tsMin: lineData.tsMin)
        }
    }
    
    internal func drawDataSet(context context: CGContext?, dataSet: LineChartDataSet, tsMin: Int) {
        preparePixelPt(dataSet.dataEntries, tsMin: tsMin)
        
        CGContextSaveGState(context)
        CGContextSetLineWidth(context, dataSet.lineWidth)
        drawLinear(context: context, dataSet: dataSet)
        drawCircles(context: context, dataSet: dataSet)
        drawTexts(context: context, dataSet: dataSet)
        CGContextRestoreGState(context)
    }
    
    internal func preparePixelPt(dataEntries: [ChartDataEntry], tsMin: Int) {
        for dataEntry in dataEntries {
            let trans = delegate!.lineChartDataRendererGetTransformer(self)
            let valueToPixelMatrix = trans.valueToPixelMatrix
            
            let ptX = CGFloat(ChartUtils.calcDays(ts1: tsMin, ts2: dataEntry.timestamp))
            let ptY = CGFloat(dataEntry.value)
            
            dataEntry.pixelPt = CGPointApplyAffineTransform(CGPoint(x: ptX, y: ptY), valueToPixelMatrix)
        }
    }
    
    internal func drawLinear(context context: CGContext?, dataSet: LineChartDataSet) {
        let dataEntries = dataSet.dataEntries
        var lineSegments: [CGPoint] = []
        for var i = 0; i < dataEntries.count - 1; ++i {
            let entryFrom = dataEntries[i]
            let entryTo = dataEntries[i+1]
            
            lineSegments += [entryFrom.pixelPt, entryTo.pixelPt]
        }

        CGContextSaveGState(context)
        CGContextSetStrokeColorWithColor(context, dataSet.color.CGColor)
        CGContextStrokeLineSegments(context, lineSegments, lineSegments.count)
        CGContextRestoreGState(context)
    }
    
    internal func drawCircles(context context: CGContext?, dataSet: LineChartDataSet) {
        CGContextSaveGState(context)
        CGContextSetFillColorWithColor(context, dataSet.color.CGColor)
        
        for dataEntry in dataSet.dataEntries {
            let rect = CGRect(x: dataEntry.pixelPt.x - dataSet.circleRadius,
                              y: dataEntry.pixelPt.y - dataSet.circleRadius,
                              width: dataSet.circleRadius * 2,
                              height: dataSet.circleRadius * 2)
            
            
            
            CGContextFillEllipseInRect(context, rect)
            
        }
        
        CGContextRestoreGState(context)
    }

    internal func drawTexts(context context: CGContext?, dataSet: LineChartDataSet) {
        let textFont  = dataSet.textFont
        let textColor = dataSet.textColor
        
        for dataEntry in dataSet.dataEntries {
            ChartUtils.drawText(context: context, text: dataEntry.value.description,
                point: CGPoint(x: dataEntry.pixelPt.x, y: dataEntry.pixelPt.y - textFont.lineHeight/2),
                align: .Center,
                attributes: [NSFontAttributeName: textFont, NSForegroundColorAttributeName: textColor]
            )
        }
    }

}