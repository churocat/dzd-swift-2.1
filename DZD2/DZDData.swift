//
//  DZDData.swift
//  DZD2
//
//  Created by 竹田 on 2015/10/2.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import Foundation
import UIKit

class DZDData {
    static var allDrawableMembers: [DZDDrawableUser] = []
    static var memberCollectionViewoffsetX: CGFloat = 0
    
    static func getColor(user: DZDUser) -> UIColor {
        for drawableMember in DZDData.allDrawableMembers {
            if drawableMember.user == user {
                return drawableMember.color
            }
        }
        return UIColor.blackColor()
    }
}
