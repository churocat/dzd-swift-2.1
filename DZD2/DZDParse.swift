//
//  DZDParse.swift
//  ParseStarterProject-Swift
//
//  Created by 竹田 on 2015/9/1.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import Foundation
import Parse

typealias DZDUser = PFUser

extension PFQuery {

    func execute() -> BFTask {
        let localQuery = self.copy() as! PFQuery
        localQuery.fromLocalDatastore()
        return localQuery.findObjectsInBackground().continueWithBlock({ (localTask) -> AnyObject! in
            if let localResult = localTask.result as? [PFObject] {
                if !localResult.isEmpty {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        if Reachability.isConnectedToNetwork() {
                            self.unpinLocalStore(localResult).continueWithSuccessBlock({ (_) -> AnyObject! in
                                self.executeFromNetworkAndSaveToLocalDatastore()
                            })
                        }
                    }
                    return localTask
                } else {
                    return self.executeFromNetworkAndSaveToLocalDatastore()
                }
            } else {
                return BFTask(DZDErrorInfo: "execute but no results")
            }
        })
    }

    func unpinLocalStore(objects: [PFObject]) -> BFTask {
        var tasks: [BFTask] = []
        for object in objects {
            tasks += [object.unpinInBackground()]
        }
        return BFTask(forCompletionOfAllTasks: tasks)
    }

    private func executeFromNetworkAndSaveToLocalDatastore() -> BFTask {
        return self.findObjectsInBackground().continueWithSuccessBlock { (cloudTask) -> AnyObject! in
            let cloudResult = cloudTask.result as! [PFObject]
            return PFObject.pinAllInBackground(cloudResult).continueWithSuccessBlock({ (task) -> BFTask! in
                return cloudTask
            })
        }
    }

    func fetchByObjectId(objectId: String) -> BFTask {
        let localQuery = self.copy() as! PFQuery
        localQuery.fromLocalDatastore()
        return localQuery.getObjectInBackgroundWithId(objectId).continueWithBlock({ (localTask) -> AnyObject! in
            if localTask.error == nil {
                if let localResult = localTask.result as? PFObject {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        if Reachability.isConnectedToNetwork() {
                            self.unpinLocalStore([localResult]).continueWithSuccessBlock({ (_) -> AnyObject! in
                                self.fetchByObjectIdFromNetworkAndSaveToLocalDatastore(objectId)
                            })
                        }
                    }
                    return localTask
                } else {
                    return BFTask(DZDErrorInfo: "fetch but no results")
                }
            } else {
                return self.fetchByObjectIdFromNetworkAndSaveToLocalDatastore(objectId)
            }
        })
    }

    private func fetchByObjectIdFromNetworkAndSaveToLocalDatastore(objectId: String) -> BFTask {
        return self.getObjectInBackgroundWithId(objectId).continueWithSuccessBlock({ (cloudTask) -> AnyObject! in
            let cloudResult = cloudTask.result as! PFObject
            return PFObject.pinAllInBackground([cloudResult]).continueWithSuccessBlock({ (task) -> BFTask! in
                return cloudTask
            })
        })
    }
}



extension BFTask {
    convenience init(DZDErrorInfo: String, DZDErrorCode: Int) {
        self.init(error: NSError(domain: "DZD", code: DZDErrorCode, userInfo: ["error" : DZDErrorInfo]))
    }
    convenience init(DZDErrorInfo: String) {
        self.init(DZDErrorInfo: DZDErrorInfo, DZDErrorCode: 5566)
    }
}



struct DZDError {

    static let DuplicateValue = 137

}



class DZDParseUtility {

    static func checkResultArrayNotZero(result: AnyObject!) -> [PFObject]? {
        if let result = result as? [PFObject] {
            return result.count > 0 ? result : nil
        } else {
            return nil
        }
    }

}



class DZDDataCenter {
  
    // NOT support one user in multiple game
    // return the first game's id
    static func fetchGameId(user: DZDUser) -> BFTask! {
        let query = PFQuery(className: DZDDB.TabelGame)
        query.whereKey(DZDDB.Game.Members, equalTo: user)
        query.includeKey(DZDDB.Game.Members)

        return query.execute().continueWithSuccessBlock { (task) -> BFTask! in
            if let games = DZDParseUtility.checkResultArrayNotZero(task.result) {
                return BFTask(result: games[0].objectId)
            } else {
                return BFTask(DZDErrorInfo: "result is an empty array or not an array")
            }
        }
    }
    
