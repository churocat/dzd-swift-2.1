//
//  DZDConstants.swift
//  ParseStarterProject-Swift
//
//  Created by 竹田 on 2015/9/1.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import Foundation

struct DZDSegue {

    static let ShowViewChart = "showChartView"
    static let ShowMemberCollectionView = "showMemberCollectionView"
    static let ChartToChatSegue = "chartToChatSegue"
    static let ChatToChartSegue = "chatToChartSegue"
    static let DatePickerSegue = "datePickerSegue"
    static let DatePickerSegueUnwind = "datePickerSegueUnwind"
    static let ChooseChartTypeSegueUnwind = "chooseChartTypeSegueUnwind"
    static let ShowProfileView = "showProfileView"
}


struct DZDDB {

    static let TabelParticipate = "Participate"
    struct Participate {
        static let Username = "username"
        static let GroupId = "groupId"
    }
    
    static let TabelGame = "Game"
    struct Game {
        static let Leader = "leader"
        static let Members = "members"
    }
    
    static let TabelUser = "User"
    struct User {
        static let Image = "image"
    }
    
    static let TabelWeight = "Weight"
    struct Weight {
        static let User = "user"
        static let Weight = "weight"
        static let Date = "date"
    }
    
    static let TableSinchMessage = "SinchMessage"
    struct SinchMessage {
        static let GameId = "gameId"
        static let MessageId = "messageId"
        static let senderName = "senderId"
        static let receiverName = "recipientId"
        static let text = "text"
        static let timestamp = "timestamp"
    }

    static let TableExerciseCalorie = "Exercise"
    static let TableFoodCalorie = "Food"
    struct Calorie {
        static let User = "user"
        static let Calorie = "calorie"
        static let Date = "date"
        static let Name = "name"
        static let Image = "image"
    }
    
    enum CalorieType: String {
        case Food = "Food"
        case Exercise = "Exercise"
    }

    static let TableSinchMessage = "SinchMessage"
    struct SinchMessage {
        static let GameId = "gameId"
        static let MessageId = "messageId"
        static let senderName = "senderId"
        static let receiverName = "recipientId"
        static let text = "text"
        static let timestamp = "timestamp"
    }

}

enum DZDChartType: String {
    case Weight = "Weight"
    case Exercise = "Exercise"
    case Food = "Food"
    
    static let allValues = [Weight, Exercise, Food]
}