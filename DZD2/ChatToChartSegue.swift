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
        let chatVC = self.sourceViewController
        let chartVC = self.destinationViewController as! ChartViewController

        // get heights
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        let offset = chartVC.memberContainerView.bounds.height

        // add background image view
        let bgImage = chartVC.screenshotImage
        let bgImageView = UIImageView(image: bgImage)
        bgImageView.frame.origin.y -= screenHeight - offset
        chatVC.view.addSubview(bgImageView)

        // animate the transition
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            chartVC.view.frame = CGRectOffset(chartVC.view.frame, 0.0, screenHeight - offset)
            chatVC.view.frame = CGRectOffset(chatVC.view.frame, 0.0, screenHeight - offset)
            }) { (Finished) -> Void in
                chatVC.dismissViewControllerAnimated(false, completion: nil)
                bgImageView.removeFromSuperview()
        }
    }

}
