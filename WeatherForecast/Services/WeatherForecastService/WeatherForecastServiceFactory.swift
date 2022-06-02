//
//  WeatherForecastServiceFactory.swift
//  WeatherForecast


enum WeatherForecastSeviceFactory {
  static func makeService(appID: String) -> WeatherForecastService {
    return DefaultWeatherForecastService(appID: appID)
  }
}
