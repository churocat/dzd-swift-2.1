//
//  DatePickerViewController.swift
//  DZD2
//
//  Created by 竹田 on 2015/10/20.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var pickedDate = NSDate()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.date = pickedDate
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        UIView.animateWithDuration(0.5,  animations: {
            }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.performSegueWithIdentifier(DZDSegue.DatePickerSegueUnwind, sender: self)
    }

}
