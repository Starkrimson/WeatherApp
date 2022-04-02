import Foundation
import ComposableArchitecture

struct ForecastState: Equatable {
    @FileStorage(directory: .documentDirectory, fileName: "followingList.json")
    var followingList: [CityViewModel]?
    
    var forecast: [Int: OneCall]?
    var loadingCityIDSet: Set<Int> = []
    
    static func == (lhs: ForecastState, rhs: ForecastState) -> Bool {
        (lhs.followingList, lhs.forecast, lhs.loadingCityIDSet) == (rhs.followingList, rhs.forecast, rhs.loadingCityIDSet)
    }
}

enum ForecastAction: Equatable {
    case follow(city: CityViewModel)
    case unfollowCity(indexSet: IndexSet)
    case moveCity(indexSet: IndexSet, toIndex: Int)
    
    case loadCityForecast(city: CityViewModel)
    case loadCityForecastDone(cityID: Int, result: Result<OneCall, AppError>)
}

struct ForecastEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var weatherClient: WeatherClient
}

let forecastReducer = Reducer<ForecastState, ForecastAction, ForecastEnvironment> {
    state, action, environment in
    
    switch action {
    case .follow(let city):
        var list = state.followingList ?? []
        list.append(city)
        state.followingList = list
        return .none
    case .unfollowCity(let indexSet):
        var list = state.followingList ?? []
        list.remove(atOffsets: indexSet)
        state.followingList = list
        return .none
    case let .moveCity(indexSet, toIndex):
        var list = state.followingList ?? []
        list.move(fromOffsets: indexSet, toOffset: toIndex)
        state.followingList = list
        return .none
    case .loadCityForecast(city: let city):
        state.loadingCityIDSet.insert(city.id)
        return environment.weatherClient
            .oneCall(city.coord.lat, city.coord.lon)
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
