//
//  AppDelegate.swift
//  NativeDemoApp
//
//  Created by Tanay Mitkari on 26/02/24.
//

import UIKit
import Smartech
import SmartPush
import UserNotifications
import UserNotificationsUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate, SmartechDelegate, UNUserNotificationCenterDelegate {

    var viewC : ViewController?
    var innerVC: InnerPageViewController?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Smartech.sharedInstance().initSDK(with: self, withLaunchOptions: launchOptions)
        SmartPush.sharedInstance().registerForPushNotificationWithDefaultAuthorizationOptions()
        UNUserNotificationCenter.current().delegate = self
        Smartech.sharedInstance().setDebugLevel(.verbose)
        return true
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      SmartPush.sharedInstance().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      SmartPush.sharedInstance().didFailToRegisterForRemoteNotificationsWithError(error)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //MARK:- UNUserNotificationCenterDelegate Methods
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      SmartPush.sharedInstance().willPresentForegroundNotification(notification)
      completionHandler([.alert, .badge, .sound])
    }
        
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            SmartPush.sharedInstance().didReceive(response)
      }
      
      completionHandler()
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        SmartPush.sharedInstance().didReceiveRemoteNotification(userInfo, withCompletionHandler: completionHandler)
    }
    
    func handleDeeplinkAction(withURLString deeplinkURLString: String, andCustomPayload customPayload: [AnyHashable : Any]?) {
        print("Deeplink: \(deeplinkURLString)")
        guard let appURL = NSURL(string: deeplinkURLString) else {
            return
        }
            let urlPath = appURL.path
            print(urlPath)
            let urlHost = appURL.host
            print(urlHost)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if urlHost == "inner"{
        innerVC = mainStoryboard.instantiateViewController(withIdentifier: "InnerPageViewController") as? InnerPageViewController
            let window = UIApplication.shared.keyWindow
            window?.rootViewController = viewC
            window?.makeKeyAndVisible()
            viewC?.present(innerVC!, animated: true)
        } else if urlPath == "/about" {
            // Handle about page
        }
    }
//    func handleDeeplinkAction(withURLString deeplinkURLString: String, andNotificationPayload notificationPayload: [AnyHashable : Any]?) -> Bool {
//        if(deeplinkURLString == "/inner"){
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            
//            let innerPage: InnerPageViewController = mainStoryboard.instantiateViewController(withIdentifier: "InnerPageViewController") as! InnerPageViewController
//            if let window = UIApplication.shared.windows.first {
//                           window.rootViewController = innerPage
//                           window.makeKeyAndVisible()
//                       }
//        }
//        return true
//    }

}

