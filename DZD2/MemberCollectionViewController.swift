//
//  MemberCollectionViewController.swift
//  DZD2
//
//  Created by 竹田 on 2015/9/30.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import UIKit
import Bolts

private let reuseIdentifier = "memberCell"

class MemberCollectionViewController: UICollectionViewController {

    static var offsetX: CGFloat = 0

    // MARK: - Outlet

    @IBOutlet var memberCollectionView: UICollectionView!
    
    // MARK: - Property
    let currentDrawableUser = DZDDrawableUser(user: DZDUser.currentUser()!)
    var otherDrawableMembers: [DZDDrawableUser] = [] {
        didSet {
            let tasks: [BFTask] = allDrawableMembers.map{ $0.fetchProfileImage() }
            BFTask(forCompletionOfAllTasks: tasks).continueWithSuccessBlock({ (task) -> AnyObject! in
                dispatch_async(dispatch_get_main_queue()) {
                    print(self.otherDrawableMembers)
                    self.memberCollectionView.reloadData()
                }
                return nil
            })
        }
    }
    var allDrawableMembers: [DZDDrawableUser] { return [currentDrawableUser] + otherDrawableMembers }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        adjustOffsetX()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        refreshMembers()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // FIX-IT: where should I put it Q_Q?
        adjustOffsetX()
        
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allDrawableMembers.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemberCollectionViewCell
        
        let profileImage = allDrawableMembers[indexPath.row].profileImage
        cell.profileImageView.image = profileImage
        cell.profileImageView.lineColor = profileImage.isZeroSize() ? UIColor.clearColor() : allDrawableMembers[indexPath.row].color
        
        return cell
    }

    // MARK: Private function

    private func adjustOffsetX() {
        memberCollectionView.setContentOffset(CGPoint(x: MemberCollectionViewController.offsetX, y: 0), animated: false)
    }

    private func refreshMembers() {
        DZDDataCenter.fetchGameId(currentDrawableUser.user).continueWithSuccessBlock({ (task) -> BFTask! in
            let gameId = task.result as! String
            return DZDDataCenter.fetchGameOtherMembers(gameId, user: self.currentDrawableUser.user)
        }).continueWithSuccessBlock({ (task) -> AnyObject! in
            let members = task.result as!  [DZDUser]
            self.otherDrawableMembers = members.map { return DZDDrawableUser(user: $0) }
            return nil
        })
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
