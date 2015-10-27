//
//  ChartData.swift
//  TryDrawChart
//
//  Created by 竹田 on 2015/10/5.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import Foundation

class ChartData {

    // MARK: - Properties
    
    internal var dataSets: [ChartDataSet]!
    
    var valueMin : Double = 0
    var valueMax : Double = 0
    var tsMin : Int = 0
    var tsMax : Int = 0
    var dateRange : [NSDate] = []

    
    // MARK: - Initializers
    
    init() {
        dataSets = [ChartDataSet]()
    }
    
    init(dataSets: [ChartDataSet]) {
        self.dataSets = dataSets
        
        initialize(dataSets)
    }
    
    convenience init(dataSet: ChartDataSet) {
        self.init(dataSets: [dataSet])
    }
    
    internal func initialize(dataSets: [ChartDataSet]) {
        calcMinMax()
    }
    
    
    // MARK: - Functions
    
    /// calc min and max values over all datasets
    internal func calcMinMax() {
        if dataSets == nil || dataSets.isEmpty {
            valueMin = 0
            valueMax = 0
            tsMin = 0
            tsMax = 0
        } else {
            valueMin = DBL_MAX
            valueMax = -DBL_MAX
            tsMin = Int(INT_MAX)
            tsMax = Int(-INT_MAX)
            
            for dataSet in dataSets {
                valueMin = min(valueMin, dataSet.valueMin)
                valueMax = max(valueMax, dataSet.valueMax)
                tsMin = min(tsMin, dataSet.tsMin)
                tsMax = max(tsMax, dataSet.tsMax)
            }
        }
        
        // calculate the date range
        var date = NSDate(timeIntervalSince1970: NSTimeInterval(tsMin)).zeroAM
        dateRange = [date]
        
        if date.unixtime.dateString != tsMax.dateString {
            repeat {
                date = date.nextDate
                dateRange.append(date)
            } while date.unixtime.dateString != tsMax.dateString
        }
    }

}