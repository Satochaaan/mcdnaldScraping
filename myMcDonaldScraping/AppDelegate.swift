//
//  AppDelegate.swift
//  myMcDonaldScraping
//
//  Created by 川野智史 on 2021/07/29.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // windowをスクリーンサイズに合わせて生成
        window = UIWindow(frame: UIScreen.main.bounds)
        // ViewControllerをインスタンス化、windowのrootに設定する
        window!.rootViewController = ViewController()
        // 表示する
        window!.makeKeyAndVisible()
        
        return true
    }
}

