//
//  ChartAxis.swift
//  TryDrawChart
//
//  Created by 竹田 on 2015/10/7.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import Foundation
import UIKit


class ChartAxis {
    
    // MARK: - Properties
    
    var entries : [NSDate] = []
    
    /// attribute of day label
    var dayLabelFont = ChartSettings.Axis.DayLabel.Font
    var dayLabelTextColor = ChartSettings.Axis.DayLabel.TextColor
    
    /// attribute of dayOfWeek label
    var dayOfWeekLabelFont = ChartSettings.Axis.DayOfWeekLabel.Font
    var dayOfWeekLabelTextColor = ChartSettings.Axis.DayOfWeekLabel.TextColor
    
    /// the y-distance between day label and dayOfWeek label
    /// it's alse the distance between labels and margin
    var labelOffset = ChartSettings.Axis.Label.Offset
    
    /// fixed label width
    var labelWidth = ChartSettings.Axis.Label.Width
    
    /// label height
    var labelHeight: CGFloat {
        return dayLabelFont.lineHeight + dayOfWeekLabelFont.lineHeight + labelOffset * 3
    }
    
    /// the y-distance between stroke line and margin
    var strokeLineOffset = ChartSettings.Axis.StrokeLineOffset
    
    /// label position
    enum LabelPosition: Int {
        case Top
        case Bottom
    }
    var labelPosition: ChartAxis.LabelPosition


    // MARK: - Initializers
    
    init(position: ChartAxis.LabelPosition) {
        labelPosition = position
    }

}