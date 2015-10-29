//
//  ProfileViewController.swift
//  DZD2
//
//  Created by 竹田 on 2015/10/28.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var drawableUser: DZDDrawableUser?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: ProfileImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let drawableUser = drawableUser {
            let color = drawableUser.color ?? UIColor.blackColor()
            profileImageView.lineColor = color
            profileImageView.image = drawableUser.profileImage

            nameLabel.text = drawableUser.user.username
            nameLabel.textColor = color
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImageView.refineSize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
