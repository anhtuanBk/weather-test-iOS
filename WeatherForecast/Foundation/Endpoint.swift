//
//  Endpoint.swift
//  WeatherForecast
//


//

enum Endpoint {
  #if TEST
  static let current = "http://localhost:6789"
    static let iconCurrent = "http://localhost:6789"
  #else
  static let current = "https://api.openweathermap.org/data/2.5"
    static let iconCurrent = "https://openweathermap.org/img/wn"
  #endif
}
