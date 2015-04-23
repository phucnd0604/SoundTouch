//
//  AppDelegate.swift
//  SoundTouch
//
//  Created by phuc on 4/23/15.
//  Copyright (c) 2015 phuc nguyen. All rights reserved.
//

import UIKit

let soundPlayer = SoundPlayer()
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var tabbarController: UITabBarController!

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    // create tabbar
    tabbarController = UITabBarController()
    tabbarController.tabBar.translucent = false
    // create animal tab
    var animalVC = BaseViewController(nibName: "BaseViewController", bundle: nil)
    var nav1 = UINavigationController(rootViewController: animalVC)
    nav1.navigationBar.translucent = false
    nav1.tabBarItem.image = UIImage(named: "tb_animal.png")
    nav1.tabBarItem.title = "Aninal"
    // create instrusment tab
    var instrumentVC = BaseViewController(nibName: "BaseViewController", bundle: nil)
    var nav2 = UINavigationController(rootViewController: instrumentVC)
    nav2.navigationBar.translucent = false
    nav2.tabBarItem.image = UIImage(named: "tb_instrusment.png")
    nav2.tabBarItem.title = "Instrusment"
    // create vechicle tab
    var vehicleVC = BaseViewController(nibName: "BaseViewController", bundle: nil)
    var nav3 = UINavigationController(rootViewController: vehicleVC)
    nav3.navigationBar.translucent = false
    nav3.tabBarItem.image = UIImage(named: "tb_vehicle.png")
    nav3.tabBarItem.title = "Vehicle"
    tabbarController.viewControllers = [nav1,nav2,nav3]
    
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window?.rootViewController = tabbarController
    window?.makeKeyAndVisible()
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


}

