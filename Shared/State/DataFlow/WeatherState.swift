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
    )
)

