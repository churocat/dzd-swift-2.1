//
//  AddItemViewController.swift
//  ParseStarterProject-Swift
//
//  Created by 竹田 on 2015/9/9.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var takePhotoButton: UIButton!
    
    @IBOutlet weak var dateButton: UIButton!
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var unitLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameLineView: UIView!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var weightBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var foodBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var exerciseBarButtonItem: UIBarButtonItem!
    
    
    var imagePicker: UIImagePickerController!
    
    var recordFunc: ((value: Double, date: NSDate, name: String?, image: UIImage?) -> Void)?
    
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
        let length = 512
        imageView.image = RBResizer.RBSquareImageTo(image, size: CGSize(width: length, height: length))
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func done() {
        let value = (valueTextField.text! as NSString).doubleValue
        let name = nameTextField.text
        recordFunc!(value: value, date: pickedDate, name: name, image: imageView.image)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateButton.setTitle("\(pickedDate.date) \(pickedDate.dayOfWeek)", forState: .Normal)
        
        changeUIToWeight()
        recordFunc = recordWeight
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func recordWeight(weight: Double, date: NSDate, name: String? = nil, image: UIImage? = nil) {
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
    
    func recordCalorie(type: DZDDataCenter.CalorieType, value: Double, date: NSDate, name: String? = nil, var image: UIImage? = nil) {
        let name = name ?? ""
//        let image = image ?? UIImage()
        
        if image == nil {
            image = UIImage()
        }
    
        DZDDataCenter.saveCalorie(type, value: value, date: date, name: name, image: image!).continueWithBlock { (task) -> AnyObject! in
            dispatch_async(dispatch_get_main_queue()) {
                if task.error == nil {
                    DZDUtility.showAlert("Save successfully!", title: "Yeah!", controller: self) {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                } else {
                    DZDUtility.showAlert("Save failed :'(", controller: self)
                }
            }
            
            return nil
        }
    }
    
    func recordFoodCalorie(value: Double, date: NSDate, name: String? = nil, image: UIImage? = nil) {
        recordCalorie(.Food, value: value, date: date, name: name, image: image)
    }
    
    func recordExerciseCalorie(value: Double, date: NSDate, name: String? = nil, image: UIImage? = nil) {
        recordCalorie(.Exercise, value: value, date: date, name: name, image: image)
    }
    
    enum DZDRecordType: String {
        case Weight = "體重"
        case Food = "食物"
        case Exercise = "運動"
    }
    
    @IBAction func chooseWhatToRecord(sender: UIBarButtonItem) {
        let recordType = DZDRecordType(rawValue: sender.title!)!
        
        titleLabel.text = "紀錄" + recordType.rawValue
        barButtonItemColor(recordType)
        
        switch (recordType) {
        case .Weight:
            changeUIToWeight()
            recordFunc = recordWeight
            break
        case .Food:
            changeUIToCal()
            recordFunc = recordFoodCalorie
            break
        case .Exercise:
            changeUIToCal()
            recordFunc = recordExerciseCalorie
            break
        }
    }
    
    func barButtonItemColor(recordType: DZDRecordType) {
        let normalColor = UIColor.lightGrayColor()
        
        weightBarButtonItem.tintColor = normalColor
        exerciseBarButtonItem.tintColor = normalColor
        foodBarButtonItem.tintColor = normalColor
        
        switch (recordType) {
        case .Weight:
            weightBarButtonItem.tintColor = nil
        case .Exercise:
            exerciseBarButtonItem.tintColor = nil
        case .Food:
            foodBarButtonItem.tintColor = nil
        }
    }
    
    func changeUIToWeight() {
        valueLabel.text = "weight"
        unitLabel.text = "kg"

        nameLabel.hidden = true
        nameTextField.hidden = true
        nameLineView.hidden = true
        
        imageView.hidden = true
        takePhotoButton.hidden = true
    }
    
    func changeUIToCal() {
        valueLabel.text = "calorie"
        unitLabel.text = "cal"
        
        nameLabel.hidden = false
        nameTextField.hidden = false
        nameLineView.hidden = false
        
        imageView.hidden = false
        takePhotoButton.hidden = false
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
