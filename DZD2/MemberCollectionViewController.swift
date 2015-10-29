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

protocol MemberCollectionViewControllerDelegate {
    func MemberCollectionViewControllerDidSelect(user: DZDDrawableUser)
}

class MemberCollectionViewController: UICollectionViewController {

    var delegate: MemberCollectionViewControllerDelegate?

    // MARK: - Outlet

    @IBOutlet var memberCollectionView: UICollectionView!
    
    // MARK: - Responding to View Events

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        adjustOffsetX()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        if DZDData.allDrawableMembers.isEmpty {
            refreshMembers().continueWithSuccessBlock({ (_) -> AnyObject! in
                dispatch_async(dispatch_get_main_queue()) {
                    self.memberCollectionView.reloadData()
                }
                return nil
            })
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // FIX-IT: where should I put it Q_Q?
        adjustOffsetX()
        
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DZDData.allDrawableMembers.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemberCollectionViewCell
        
        let profileImage = DZDData.allDrawableMembers[indexPath.row].profileImage
        cell.profileImageView.image = profileImage
        cell.profileImageView.lineColor = profileImage.isZeroSize() ? UIColor.clearColor() : DZDData.allDrawableMembers[indexPath.row].color
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let user = DZDData.allDrawableMembers[indexPath.row]
        delegate?.MemberCollectionViewControllerDidSelect(user)
    }

    // MARK: Private function

    private func adjustOffsetX() {
        memberCollectionView.setContentOffset(CGPoint(x: DZDData.memberCollectionViewoffsetX, y: 0), animated: false)
    }

    private func refreshMembers() -> BFTask {
        let currentUser = DZDUser.currentUser()!
        return DZDDataCenter.fetchGameId(currentUser).continueWithSuccessBlock({ (task) -> BFTask! in
            let gameId = task.result as! String
            return DZDDataCenter.fetchGameOtherMembers(gameId, user: currentUser)
        }).continueWithSuccessBlock({ (task) -> AnyObject! in
            let members = task.result as!  [DZDUser]

            let currentDrawableUser = DZDDrawableUser(user: DZDUser.currentUser()!)
            let otherDrawableMembers = members.map { return DZDDrawableUser(user: $0) }
            let allDrawableMembers = [currentDrawableUser] + otherDrawableMembers

            DZDData.allDrawableMembers = allDrawableMembers

            let tasks: [BFTask] = allDrawableMembers.map{ $0.fetchProfileImage() }
            return BFTask(forCompletionOfAllTasks: tasks)
        })
    }

}
