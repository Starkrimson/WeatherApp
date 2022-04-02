import Foundation
import ComposableArchitecture

struct SearchState: Equatable {
    
    @BindableState var searchQuery = ""
    var list: [Find.City] = []
    var status: Status = .normal
    
    enum Status: Equatable {
        case normal, loading, noResult, failed(String)
    }
}

enum SearchAction: Equatable, BindableAction {
    case binding(BindingAction<SearchState>)
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
    case .binding:
        return .none
    case .search(let query):
        struct SearchCityId: Hashable { }
        
        state.status = .loading
        return environment.weatherClient
            .searchCity(query)
            .receive(on: environment.mainQueue)
            .catchToEffect(SearchAction.citiesResponse)
            .cancellable(id: SearchCityId(), cancelInFlight: true)
        
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
    .binding()
    .debug()
