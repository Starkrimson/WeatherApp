import Foundation
import Combine

class Store: ObservableObject {

    @Published var appState = AppState()

    func dispatch(_ action: AppAction) {
        #if DEBUG
        print("[ACTION]: \(action)")
        #endif
        let result = Store.reduce(state: appState, action: action)
        appState = result.0
        if let command = result.1 {
            #if DEBUG
            print("[COMMAND]: \(command)")
            #endif
            command.execute(in: self)
        }
    }

    static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand?

        switch action {
        case .find:
            appCommand = FindAppCommand()
        case .findCityDone(result: let result):
            switch result {
            case .success(let list):
                appState.search.list = list
            case .failure(let error):
                dump(error)
            }
            
        case .loadCityForecast(city: let city):
            appCommand = OneCallCommand(city: city)
        case .loadCityForecastDone(result: let result):
            switch result {
            case .success(let (id, value)):
                if appState.cityList.forecast == nil {
                    appState.cityList.forecast = [id: value]
                } else {
                    appState.cityList.forecast?[id] = value
                }
            case .failure(let error):
                dump(error)
            }
        }

        return (appState, appCommand)
    }
}
