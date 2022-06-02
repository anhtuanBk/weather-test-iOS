//
//  Coordinator.swift
//  WeatherForecast


import RxSwift

protocol Coordinator: Identifiable {}

class BaseCoordinator: Coordinator {
  private var childCoordinators = [String: Coordinator]()

  /// Start presenting a screen
  func start() {
    fatalError("Should be implemented by sub class.")
  }

  func addChildCoordinator(_ coordinator: Coordinator) {
    childCoordinators[type(of: coordinator).idenfitier] = coordinator
  }

  func removeChildCoordinator(_ coordinator: Coordinator) {
    childCoordinators[type(of: coordinator).idenfitier] = nil
  }
}
