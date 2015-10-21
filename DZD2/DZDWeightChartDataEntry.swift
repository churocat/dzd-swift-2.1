//
//  DZDWeightChartDataEntry.swift
//  DZD2
//
//  Created by 竹田 on 2015/10/15.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import Foundation

class DZDWeightChartDataEntry: ChartDataEntry {
    
    var weightData: DZDWeight
    
    init(weightData: DZDWeight) {
        self.weightData = weightData
        
        super.init(timestamp: weightData.date, value: weightData.weight)
    }
}