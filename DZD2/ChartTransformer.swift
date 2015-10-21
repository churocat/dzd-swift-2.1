//
//  ChartTransformer.swift
//  TryDrawChart2
//
//  Created by 竹田 on 2015/10/14.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import Foundation
import CoreGraphics

class ChartTransformer {
    
    // MARK: - Properties
    
    /// matrix to map the values to the screen pixels
    internal var _matrixValueToPx = CGAffineTransformIdentity
    
    /// matrix for handling the different offsets of the chart
    internal var _matrixOffset = CGAffineTransformIdentity
    
    internal var _viewPortHandler: ChartViewPortHandler
    
    var valueToPixelMatrix: CGAffineTransform {
        return CGAffineTransformConcat(_matrixValueToPx, _matrixOffset)
    }
    
    
    // MARK: - Initializers
    
    init(viewPortHandler: ChartViewPortHandler) {
        _viewPortHandler = viewPortHandler
    }
    
    
    // MARK: - Functions
    
    /// prepares the matrix that transforms values to pixels
    /// calculates the scale factors from the charts size and offsets
    func prepareMatrixValuePx(chartYMin chartYMin: Double, deltaY: CGFloat, axisLabelWidth: CGFloat) {
        let scaleX = axisLabelWidth
        let scaleY = (_viewPortHandler.contentHeight / deltaY)
        
        // setup all matrices
        _matrixValueToPx = CGAffineTransformIdentity
        _matrixValueToPx = CGAffineTransformScale(_matrixValueToPx, scaleX, -scaleY)
        _matrixValueToPx = CGAffineTransformTranslate(_matrixValueToPx, 0, CGFloat(-chartYMin))
    }
    
    /// prepares the matrix that contains all offsets
    func prepareMatrixOffset(axisLabelWidth axisLabelWidth: CGFloat) {
        _matrixOffset = CGAffineTransformMakeTranslation(_viewPortHandler.offsetLeft + axisLabelWidth/2, _viewPortHandler.chartHeight - _viewPortHandler.offsetBottom)
    }
    
}