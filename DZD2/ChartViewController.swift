//
//  ChartViewController.swift
//  DZD2
//
//  Created by 竹田 on 2015/9/30.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var memberContainerView: UIView!

    var memberCollectionVC: MemberCollectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = DZDUser.currentUser()?.username!
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = segue.identifier ?? ""
        switch identifier {
        case DZDSegue.ShowMemberCollectionView:
            if let vc = segue.destinationViewController as? MemberCollectionViewController {
                self.memberCollectionVC = vc
            }
        case DZDSegue.ChartToChatSegue:
            let offset = memberCollectionVC?.memberCollectionView.contentOffset.x
            DZDData.memberCollectionViewoffsetX = offset!
        default:
            break
        }
    }
 
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue){
        
    }
    
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier {
            if id == DZDSegue.ChatToChartSegue {
                let unwindSegue = ChatToChartSegue(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                })
                return unwindSegue
            }
        }
        
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)!
    }
    
}
