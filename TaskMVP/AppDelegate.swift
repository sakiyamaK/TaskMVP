//
//  AppDelegate.swift
//  TaskMVP
//
//  Created by sakiyamaK on 2021/03/10.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    //起動を別クラスに任せている
    Router.shared.showRoot(window: UIWindow(frame: UIScreen.main.bounds))
    return true
  }
}

