//
//  LineChartView.swift
//  TryDrawChart2
//
//  Created by 竹田 on 2015/10/8.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import Foundation
import UIKit

class LineChartView: ChartView, LineChartDataRendererDelegate {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dataRenderer = LineChartDataRenderer(delegate: self, viewPortHandler: viewPortHandler)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        dataRenderer = LineChartDataRenderer(delegate: self, viewPortHandler: viewPortHandler)
    }
    
    // MARK: - LineChartDataRendererDelegate
    
    func lineChartDataRendererGetData(renderer: LineChartDataRenderer) -> ChartData! {
        return _data
    }
    
    func lineChartDataRendererGetTransformer(renderer: LineChartDataRenderer) -> ChartTransformer! {
        return chartTransformer
    }
    
}