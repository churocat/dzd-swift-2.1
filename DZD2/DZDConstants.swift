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

}