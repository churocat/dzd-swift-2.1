//
//  LineChartDataSet.swift
//  TryDrawChart
//
//  Created by 竹田 on 2015/10/6.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import Foundation

class ChartDataSet {
    
    // MARK: - Properties
    
    private var _dataEntries: [ChartDataEntry] = []
    var dataEntries: [ChartDataEntry] {
        get {
            return _dataEntries
        }
        set {
            _dataEntries = newValue.sort() { return $0.timestamp > $1.timestamp }
        }
    }
    
    var valueMin: Double = 0
    var valueMax: Double = 0
    var tsMin: Int = 0
    var tsMax: Int = 0


    // MARK: - Initializers
    
    init (dataEntries: [ChartDataEntry]) {
        self.dataEntries = dataEntries
        
        calcMinMax()
    }

    
    // MARK: - Functions
    
    internal func calcMinMax() {
        valueMin = DBL_MAX
        valueMax = -DBL_MAX
        tsMin = Int(INT_MAX)
        tsMax = Int(-INT_MAX)
        
        for dataEntry in dataEntries {
            valueMin = min(valueMin, dataEntry.value)
            valueMax = max(valueMax, dataEntry.value)
            tsMin = min(tsMin, dataEntry.timestamp)
            tsMax = max(tsMax, dataEntry.timestamp)
        }
    }

}