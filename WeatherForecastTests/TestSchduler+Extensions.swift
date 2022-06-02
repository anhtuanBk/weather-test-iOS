//
//  TestSchduler+Extensions.swift
//  WeatherForecastTests


import RxSwift
import RxTest

extension TestScheduler {
  func observe<E>(_ stream: Observable<E>) -> TestableObserver<E> {
    let observer: TestableObserver<E> = createObserver(E.self)
    _ = stream.subscribe(observer)
    return observer
  }
}
