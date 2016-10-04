//
//  AppDelegate.swift
//  Found
//
//  Created by Austin Louden on 3/27/16.
//  Copyright © 2016 Austin Louden. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let googleAPIKey = "AIzaSyCw294O_uUPzk4486kS76dM6IwT7IMqfy0"
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey(googleAPIKey)
        GMSPlacesClient.provideAPIKey(googleAPIKey)
        
        // create the view controllers held in the tab bar
        let mapViewController = MapViewController()
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: nil, selectedImage: nil)
        mapViewController.tabBarItem.setTitleTextAttributes(NSAttributedString.tabBarTitleAttributes(), for: UIControlState())
        
        let navigationController = UINavigationController(rootViewController: ProfileViewController())
        navigationController.navigationBar.titleTextAttributes = NSAttributedString.navigationTitleAttributes()
        navigationController.tabBarItem = UITabBarItem(title: "Saved", image: nil, selectedImage: nil)
        navigationController.tabBarItem.setTitleTextAttributes(NSAttributedString.tabBarTitleAttributes(), for: UIControlState())
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [mapViewController, navigationController]
        
        let rootViewController = tabBarController
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

