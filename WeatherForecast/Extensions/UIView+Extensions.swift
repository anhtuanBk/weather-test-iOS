//
//  UIView+Extensions.swift
//  WeatherForecast


import UIKit

extension UIStackView {
  func addArrangedSubviews(_ subviews: [UIView]) {
    subviews.forEach(addArrangedSubview)
  }

  func addArrangedSubviews(_ subviews: UIView...) {
    subviews.forEach(addArrangedSubview)
  }
}

extension UIView {
  func addSubviews(_ subviews: UIView...) {
    subviews.forEach(addSubview)
  }
}
