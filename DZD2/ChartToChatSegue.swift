//
//  ChartToChatSegue.swift
//  ParseStarterProject-Swift
//
//  Created by 竹田 on 2015/9/22.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit

class ChartToChatSegue: UIStoryboardSegue {

    override func perform() {
        // assign the source and destination views to local variables
        let chartVCView = self.sourceViewController.view as UIView!
        let chatVCView = self.destinationViewController.view as UIView!

        // get widths and heights
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
    
        let chartVC = self.sourceViewController as! ChartViewController
        let offset = chartVC.memberContainerView.bounds.size.height

        // specify the initial position of the destination view
        chatVCView.frame = CGRectMake(0.0, screenHeight - offset, screenWidth, screenHeight)

        // access the app's key window and insert the destination view above the current (source) one
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(chatVCView, aboveSubview: chartVCView)

        // Animate the transition.
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            chartVCView.frame = CGRectOffset(chartVCView.frame, 0.0, -screenHeight + offset)
            chatVCView.frame = CGRectOffset(chatVCView.frame, 0.0, -screenHeight + offset)

            }) { (Finished) -> Void in
                self.sourceViewController.presentViewController(self.destinationViewController ,
                    animated: false,
                    completion: nil)
        }
    }

}
