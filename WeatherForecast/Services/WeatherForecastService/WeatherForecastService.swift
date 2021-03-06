//
//  WeatherForecastService.swift
//  WeatherForecast


import Moya
import RxSwift

enum WeatherForecastAPIService: TargetType, MoyaCacheable {
    case dailyForecast(WeatherForecastParameters)
    
    var baseURL: URL {
        return URL(string: Endpoint.current)!
    }
    
    var path: String {
        switch self {
        case .dailyForecast: return "/forecast/daily"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .dailyForecast: return .get
        }
    }
    
    var sampleData: Data {
        fatalError("Not in use")
    }
    
    var task: Task {
        switch self {
        case .dailyForecast(let params):
            let parameters: [String: String] = [
                "q": params.city,
                "cnt": String(params.numberOfDays),
                "appid": params.appID,
                "units": params.degreeUnit.rawValue
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var cachePolicy: MoyaCacheablePolicy {
        return .returnCacheDataElseLoad
    }
}

// MARK: - Service
protocol WeatherForecastService {
    func fetchDailyForecast(city: String, numberOfDays: Int, degreeUnit: DegreeUnit) -> Single<WeatherForecastResponse>
}

final class DefaultWeatherForecastService: WeatherForecastService {
    private let provider = MoyaProvider<WeatherForecastAPIService>(plugins: [NetworkLoggerPlugin(), MoyaCacheablePlugin()])
    private let appID: String
    
    init(appID: String) {
        self.appID = appID
        let MEMORY_CAPACITY = 4 * 1024 * 1024
        let DISK_CAPACITY =  20 * 1024 * 1024

        let cache = URLCache(memoryCapacity: MEMORY_CAPACITY, diskCapacity: DISK_CAPACITY, diskPath: nil)
        URLCache.shared = cache
    }
    
    func fetchDailyForecast(city: String, numberOfDays: Int, degreeUnit: DegreeUnit) -> Single<WeatherForecastResponse> {
        let parameters = WeatherForecastParameters(
            city: city,
            numberOfDays: numberOfDays,
            appID: appID,
            degreeUnit: degreeUnit
        )
        return provider.rx.request(.dailyForecast(parameters))
            .map { response in
                do {
                    let successResponse = try response.filterSuccessfulStatusCodes()
                    do {
                        return try successResponse.map(WeatherForecastResponse.self)
                    }
                    catch {
                        throw error
                    }
                } catch {
                    throw try response.map(WeatherForecastError.self)
                }
            }
    }
}
