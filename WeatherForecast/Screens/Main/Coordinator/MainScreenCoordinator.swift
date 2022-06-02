//
//  MainScreenCoordinator.swift
//  WeatherForecast


import RxSwift

final class MainScreenCoordinator: BaseCoordinator {
  private let window: UIWindow
  private let appID: String

  init(window: UIWindow, appID: String) {
    self.window = window
    self.appID = appID
  }

  override func start() {
    let service = WeatherForecastSeviceFactory.makeService(appID: appID)
    let viewModel = DefaultMainViewModel(service: service)
    let viewController = MainViewController(viewModel: viewModel)
    window.rootViewController = UINavigationController(rootViewController: viewController)
    window.makeKeyAndVisible()
  }
}
