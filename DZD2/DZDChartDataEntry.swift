//
//  DZDWeightChartDataEntry.swift
//  DZD2
//
//  Created by 竹田 on 2015/10/15.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import Foundation

class DZDChartDataEntry: ChartDataEntry {
    
    var dataObject: DZDDataObject
    
    init(dataObject: DZDDataObject) {
        self.dataObject = dataObject
        
        super.init(timestamp: dataObject.date, value: dataObject.value)
    }
}