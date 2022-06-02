//
//  MoyaCacheable.swift
//  WeatherForecast
//
//

import Foundation

protocol MoyaCacheable {
  typealias MoyaCacheablePolicy = URLRequest.CachePolicy
  var cachePolicy: MoyaCacheablePolicy { get }
}
