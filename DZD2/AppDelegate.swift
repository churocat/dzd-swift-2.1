//
//  AppDelegate.swift
//  DZD2
//
//  Created by 竹田 on 2015/9/30.
//  Copyright © 2015年 ChuroCat. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SINClientDelegate {

    var window: UIWindow?
    var sinchClient: SINClient?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //--------------------------------------
        // MARK: Parse SDK Integration
        //--------------------------------------
        
        // Enable storing and querying data from Local Datastore.
        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
        // 'enableLocalDataStore' must be called before 'setApplicationId:clientKey:'
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("WtDLpRsFfdX6FbIvJtj6U7oazBDBqBLfQax549z0", clientKey: "n1k6VTolBJUKDPRPTRQZBlwGyTxPm6a4y1KN988d")
        
        PFUser.enableAutomaticUser()
        
        let defaultACL = PFACL()
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.setPublicReadAccess(true)
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)
        
        //--------------------------------------
        // MARK: other steps for launching
        //--------------------------------------
        
        // hide the status bar
        UIApplication.sharedApplication().statusBarHidden = true
        
        // choose initial view controller
        let initialViewIdentity = DZDUser.currentUser()?.objectId == nil ? "LoginView" : "ChartView"
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewControllerWithIdentifier(initialViewIdentity)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Sinch function
    func createSinchClient(userId: String) {
        if self.sinchClient == nil {
            self.sinchClient = Sinch.clientWithApplicationKey("4289ad19-2796-44f4-8c75-973b7639060f", applicationSecret: "Ii5M+R+niU28AsWCLA1kxQ==", environmentHost: "sandbox.sinch.com", userId: userId)
            self.sinchClient?.setSupportMessaging(true)
            self.sinchClient?.start()
            self.sinchClient?.delegate = self
            self.sinchClient?.startListeningOnActiveConnection()
        }
    }
    
    func clientDidStart(client: SINClient) {
        NSLog("client did start")
    }
    
    func clientDidStop(client: SINClient) {
        NSLog("client did stop")
    }

    func clientDidFail(client: SINClient, error: NSError!) {
        NSLog("client did fail", error.description)
        let toast = UIAlertView(title: "Failed to start", message: error.description, delegate: nil, cancelButtonTitle: "OK")
        toast.show()
    }
}