    // NOT support one user in multiple game
    // return the first game's id
    static func fetchGameOtherMembers(gameId: String, user: DZDUser) -> BFTask! {
        let query = PFQuery(className: DZDDB.TabelGame)
        return query.fetchByObjectId(gameId).continueWithSuccessBlock( { (task) -> BFTask! in
            if let game = task.result as? PFObject {
                let members = game[DZDDB.Game.Members] as! [DZDUser]
                var tasks: [BFTask] = []
                for member in members {
                    if member.objectId != user.objectId {
                        let q = PFUser.query()!
                        tasks += [q.fetchByObjectId(member.objectId!)]
                    }
                }
                return BFTask(forCompletionOfAllTasksWithResults: tasks)
            } else {
                return BFTask(DZDErrorInfo: "didn't found a game with id: \(gameId)")
            }
        })
    }
    
    static func fetchProfileImageData(user: DZDUser) -> BFTask! {
        let userImageFile = user[DZDDB.User.Image] as! PFFile
        return userImageFile.getDataInBackground()
    }

    static func saveWeight(weight: Double, date: NSDate) -> BFTask {
        // check is any data saved in the same day
        let query = PFQuery(className: DZDDB.TabelWeight)
        query.whereKey(DZDDB.Weight.Date, greaterThan: date.unixtimeZeroAM)
        query.whereKey(DZDDB.Weight.Date, lessThan: date.unixtimeZeroAM + 86400)
        query.fromLocalDatastore()
        return query.countObjectsInBackground().continueWithSuccessBlock({ (task) -> AnyObject! in
            let count = task.result as! Int
            if count > 0 {
                return BFTask(DZDErrorInfo: "duplicated data in same day", DZDErrorCode: DZDError.DuplicateValue)
            } else {
                return self.saveWeightForced(weight, date: date)
            }
        })
    }
    
    enum CalorieType {
        case Exercise, Food
    }

    static func saveCalorie(type: CalorieType, value: Double, date: NSDate, name: String, image: UIImage) -> BFTask {
        var className = ""
        switch type {
        case .Exercise: className = DZDDB.TableExerciseCalorie
        case .Food: className = DZDDB.TableFoodCalorie
        }
  
        let object = PFObject(className: className)
        object[DZDDB.Calorie.User] = PFUser.currentUser()
        object[DZDDB.Calorie.Calorie] = value
        object[DZDDB.Calorie.Date] = date.unixtime
        object[DZDDB.Calorie.Name] = name
        
        if let imageData = UIImagePNGRepresentation(image) {
            object[DZDDB.Calorie.Image] = PFFile(name:"image.png", data:imageData)
        }
        
        return object.pinInBackground().continueWithSuccessBlock { (_) -> AnyObject! in
            // NO!!!!!!!!!!!!!!!!!!!!!!!!
            // cannot use: object.saveEventually()
            // Unable to saveEventually a PFObject with a relation to a new, unsaved PFFile.
            // PFFiles still don't support saveEventually
            object.saveInBackground()
            return BFTask(result: true)
        }
    }
    
    static func saveWeightForced(weight: Double, date: NSDate) -> BFTask {
        let object = PFObject(className: DZDDB.TabelWeight)
        object[DZDDB.Weight.User] = PFUser.currentUser()
        object[DZDDB.Weight.Weight] = weight
        object[DZDDB.Weight.Date] = date.unixtime
        return object.pinInBackground().continueWithSuccessBlock { (_) -> AnyObject! in
            object.saveEventually()
            return BFTask(result: true)
        }
    }

    static func deleteWeight(date: NSDate) -> BFTask {
        let query = PFQuery(className: DZDDB.TabelWeight)
        query.whereKey(DZDDB.Weight.Date, greaterThan: date.unixtimeZeroAM)
        query.whereKey(DZDDB.Weight.Date, lessThan: date.unixtimeZeroAM + 86400)
        return query.execute().continueWithSuccessBlock { (task) -> AnyObject! in
            if let objects = DZDParseUtility.checkResultArrayNotZero(task.result) {
                var tasks: [BFTask] = []
                for object in objects {
                    object.deleteEventually()
                    tasks += [object.unpinInBackground()]
                }
                return BFTask(forCompletionOfAllTasks: tasks)
            } else {
                // empty to delete
                return BFTask(result: false)
            }
        }
    }

    /// get current user's weights
    static func getWeights() -> BFTask {
        let query = PFQuery(className: DZDDB.TabelWeight)
        query.whereKey(DZDDB.Weight.User, equalTo: PFUser.currentUser()!)
        query.orderByAscending(DZDDB.Weight.Date)
        return query.execute().continueWithSuccessBlock({ (task) -> AnyObject! in
            if let objects = task.result as? [PFObject] {
                let weights = self.getPerDayWeights(objects)
                return BFTask(result: weights)
            } else {
                return BFTask(DZDErrorInfo: "wrong result")
            }
        })
    }
    
