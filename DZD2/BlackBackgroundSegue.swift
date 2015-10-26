//
//  BlackBackgroundSegue.swift
//  DZD2
//
//  Created by 竹田 on 2015/10/23.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import UIKit

class BlackBackgroundSegue: UIStoryboardSegue {
    
    override func perform() {
        let srcVC = self.sourceViewController
        let dstVC = self.destinationViewController
        
        let bgImage = srcVC.view.toUIImage()?.applyDarkEffect()
        let bgImageView = UIImageView(image: bgImage)
        dstVC.view.insertSubview(bgImageView, atIndex: 0)        

        dstVC.modalTransitionStyle = .CrossDissolve
        srcVC.presentViewController(dstVC, animated: true, completion: nil)
    }

}
