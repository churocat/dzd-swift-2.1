//
//  ChatViewController.swift
//  DZD2
//
//  Created by 竹田 on 2015/9/30.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import UIKit
import Bolts

class ChatViewController: UIViewController, UITableViewDataSource {
    
    var memberCollectionVC: MemberCollectionViewController?
    
    var messages: [DZDMessage] = []
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageEditField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.retrieveHistoricalMessages("3nxMB3PFqj")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = segue.identifier ?? ""
        switch identifier {
        case DZDSegue.ShowMemberCollectionView:
            if let vc = segue.destinationViewController as? MemberCollectionViewController {
                self.memberCollectionVC = vc
            }
        case DZDSegue.ChatToChartSegue:
            let offset = memberCollectionVC?.memberCollectionView.contentOffset.x
            DZDData.memberCollectionViewoffsetX = offset!
        default:
            break
        }
    }
    
    func retrieveHistoricalMessages(gameId: String) {
        self.messageTableView.dataSource = self
        DZDDataCenter.fetchSinchMessage(gameId).continueWithSuccessBlock { (task) -> BFTask! in
            self.messages = task.result as! [DZDMessage]
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.messageTableView.reloadData()
                self.scrollTableToBottom()
            })
            return nil
        }
    }
    
    // MARK: table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let msg = messages[indexPath.row]
       
        if msg.senderName != "roylo" {
            let cell = tableView.dequeueReusableCellWithIdentifier("msgFromOther", forIndexPath: indexPath) as! MsgFromOtherTableViewCell
            
            cell.nameLabel.text = msg.senderName
            cell.messageLabel.text = msg.message
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("msgFromMe", forIndexPath: indexPath) as! MsgFromMeTableViewCell
            cell.messageLabel.text = msg.message
            return cell
        }
    }
   
    // MARK: message handler
    
    @IBAction func sendMessage(sender: AnyObject) {
        if self.messageEditField.text != nil {
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.sendTextMessage(self.messageEditField.text!, recipients: ["sasanala"])
        }
    }
    
    // MARK: private method
    func scrollTableToBottom() {
        let rowNum = self.messageTableView.numberOfRowsInSection(0)
        if rowNum > 0 {
            self.messageTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: rowNum-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
    }
}
