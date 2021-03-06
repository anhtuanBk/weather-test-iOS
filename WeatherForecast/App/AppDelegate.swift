//
//  AppDelegate.swift
//  WeatherForecast


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  private var appCoordinator: AppCoordinator!

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow()
    appCoordinator = AppCoordinator(window: window, appID: "60c6fbeb4b93ac653c492ba806fc346d")
    appCoordinator.start()

    return true
  }
}

