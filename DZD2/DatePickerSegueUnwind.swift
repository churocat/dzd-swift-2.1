//
//  DatePickerSegueUnwind.swift
//  DZD2
//
//  Created by 竹田 on 2015/10/20.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import UIKit

class DatePickerSegueUnwind: UIStoryboardSegue {

    override func perform() {
        let datePickerVC = self.sourceViewController as! DatePickerViewController
        let addItemVC = self.destinationViewController as! AddItemViewController
        
        // set the picked date
        addItemVC.pickedDate = datePickerVC.datePicker.date
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            datePickerVC.datePicker.alpha = 0.0
            
            }) { (finished) -> Void in
                datePickerVC.dismissViewControllerAnimated(false, completion: nil)
        }
    }

}
