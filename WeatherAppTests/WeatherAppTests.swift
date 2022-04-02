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
        }
        scheduler.advance(by: 0.3)
        store.receive(.citiesResponse(.failure(.badURL))) {
            $0.status = .failed("无效 URL")
        }
    }
    
    func testFollowAndUnfollowCity() {
        let store = TestStore(
            initialState: .init(),
            reducer: forecastReducer,
            environment: ForecastEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                weatherClient: .failing
            )
        )
        
        store.send(.follow(city: CityViewModel(city: mockCities[0]))) {
            $0.followingList = [CityViewModel(city: mockCities[0])]
        }
        
        store.send(.unfollowCity(indexSet: IndexSet(integer: 0))) {
            $0.followingList = []
        }
    }
    
    func testMoveCity() {
        let store = TestStore(
            initialState: .init(followingList: mockCities.map(CityViewModel.init)),
            reducer: forecastReducer,
            environment: ForecastEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                weatherClient: .failing
            )
        )
        store.send(.moveCity(indexSet: IndexSet(integer: 1), toIndex: 0)) { state in
            var list = mockCities.map(CityViewModel.init)
            list.move(fromOffsets: IndexSet(integer: 1), toOffset: 0)
            state.followingList = list
        }
    }
    
    func testLoadCityForecast() {
        let store = TestStore(
            initialState: .init(),
            reducer: forecastReducer,
            environment: ForecastEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                weatherClient: .failing
            )
        )
        
        store.environment.weatherClient.oneCall = { _, _ in Effect(value: mockOneCall) }
        store.send(.loadCityForecast(city: CityViewModel(city: mockCities[0]))) {
            $0.loadingCityIDSet = [mockCities[0].id]
        }
        scheduler.advance(by: 0.3)
        store.receive(.loadCityForecastDone(cityID: mockCities[0].id, result: .success(mockOneCall))) {
            $0.loadingCityIDSet = []
            $0.forecast = [mockCities[0].id: mockOneCall]
        }
    }
    
    func testLoadCityForecastFailure() {
        let store = TestStore(
            initialState: .init(),
            reducer: forecastReducer,
            environment: ForecastEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                weatherClient: .failing
            )
        )
        store.environment.weatherClient.oneCall = { _,_ in Effect(error: .badURL) }
        store.send(.loadCityForecast(city: CityViewModel(city: mockCities[0]))) { state in
            state.loadingCityIDSet = [mockCities[0].id]
        }
        scheduler.advance(by: 0.3)
        store.receive(.loadCityForecastDone(cityID: mockCities[0].id, result: .failure(.badURL))) {
            $0.loadingCityIDSet = []
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

private let mockOneCall: OneCall = {
    guard let url = Bundle.main.url(forResource: "OneCall", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let model = try? JSONDecoder().decode(OneCall.self, from: data)
        else { fatalError() }
    return model
}()
