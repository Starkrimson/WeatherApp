import Foundation
import ComposableArchitecture

struct ForecastReducer: ReducerProtocol {
    
    struct State: Equatable {
        var followingList: [CityViewModel] = []
        
        var forecast: [Int: OneCall]?
        var loadingCityIDSet: Set<Int> = []
        
        var errorDescription: String?
    }
    
    enum Action: Equatable {
        case fetchFollowingCity
        case fetchFollowingCityDone(TaskResult<[CityViewModel]>)
        
        case follow(city: CityViewModel)
        case followDone(TaskResult<CityViewModel>)
        case unfollowCity(indexSet: IndexSet)
        case unfollowCityDone(TaskResult<CityViewModel>)
        case moveCity(indexSet: IndexSet, toIndex: Int)
        
        case loadCityForecast(city: CityViewModel)
        case loadCityForecastDone(cityID: Int, result: TaskResult<OneCall>)
    }
    
    @Dependency(\.weatherClient) var weatherClient
    @Dependency(\.followingClient) var followingClient
        
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchFollowingCity:
                return .task {
                    await .fetchFollowingCityDone(TaskResult<[CityViewModel]> {
                        try await followingClient.fetch()
                    })
                }
            case .fetchFollowingCityDone(let result):
                switch result {
                case .success(let list):
                    state.followingList = list
                case .failure(let error):
                    customDump(error)
                }
                return .none
            case .follow(let city):
                return .task { [lastIndex = state.followingList.last?.index ?? 0] in
                    await .followDone(TaskResult<CityViewModel> {
                        var city = city
                        city.index = Int(lastIndex + 1)
                        return try followingClient.save(city)
                    })
                }
            case .followDone(let result):
                if case let .success(city) = result {
                    state.followingList.append(city)
                }
                return .none
            case .unfollowCity(let indexSet):
                return .task { [city = state.followingList[indexSet.first!]] in
                    await .unfollowCityDone(TaskResult<CityViewModel> {
                        try followingClient.delete(city)
                    })
                }
            case .unfollowCityDone(let result):
                if case let .success(city) = result {
                    state.followingList.removeAll(where: { $0.id == city.id })
                }
                return .none
            case let .moveCity(indexSet, toIndex):
                return .task { [followingList = state.followingList] in
                    await .fetchFollowingCityDone(TaskResult<[CityViewModel]> {
                        try followingClient.move(followingList, indexSet, toIndex)
                    })
                }
            case .loadCityForecast(city: let city):
                guard !state.loadingCityIDSet.contains(city.id) else { return .none }
                state.loadingCityIDSet.insert(city.id)
                state.errorDescription = nil
                return .task {
                    await .loadCityForecastDone(cityID: city.id, result: TaskResult<OneCall> {
                        try await weatherClient.oneCall(city.coord.lat, city.coord.lon)
                    })
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
                    state.errorDescription = error.localizedDescription
                }
                return .none
            }
        }
    }
}
