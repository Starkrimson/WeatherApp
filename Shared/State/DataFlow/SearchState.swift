import Foundation
import ComposableArchitecture

struct SearchReducer: Reducer {
    
    struct State: Equatable {
        
        @BindingState var searchQuery = ""
        var list: [Find.City] = []
        var status: Status = .normal
        
        @BindingState var selectedCity: CityViewModel?
        
        enum Status: Equatable {
            case normal, loading, noResult, failed(String)
        }
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case search(query: String)
        case citiesResponse(TaskResult<[Find.City]>)
    }
    
    @Dependency(\.weatherClient) var weatherClient
        
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$searchQuery):
                if state.searchQuery.count == 0 {
                    state.status = .normal
                    state.list = []
                }
                return .none

            case .binding:
                return .none
                
            case .search(let query):
                struct SearchCityId: Hashable { }
                
                guard state.status != .loading else { return .none }
                state.status = .loading
                return .run { send in
                    await send(.citiesResponse(TaskResult<[Find.City]> {
                        try await weatherClient.searchCity(query)
                    }))
                }
                
            case .citiesResponse(.success(let list)):
                state.status = list.count > 0 ? .normal : .noResult
                state.list = list
                return .none
                
            case .citiesResponse(.failure(let error)):
                state.status = .failed(error.localizedDescription)
                state.list = []
                return .none
            }
        }
    }
}
