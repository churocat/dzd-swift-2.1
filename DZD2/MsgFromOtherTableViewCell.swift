//
//  MsgFromOtherTableViewCell.swift
//  DZD2
//
//  Created by roylo on 2015/10/18.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import UIKit

class MsgFromOtherTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
