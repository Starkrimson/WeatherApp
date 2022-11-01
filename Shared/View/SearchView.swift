import SwiftUI
import ComposableArchitecture
import Kingfisher

struct SearchView: View {
    let store: Store<WeatherState, WeatherAction>
    
    var searchStore: Store<SearchState, SearchAction> {
        store.scope(
            state: \.search,
            action: WeatherAction.search
        )
    }
    
    var forecastStore: Store<ForecastState, ForecastAction> {
        store.scope(
            state: \.forecast,
            action: WeatherAction.forecast
        )
    }
    
    var body: some View {
        WithViewStore(searchStore) { searchViewStore in
            NavigationSplitView {
                List(selection: searchViewStore.binding(\.$selectedCity)) {
                    SearchSection(viewStore: searchViewStore)
                    FollowingSection(store: forecastStore)
                }
                .listStyle(.sidebar)
                .navigationTitle("天气")
                .navigationBarTitleDisplayMode(.large)
                .searchable(
                    text: searchViewStore.binding(\.$searchQuery),
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "搜索城市"
                )
                .onSubmit(of: .search) {
                    searchViewStore.send(.search(query: searchViewStore.searchQuery))
                }
                #if os(iOS) && !targetEnvironment(macCatalyst)
                .toolbar {
                    ToolbarItem {
                        EditButton()
                    }
                }
                #endif
            } detail: {
                VStack {
                    IfLetStore(
                        store.scope(state: \.search.selectedCity)
                    ) { letStore in
                        WithViewStore(letStore) { letViewStore in
                            CityView(store: forecastStore, city: letViewStore.state)
                        }
                    } else: {
                        Image(systemName: "cloud.sun").font(.largeTitle)
                    }
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static func debugList() -> [Find.City] {
        guard let url = Bundle.main.url(forResource: "Cities", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let list = try? JSONDecoder().decode([Find.City].self, from: data)
            else { return [] }
        return list
    }
    
    static var previews: some View {
        let store = Store(
            initialState: WeatherState(search: .init(searchQuery: "preview",
                                                     list: debugList()),
                                       forecast: .init()),
            reducer: weatherReducer,
            environment: WeatherEnvironment(
                mainQueue: .main,
                weatherClient: WeatherClient(
                    searchCity: { _ in
                        Effect(value: [
                            debugList()[0]
                        ])
                    },
                    oneCall: { _,_ in Effect(error: .badURL) }
                ),
                followingClient: .live,
                date: Date.init
            )
        )
        return SearchView(store: store)
    }
}

private extension Text {
    func headerText() -> some View {
        font(.footnote)
            .foregroundColor(Color(.systemGray2))
    }
}

struct SearchSection: View {
    let viewStore: ViewStore<SearchState, SearchAction>
    
    var body: some View {
        switch (viewStore.status, viewStore.searchQuery.count) {
        case (_, 0): EmptyView()
        case (.loading, _): Text("搜索中...")
        case (.noResult, _): Text("无结果")
        case (.failed(let tips), _): Text(tips)
        case (.normal, _) where viewStore.list.count > 0:
            Section(header: Text("搜索结果").headerText()) {
                ForEach(viewStore.list) { city in
                    NavigationLink(value: CityViewModel(city: city)) {
                        CityRow(city: city)
                    }
                }
            }
        default: EmptyView()
        }
    }
}

struct FollowingSection: View {
    let store: Store<ForecastState, ForecastAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Section(header: Text("关注").headerText()) {
                ForEach(viewStore.followingList) { city in
                    NavigationLink(value: city) {
                        HStack {
                            Text(city.description)
                                .font(.headline)
                            Spacer()
                            KFImage(city.country.flagURL)
                        }
                    }
                }
                .onDelete { (indexSet: IndexSet) in
                    viewStore.send(.unfollowCity(indexSet: indexSet))
                }
                .onMove { set, i in
                    viewStore.send(.moveCity(indexSet: set, toIndex: i))
                }
            }
            .onAppear {
                viewStore.send(.fetchFollowingCity)
            }
        }
    }
}

struct CityRow: View {
    let city: Find.City
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(city.name + ", " + city.sys.country)
                        .font(.headline)
                    KFImage(city.sys.country.flagURL)
                        .frame(width: 20, height: 20)
                }
                Text("\(city.coord.lon.toString), \(city.coord.lat.toString)")
                    .font(.footnote)
                    .foregroundColor(.gray)
        
            }
                .layoutPriority(1)
            Spacer()
            ForEach(city.weather) { condition in
                KFImage(condition.icon.weatherIconURL)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            Text(city.main.temp.k2c)
        }
            .padding(.vertical, 10)
            .lineLimit(1)
    }
}
