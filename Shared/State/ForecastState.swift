import Foundation
import ComposableArchitecture

struct ForecastState: Equatable {
    var followingList: [CityViewModel]?
}

enum ForecastAction: Equatable {
    case follow(city: CityViewModel)
    case unfollowCity(indexSet: IndexSet)
    case moveCity(indexSet: IndexSet, toIndex: Int)
}

struct ForecastEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
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
    }
}
