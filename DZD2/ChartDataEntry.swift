//
//  ChartDataEntry.swift
//  TryDrawChart
//
//  Created by 竹田 on 2015/10/6.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import Foundation
import UIKit

class ChartDataEntry {
    
    // MARK: - Properties

    /// the actual value (y axis)
    var value = Double(0.0)
    
    /// the timestamp of data (x axis)
    var timestamp = Int(0)

    /// the point to draw
    var pixelPt = CGPoint.zero

    
    // MARK: - Initializers
    
    init(timestamp: Int, value: Double) {
        self.value = value
        self.timestamp = timestamp
    }
    
}