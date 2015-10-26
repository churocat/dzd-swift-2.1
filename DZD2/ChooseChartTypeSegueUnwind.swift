//
//  ChooseChartTypeSegueUnwind.swift
//  DZD2
//
//  Created by 竹田 on 2015/10/26.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import UIKit

class ChooseChartTypeSegueUnwind: UIStoryboardSegue {

    override func perform() {
        let chooseChartVC = self.sourceViewController as! ChooseChartTableViewController
        let chartVC = self.destinationViewController as! ChartViewController
        
        chartVC.chartType = chooseChartVC.choosedType
        
        chooseChartVC.dismissViewControllerAnimated(false, completion: nil)
    }
}
