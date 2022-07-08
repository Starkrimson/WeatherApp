import Foundation
import ComposableArchitecture

struct ForecastState: Equatable {
    var followingList: [CityViewModel] = []
    
    var forecast: [Int: OneCall]?
    var loadingCityIDSet: Set<Int> = []
}

enum ForecastAction: Equatable {
    case fetchFollowingCity
    case fetchFollowingCityDone(Result<[CityViewModel], AppError>)
    
    case follow(city: CityViewModel)
    case followDone(Result<CityViewModel, Never>)
    case unfollowCity(indexSet: IndexSet)
    case unfollowCityDone(Result<CityViewModel, Never>)
    case moveCity(indexSet: IndexSet, toIndex: Int)
    
    case loadCityForecast(city: CityViewModel)
    case loadCityForecastDone(cityID: Int, result: Result<OneCall, AppError>)
}

struct ForecastEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var weatherClient: WeatherClient
    var followingClient: FollowingClient
}

let forecastReducer = Reducer<ForecastState, ForecastAction, ForecastEnvironment> {
    state, action, environment in
    
    switch action {
    case .fetchFollowingCity:
        return environment.followingClient
            .fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(ForecastAction.fetchFollowingCityDone)
    case .fetchFollowingCityDone(let result):
        switch result {
        case .success(let list):
            state.followingList = list
        case .failure(let error):
            customDump(error)
        }
        return .none
    case .follow(var city):
        city.index = Int((state.followingList.last?.index ?? 0) + 1)
        return environment.followingClient
            .save(city)
            .receive(on: environment.mainQueue)
            .catchToEffect(ForecastAction.followDone)
    case .followDone(let result):
        if case let .success(city) = result {
            state.followingList.append(city)
        }
        return .none
    case .unfollowCity(let indexSet):
        return environment.followingClient
            .delete(state.followingList[indexSet.first!])
            .receive(on: environment.mainQueue)
            .catchToEffect(ForecastAction.unfollowCityDone)
    case .unfollowCityDone(let result):
        if case let .success(city) = result {
            state.followingList.removeAll(where: { $0.id == city.id })
        }
        return .none
    case let .moveCity(indexSet, toIndex):
        return environment.followingClient
            .move(state.followingList, indexSet, toIndex)
            .receive(on: environment.mainQueue)
            .catchToEffect(ForecastAction.fetchFollowingCityDone)
    case .loadCityForecast(city: let city):
        guard !state.loadingCityIDSet.contains(city.id) else { return .none }
        state.loadingCityIDSet.insert(city.id)
        return environment.weatherClient
            .oneCall(city.coord.lat, city.coord.lon)
            .receive(on: environment.mainQueue)
            .catchToEffect { result in
                ForecastAction.loadCityForecastDone(cityID: city.id, result: result)
            }
    case .loadCityForecastDone(cityID: let cityID, result: let result):
        state.loadingCityIDSet.remove(cityID)
        switch result {
        case .success(let value):
            var forecast = state.forecast ?? [:]
            forecast[cityID] = value
            state.forecast = forecast
        case .failure(let error):
            dump(error)
        }
        return .none
    }
}
    .debug()
