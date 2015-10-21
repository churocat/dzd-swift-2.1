//
//  AddItemViewController.swift
//  ParseStarterProject-Swift
//
//  Created by 竹田 on 2015/9/9.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker: UIImagePickerController!

    var pickedDate = NSDate() {
        didSet {
            dateButton.setTitle("\(pickedDate.date)  \(pickedDate.dayOfWeek)", forState: .Normal)
        }
    }

    @IBAction func takePhoto() {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.image = image
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func done() {
        let value = (valueTextField.text! as NSString).doubleValue
        recordWeight(value, date: pickedDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateButton.setTitle("\(pickedDate.date) \(pickedDate.dayOfWeek)", forState: .Normal)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func recordWeight(weight: Double, date: NSDate) {
        if weight == 0 {
            DZDUtility.showAlert("Input your weight!", controller: self)
            return
        }
        
        DZDDataCenter.saveWeight(weight, date: date).continueWithBlock { (task) -> AnyObject! in
            dispatch_async(dispatch_get_main_queue()) {
                if task.error == nil {
                    DZDUtility.showAlert("Save successfully!", title: "Yeah!", controller: self) {
                        DZDDataCenter.getWeights().continueWithSuccessBlock({ (task) -> AnyObject! in
                            return nil
                        })
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                } else {
                    if task.error.code == DZDError.DuplicateValue {
                        DZDUtility.showConfirm("當天已有資料，是否覆蓋呢？", controller: self) {
                            DZDDataCenter.deleteWeight(date).continueWithBlock({ (task) -> AnyObject! in
                                DZDDataCenter.saveWeightForced(weight, date: date)
                                self.dismissViewControllerAnimated(true, completion: nil)
                                return nil
                            })
                        }
                    } else {
                        DZDUtility.showAlert("Save failed :'(", controller: self)
                    }
                }
            }
            return nil
        }
    }
    
    @IBAction func chooseWhatToRecord(sender: UIBarButtonItem) {
        let recordType = sender.title!
        titleLabel.text = "紀錄" + recordType
//        switch (recordType) {
//        default:
//            break
//        }
    }

    // dismiss the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue){
        
    }

    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier {
            if id == DZDSegue.DatePickerSegueUnwind {
                let unwindSegue = DatePickerSegueUnwind(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                })
                return unwindSegue
            }
        }
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)!
    }

}
