import Foundation
import ComposableArchitecture

struct WeatherReducer: Reducer {
    
    struct State: Equatable {
        var search: SearchReducer.State = .init()
        var forecast: ForecastReducer.State = .init()
    }
    
    enum Action: Equatable {
        case search(SearchReducer.Action)
        case forecast(ForecastReducer.Action)
    }
    
    @Dependency(\.weatherClient) var weatherClient
    @Dependency(\.date) var date
        
    var body: some ReducerOf<Self> {
        Scope(state: \.search, action: /Action.search) {
            SearchReducer()
        }
        Scope(state: \.forecast, action: /Action.forecast) {
            ForecastReducer()
        }
        Reduce { state, action in
            switch action {
                // MARK: - binding. 选择了 city，触发刷新天气预报。
                case .search(.binding(let binding)):
                    if binding.keyPath == \.$selectedCity, let city = state.search.selectedCity {
                        let forecast = state.forecast.forecast?[city.id]
                        if forecast == nil || (date().timeIntervalSince1970 - Double(forecast!.current.dt)) > 600 {
                            return .run { send in
                                await send(.forecast(.loadCityForecast(city: city)))
                            }
                        }
                    }
                    return .none

                default: return .none
                }
        }
    }
}

