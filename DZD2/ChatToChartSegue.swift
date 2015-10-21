//
//  ChatToChartSegue.swift
//  ParseStarterProject-Swift
//
//  Created by 竹田 on 2015/9/22.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit

class ChatToChartSegue: UIStoryboardSegue {

    override func perform() {
        // assign the source and destination views to local variables
        let chatVCView = self.sourceViewController.view as UIView!
        let chartVCView = self.destinationViewController.view as UIView!

        // get heights
        let screenHeight = UIScreen.mainScreen().bounds.size.height

        let chartVC = self.destinationViewController as! ChartViewController
        let offset = chartVC.memberContainerView.bounds.height

//        let window = UIApplication.sharedApplication().keyWindow
//        window?.insertSubview(chartVCView, aboveSubview: chatVCView)

        // animate the transition
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            chartVCView.frame = CGRectOffset(chartVCView.frame, 0.0, screenHeight - offset)
            chatVCView.frame = CGRectOffset(chatVCView.frame, 0.0, screenHeight - offset)

            }) { (Finished) -> Void in

                self.sourceViewController.dismissViewControllerAnimated(false, completion: nil)
        }
    }

}
