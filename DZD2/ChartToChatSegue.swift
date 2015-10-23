
//  ChartToChatSegue.swift
//  ParseStarterProject-Swift
//
//  Created by 竹田 on 2015/9/22.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit

class ChartToChatSegue: UIStoryboardSegue {

    override func perform() {
        let chartVC = self.sourceViewController as! ChartViewController
        let chatVC = self.destinationViewController

        // get widths and heights
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height

        let offset = chartVC.memberContainerView.bounds.size.height
        
        // specify the initial position of the destination view
        chatVC.view.frame = CGRectMake(0.0, screenHeight - offset, screenWidth, screenHeight)

        // access the app's key window and insert the destination view above the current (source) one
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(chatVC.view, aboveSubview: chartVC.view)

        // Animate the transition.
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            chartVC.view.frame = CGRectOffset(chartVC.view.frame, 0.0, -screenHeight + offset)
            chatVC.view.frame = CGRectOffset(chatVC.view.frame, 0.0, -screenHeight + offset)

            }) { (Finished) -> Void in
                chartVC.presentViewController(chatVC, animated: false, completion: nil)
        }
    }

}
