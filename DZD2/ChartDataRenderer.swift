//
//  ChartDataRenderer.swift
//  TryDrawChart2
//
//  Created by 竹田 on 2015/10/13.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import Foundation
import UIKit

class ChartDataRenderer {
    
    /// the component that handles the drawing area of the chart and it's offsets
    var viewPortHandler: ChartViewPortHandler!


    init(viewPortHandler: ChartViewPortHandler) {
        self.viewPortHandler = viewPortHandler
    }


    func drawData(context context: CGContext?) {
        fatalError("drawData() cannot be called on ChartDataRendererBase")
    }
}