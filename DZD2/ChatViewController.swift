//
//  ChatViewController.swift
//  DZD2
//
//  Created by 竹田 on 2015/9/30.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    var memberCollectionVC: MemberCollectionViewController?

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = segue.identifier ?? ""
        switch identifier {
        case DZDSegue.ShowMemberCollectionView:
            if let vc = segue.destinationViewController as? MemberCollectionViewController {
                self.memberCollectionVC = vc
            }
        case DZDSegue.ChatToChartSegue:
            let offset = memberCollectionVC?.memberCollectionView.contentOffset.x
            MemberCollectionViewController.offsetX = offset!
        default:
            break
        }
    }
}
