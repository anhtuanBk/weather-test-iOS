//
//  Configurable.swift
//  WeatherForecast


import Foundation

protocol Configurable {}

extension NSObject: Configurable {}

extension Configurable where Self: AnyObject {
  func configure(_ transform: (Self) -> Void) -> Self {
    transform(self)
    return self
  }
}
