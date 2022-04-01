import Foundation
import ComposableArchitecture

struct SearchState: Equatable {
    
    var searchQuery = ""
    var list: [Find.City] = []
    var status: Status = .normal
    
    enum Status: Equatable {
        case normal, loading, noResult, failed(String)
    }
}

enum SearchAction: Equatable {
    case search(query: String)
    case citiesResponse(Result<[Find.City], AppError>)
    case clearSearch
}

struct SearchEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var weatherClient: WeatherClient
}

let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment> {
    state, action, environment in

    switch action {
    case .search(let query):
        state.status = .loading
        return environment.weatherClient
            .searchCity(query)
            .catchToEffect(SearchAction.citiesResponse)
    case .citiesResponse(let result):
        switch result {
        case .success(let list):
            state.status = list.count > 0 ? .normal : .noResult
            state.list = list
        case .failure(let error):
            state.status = .failed(error.localizedDescription)
            state.list = []
        }
        return .none
    case .clearSearch:
        state.searchQuery = ""
        state.status = .normal
        state.list = []
        return .none
    }
}
