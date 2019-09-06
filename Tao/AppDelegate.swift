//
//  AppDelegate.swift
//  Tao
//
//  Created by hc on 2019/8/28.
//  Copyright © 2019 hc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // 当前界面支持的方向（默认情况下只能横屏显示）
    var interfaceOrientations: UIInterfaceOrientationMask = .portrait {
        didSet {
            guard interfaceOrientations != oldValue else { return }
            setInterfaceOrientations(interfaceOrientations)
        }
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate {
    private func setInterfaceOrientations(_ interfaceOrientations: UIInterfaceOrientationMask) {
        
        //强制设置成竖屏
        if interfaceOrientations == .portrait {
            // 该行代码 避免当前设备方向是portrait而不强制旋转的情况
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue,
                                      forKey: "orientation")
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue,
                                      forKey: "orientation")
        }
            //强制设置成横屏
        else if !interfaceOrientations.contains(.portrait) {
            if UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight {
                return
            } else {
                // 该行代码 避免当前设备方向是landscapeLeft而不强制旋转的情况
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue,
                                          forKey: "orientation")
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            }
        }

    }
}
