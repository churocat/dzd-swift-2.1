//
//  DatePickerSegue.swift
//  DZD2
//
//  Created by 竹田 on 2015/10/20.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import UIKit

class DatePickerSegue: UIStoryboardSegue {

    override func perform() {
        let addItemVC = self.sourceViewController as! AddItemViewController
        let datePickerVC = self.destinationViewController as! DatePickerViewController
        
        // set the picked date
        datePickerVC.pickedDate = addItemVC.pickedDate
        
        // add blur background image to the bottom
        let sourceImage = addItemVC.view.toUIImage()
        let blurredImage = sourceImage?.applyBlurWithRadius(5, tintColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.02), saturationDeltaFactor: 1)
        let blurredImageView = UIImageView(image: blurredImage)
        datePickerVC.view.insertSubview(blurredImageView, atIndex: 0)
        
        addItemVC.presentViewController(datePickerVC, animated: false, completion: nil)
    }
    
}
