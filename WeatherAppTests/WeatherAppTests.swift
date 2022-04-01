//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by allie on 1/4/2022.
//

import XCTest
import ComposableArchitecture
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    let scheduler = DispatchQueue.test

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchAndClear() throws {
        let store = TestStore(
            initialState: .init(),
            reducer: searchReducer,
            environment: SearchEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                weatherClient: .failing)
        )
        
        store.environment.weatherClient.searchCity = { _ in Effect(value: mockCities) }
        store.send(.search(query: "Beijing")) {
            $0.status = .loading
            $0.searchQuery = "Beijing"
        }
        scheduler.advance(by: 0.3)
        store.receive(.citiesResponse(.success(mockCities))) {
            $0.status = .normal
            $0.list = mockCities
        }
        
        store.send(.clearSearch) {
            $0.searchQuery = ""
            $0.status = .normal
            $0.list = []
        }
    }
    
    func testSearchFailure() {
        let store = TestStore(
            initialState: .init(),
            reducer: searchReducer,
            environment: SearchEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                weatherClient: .failing
            )
        )
        store.environment.weatherClient.searchCity = { _ in Effect(error: .badURL) }
        store.send(.search(query: "S")) {
            $0.status = .loading
            $0.searchQuery = "S"
        }
        scheduler.advance(by: 0.3)
        store.receive(.citiesResponse(.failure(.badURL))) {
            $0.status = .failed("无效 URL")
        }
    }
}

private let mockCities: [Find.City] = {
    guard let url = Bundle.main.url(forResource: "Cities", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let list = try? JSONDecoder().decode([Find.City].self, from: data)
        else { return [] }
    return list
}()

