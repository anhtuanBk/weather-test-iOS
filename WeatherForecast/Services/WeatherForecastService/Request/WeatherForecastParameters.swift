//
//  WeatherForecastParameters.swift
//  WeatherForecast


enum DegreeUnit: String {
  case `default`
  case metric
  case imperial
}

struct WeatherForecastParameters {
  let city: String
  let numberOfDays: Int
  let appID: String
  let degreeUnit: DegreeUnit
}
