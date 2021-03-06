//
//  MainViewModel.swift
//  WeatherForecast


import RxSwift
import RxCocoa

struct WeatherForecastUIModel: Equatable {
    let date: String
    let temperature: String
    let pressure: String
    let humidity: String
    let description: String
    let icon: String
}

private extension DegreeUnit {
    var display: String {
        switch self {
        case .default: return "K"
        case .metric: return "°C"
        case .imperial: return "°F"
        }
    }
}

private struct UIModelConverter {
    private let dateFormatter: DateFormatter
    private let unit: DegreeUnit
    
    init(dateFormat: String, locale: String, unit: DegreeUnit) {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: locale)
        self.dateFormatter = formatter
        self.unit = unit
    }
    
    func convert(from model: WeatherForecastResponse.WeatherDay) -> WeatherForecastUIModel {
        let date = "Date: \(dateFormatter.string(from: model.date))"
        
        let averageTemperature = Int(model.temperature.minimum + model.temperature.maximum) / 2
        let temperature = "Average temperature: \(averageTemperature)\(unit.display)"
        
        let pressure = "Pressure: \(model.pressure)"
        let humidity = "Humidity: \(model.humidity)%"
        let description = "Description: \(model.weather.description)"
        let icon = "\(Endpoint.iconCurrent)/\(model.weather.icon)@2x.png"
        return .init(date: date, temperature: temperature, pressure: pressure, humidity: humidity, description: description, icon: icon)
    }
}

struct MainViewModelInput {
    let queryStringStream: AnyObserver<String>
}

struct MainViewModelOutput {
    let itemsStream: Observable<[WeatherForecastUIModel]>
    let errorStream: Observable<String>
    let isLoadingStream: Observable<Bool>
}

protocol MainViewModel {
    var input: MainViewModelInput { get }
    var output: MainViewModelOutput { get }
}

final class DefaultMainViewModel: MainViewModel {
    enum Constants {
        static let queryStringDebounceInterval = RxTimeInterval.milliseconds(500)
        static let locale = "en_US_POSIX"
        static let dateFormat = "E, dd MMM yyyy"
    }
    
    let input: MainViewModelInput
    let output: MainViewModelOutput
    
    private let service: WeatherForecastService
    private let minQueryLength: Int
    private let numberOfDays: Int
    private let unit: DegreeUnit
    private let scheduler: SchedulerType
    
    private let disposeBag = DisposeBag()
    
    init(service: WeatherForecastService,
         minQueryLength: Int = 3,
         numberOfDays: Int = 7,
         unit: DegreeUnit = .metric,
         scheduler: SchedulerType = MainScheduler.instance) {
        self.service = service
        self.minQueryLength = minQueryLength
        self.numberOfDays = numberOfDays
        self.unit = unit
        self.scheduler = scheduler
        
        let queryStringPublish = PublishSubject<String>()
        input = MainViewModelInput(queryStringStream: queryStringPublish.asObserver())
        
        let itemsRelay = BehaviorRelay<[WeatherForecastUIModel]>(value: [])
        let errorPublish = PublishSubject<String>()
        let isLoadingPublish = PublishSubject<Bool>()
        output = MainViewModelOutput(
            itemsStream: itemsRelay.asObservable(),
            errorStream: errorPublish,
            isLoadingStream: isLoadingPublish
        )
        
        let uiModelConverter = UIModelConverter(dateFormat: Constants.dateFormat, locale: Constants.locale, unit: unit)
        queryStringPublish.distinctUntilChanged()
            .filter { $0.count >= minQueryLength }
            .debounce(Constants.queryStringDebounceInterval, scheduler: scheduler)
            .flatMapLatest { city -> Single<[WeatherForecastResponse.WeatherDay]> in
                let stream = service.fetchDailyForecast(city: city, numberOfDays: numberOfDays, degreeUnit: unit)
                return stream
                    .map { $0.items }
                    .do(onSuccess: { _ in
                        isLoadingPublish.onNext(false)
                    }, onError: { error in
                        NSLog("MainViewModel. Fail to fetch daily forecast. Error: \(error)")
                        isLoadingPublish.onNext(false)
                        if let error = error as? WeatherForecastError {
                            errorPublish.onNext(error.message)
                        } else {
                            errorPublish.onNext("Something went wrong. Please try searching with another city!")
                        }
                    }, onSubscribe: {
                        isLoadingPublish.onNext(true)
                    })
                        .catchErrorJustReturn([])
                        }
            .subscribe(onNext: { items in
                let uiModels = items.map(uiModelConverter.convert)
                itemsRelay.accept(uiModels)
            })
            .disposed(by: disposeBag)
    }
}
