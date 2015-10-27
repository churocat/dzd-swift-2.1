//
//  ChartToAddSegue.swift
//  DZD2
//
//  Created by 竹田 on 2015/10/27.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import UIKit

class ChartToAddSegue: UIStoryboardSegue {

    override func perform() {
        let chartVC = self.sourceViewController as! ChartViewController
        let addVC = self.destinationViewController as! AddItemViewController
        
        addVC.recordType = chartVC.chartType
        
        chartVC.presentViewController(addVC, animated: true, completion: nil)
    }

}