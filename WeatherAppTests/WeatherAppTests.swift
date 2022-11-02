import XCTest
import ComposableArchitecture
@testable import WeatherApp

@MainActor
class WeatherAppTests: XCTestCase {

    func testSearchAndClear() async throws {
        let store = TestStore(
            initialState: .init(),
            reducer: SearchReducer()
        )
        store.dependencies.weatherClient.searchCity = { _ in testCities }
        
        _ = await store.send(.search(query: "Beijing")) {
            $0.status = .loading
        }
        
        await store.receive(.citiesResponse(.success(testCities))) {
            $0.status = .normal
            $0.list = testCities
        }
                
        _ = await store.send(.binding(.set(\.$searchQuery, ""))) {
            $0.searchQuery = ""
            $0.status = .normal
            $0.list = []
        }
    }
    
    func testSearchFailure() async {
        let store = TestStore(
            initialState: .init(),
            reducer: SearchReducer()
        )
        
        let error = NSError(domain: "error", code: -999)
        
        store.dependencies.weatherClient.searchCity = { _ in throw error }
        _ = await store.send(.search(query: "S")) {
            $0.status = .loading
        }
        
        await store.receive(.citiesResponse(.failure(error))) {
            $0.status = .failed(error.localizedDescription)
        }
    }
    
    func testFollowingCity() async {
        let store = TestStore(
            initialState: .init(),
            reducer: ForecastReducer()
        )

        let mockList = testCities.map(CityViewModel.init)
        store.dependencies.followingClient.fetch = { mockList }
        _ = await store.send(.fetchFollowingCity)
        await store.receive(.fetchFollowingCityDone(.success(mockList))) {
            $0.followingList = mockList
        }

        let city = mockList[0]
        store.dependencies.followingClient.delete = { _ in city }
        _ = await store.send(.unfollowCity(indexSet: IndexSet(integer: 0)))
        await store.receive(.unfollowCityDone(.success(city))) {
            $0.followingList.remove(at: 0)
        }

        store.dependencies.followingClient.save = { _ in city }
        _ = await store.send(.follow(city: city))
        await store.receive(.followDone(.success(city))) { state in
            state.followingList.append(city)
        }

        store.dependencies.followingClient.move = { _,_,_ in
            var moved = mockList
            moved.move(fromOffsets: IndexSet(integer: 1), toOffset: 0)
            return moved
        }
        _ = await store.send(.moveCity(indexSet: IndexSet(integer: 1), toIndex: 0))
        var moved = mockList
        moved.move(fromOffsets: IndexSet(integer: 1), toOffset: 0)
        await store.receive(.fetchFollowingCityDone(.success(moved))) {
            $0.followingList = moved
        }
    }
    
    func testLoadCityForecast() async {
        let store = TestStore(
            initialState: .init(),
            reducer: ForecastReducer()
        )

        store.dependencies.weatherClient.oneCall = { _, _ in testOneCall }
        _ = await store.send(.loadCityForecast(city: CityViewModel(city: testCities[0]))) {
            $0.loadingCityIDSet = [testCities[0].id]
        }
        
        await store.receive(.loadCityForecastDone(cityID: testCities[0].id, result: .success(testOneCall))) {
            $0.loadingCityIDSet = []
            var forecast = $0.forecast ?? [:]
            forecast[testCities[0].id] = testOneCall
            $0.forecast = forecast
        }
    }
    
    func testLoadCityForecastFailure() async {
        let store = TestStore(
            initialState: .init(),
            reducer: ForecastReducer()
        )

        let error = NSError(domain: "error", code: -999)

        store.dependencies.weatherClient.oneCall = { _,_ in throw error }
        _ = await store.send(.loadCityForecast(city: CityViewModel(city: testCities[0]))) { state in
            state.loadingCityIDSet = [testCities[0].id]
        }
        
        await store.receive(.loadCityForecastDone(cityID: testCities[0].id, result: .failure(error))) {
            $0.loadingCityIDSet = []
        }
    }
    
    func testSelectCity() async {
        let store = TestStore(
            initialState: .init(),
            reducer: WeatherReducer()
        )

        let city = CityViewModel(city: testCities[0])
        store.dependencies.weatherClient.oneCall = { _, _ in
            testOneCall
        }

        store.dependencies.date = .constant(Date(timeIntervalSince1970: 100))
        
        // 测试选中城市
        _ = await store.send(.search(.binding(.set(\.$selectedCity, city)))) {
            $0.search.selectedCity = city
        }

        // 触发加载城市天气预报
        await store.receive(.forecast(.loadCityForecast(city: city))) {
            $0.forecast.loadingCityIDSet = [city.id]
        }

        // 成功加载
        await store.receive(.forecast(.loadCityForecastDone(cityID: city.id, result: .success(testOneCall)))) {
            $0.forecast.loadingCityIDSet = []
            $0.forecast.forecast = [city.id: testOneCall]
        }
        
        // 再次点击城市，两次间隔不超过 600 秒，不触发刷新
        _ = await store.send(.search(.binding(.set(\.$selectedCity, city))))
    }
}
