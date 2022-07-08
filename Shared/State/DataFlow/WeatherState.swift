import Foundation
import ComposableArchitecture

struct WeatherState: Equatable {
    var search: SearchState = .init()
    var forecast: ForecastState = .init()
}

enum WeatherAction: Equatable {
    case search(SearchAction)
    case forecast(ForecastAction)
}

struct WeatherEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var weatherClient: WeatherClient
    var followingClient: FollowingClient
}

let weatherReducer = Reducer<WeatherState, WeatherAction, WeatherEnvironment>.combine(
    searchReducer.pullback(
        state: \.search,
        action: /WeatherAction.search,
        environment: {
            SearchEnvironment(mainQueue: $0.mainQueue, weatherClient: $0.weatherClient)
        }
    ),
    forecastReducer.pullback(
        state: \.forecast,
        action: /WeatherAction.forecast,
        environment: {
            ForecastEnvironment(
                mainQueue: $0.mainQueue,
                weatherClient: $0.weatherClient,
                followingClient: $0.followingClient
            )
        }
    ),
    Reducer<WeatherState, WeatherAction, WeatherEnvironment> { state, action, environment in
        switch action {
        // MARK: - binding. 选择了 city，触发刷新天气预报。
        case .search(.binding(let binding)):
            if binding.keyPath == \.$selectedCity, let city = state.search.selectedCity {
                let forecast = state.forecast.forecast?[city.id]
                if forecast == nil || (Date().timeIntervalSince1970 - Double(forecast!.current.dt)) > 600 {
                    return .init(value: .forecast(.loadCityForecast(city: city)))
                }
            }
            return .none

        default: return .none
        }
    }
)

