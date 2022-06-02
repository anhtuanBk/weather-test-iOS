//
//  Identifiable.swift
//  WeatherForecast


import UIKit

protocol Identifiable {
  static var idenfitier: String { get }
}

extension Identifiable {
  static var idenfitier: String {
    return String(reflecting: self)
  }
}

extension UITableViewCell: Identifiable {}
