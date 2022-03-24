import Foundation
import Combine

class Store: ObservableObject {

    @Published var appState = AppState()
    
    private var disposeBag = Set<AnyCancellable>()
    
    init() {
        setupObservers()
    }
    
    func setupObservers() {
        appState.search.$keyword
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { value in
                if value.count == 0 {
                    self.dispatch(.clearFind)
                }
            }
            .store(in: &disposeBag)
    }

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
            appState.search.state = .loading
            appState.search.list = []
            appCommand = FindAppCommand()
        case .clearFind:
            appState.search.state = .normal
            appState.search.list = []
        case .findCityDone(result: let result):
            switch result {
            case .success(let list):
                appState.search.list = list
                appState.search.state = list.count > 0 ? .normal : .noResult
            case .failure(let error):
                dump(error)
                appState.search.state = .failed(error.localizedDescription)
            }
            
        case .follow(let city):
            var list = appState.cityList.followingList ?? []
            list.append(city)
            appState.cityList.followingList = list
        case .unfollowCity(let indexSet):
            appState.cityList.followingList?.remove(atOffsets: indexSet)
        case let .moveCity(indexSet, toIndex):
            appState.cityList.followingList?.move(fromOffsets: indexSet, toOffset: toIndex)
            
        case .loadCityForecast(city: let city):
            appCommand = OneCallCommand(city: city)
        case .loadCityForecastDone(result: let result):
            switch result {
            case .success(let (id, value)):
                var forecast = appState.cityList.forecast ?? [:]
                forecast[id] = value
                appState.cityList.forecast = forecast
            case .failure(let error):
                dump(error)
            }
        }

        return (appState, appCommand)
    }
}