    static func getWeights(user: DZDUser) -> BFTask {
        let query = PFQuery(className: DZDDB.TabelWeight)
        query.whereKey(DZDDB.Weight.User, equalTo: user)
        query.orderByAscending(DZDDB.Weight.Date)
        return query.execute().continueWithSuccessBlock({ (task) -> AnyObject! in
            if let objects = task.result as? [PFObject] {
                let weights = self.getPerDayWeights(objects)
                return BFTask(result: weights)
            } else {
                return BFTask(DZDErrorInfo: "wrong result")
            }
        })
    }
    
    static func getAllWeights() -> BFTask {
        let query = PFQuery(className: DZDDB.TabelWeight)
        query.orderByAscending(DZDDB.Weight.Date)
        return query.execute().continueWithSuccessBlock({ (task) -> AnyObject! in
            if let objects = task.result as? [PFObject] {
                let groupedObjects = groupByUser(objects)
                var groupedWeights: [DZDUser: [DZDDataObject]] = [:]
                for (user, objects) in groupedObjects {
                    groupedWeights[user] = self.getPerDayWeights(objects)
                }
                return BFTask(result: groupedWeights)
            } else {
                return BFTask(DZDErrorInfo: "wrong result")
            }
        })
    }
    
    
    
    static func getAllCalories(carolieType: DZDDB.CalorieType) -> BFTask {
        let className = carolieType.rawValue
        let query = PFQuery(className: className)
        query.orderByAscending(DZDDB.Calorie.Date)
        return query.execute().continueWithSuccessBlock({ (task) -> AnyObject! in
            if let objects = task.result as? [PFObject] {
                let groupedObjects = groupByUser(objects)
                var groupedCarolies: [DZDUser: [DZDDataObject]] = [:]
                for (user, objects) in groupedObjects {
                    groupedCarolies[user] = self.getPerDaySumCalories(objects)
                }
                return BFTask(result: groupedCarolies)
            } else {
                return BFTask(DZDErrorInfo: "wrong result")
            }
        })
    }
    
    static func groupByUser(objects: [PFObject]) -> [DZDUser: [PFObject]] {
        var groupedObjects: [DZDUser: [PFObject]] = [:]
        for object in objects {
            if let user = object[DZDDB.Weight.User] as? DZDUser {
                if groupedObjects[user] == nil {
                    groupedObjects[user] = []
                }
                groupedObjects[user]?.append(object)
            }
        }
        return groupedObjects
    }

    static func getPerDaySumCalories(objects: [PFObject]) -> [DZDDataObject] {
        var calories: [DZDDataObject] = []
        
        var sumArray: [Int:Double] = [:]
        for object in objects {
            let ts = object[DZDDB.Calorie.Date] as! Int
            let nsDate = NSDate(timeIntervalSince1970: NSTimeInterval(ts))
            let tsZeroAM = nsDate.unixtimeZeroAM
            let value = object[DZDDB.Calorie.Calorie] as! Double
            
            if let _ = sumArray[tsZeroAM] {
                sumArray[tsZeroAM] = sumArray[tsZeroAM]! + value
            } else {
                sumArray[tsZeroAM] = value
            }
        }
        
        for (ts, sum) in sumArray {
            calories += [DZDDataObject(value: sum, date: ts)]
        }
        
        return calories
    }
    
    
    static func getPerDayWeights(objects: [PFObject]) -> [DZDDataObject] {
        var weights: [DZDDataObject] = []

        // there might be more than one weight in a day
        // make only one weight in a day
        var existed: [String:PFObject] = [:]
        for object in objects {
            let date = object[DZDDB.Weight.Date] as! Int

            if let oldObject = existed[date.dateString] {
                existed[date.dateString] = object

                // if old object is more recent than this object
                if let thisObjectUpdatedAt = object.updatedAt, oldObjectUpdatedAt = oldObject.updatedAt {
                    if thisObjectUpdatedAt.compare(oldObjectUpdatedAt) == .OrderedAscending {
                        existed[date.dateString] = oldObject
                    }
                }
            } else {
                existed[date.dateString] = object
            }
        }

        // make weights array
        for (_, object) in existed {
            let weight = object[DZDDB.Weight.Weight] as! Double
            let date = object[DZDDB.Weight.Date] as! Int
            weights += [DZDDataObject(value: weight, date: date)]
        }

        // sort by date
        weights.sortInPlace() { return $0.date < $1.date }

        return weights
    }

}