import SwiftUI
import ComposableArchitecture
import Kingfisher

struct SearchView: View {
    let store: StoreOf<WeatherReducer>
    
    var searchStore: StoreOf<SearchReducer> {
        store.scope(
            state: \.search,
            action: WeatherReducer.Action.search
        )
    }
    
    var forecastStore: StoreOf<ForecastReducer> {
        store.scope(
            state: \.forecast,
            action: WeatherReducer.Action.forecast
        )
    }
    
    var searchFieldPlacement: SearchFieldPlacement {
        #if os(iOS)
        return .navigationBarDrawer(displayMode: .always)
        #else
        return .sidebar
        #endif
    }
    
    var body: some View {
        WithViewStore(searchStore) { $0 } content: { searchViewStore in
            NavigationSplitView {
                List(selection: searchViewStore.$selectedCity) {
                    SearchSection(viewStore: searchViewStore)
                    FollowingSection(store: forecastStore)
                }
                .listStyle(.sidebar)
                .navigationTitle("天气")
                .searchable(
                    text: searchViewStore.$searchQuery,
                    placement: searchFieldPlacement,
                    prompt: "搜索城市"
                )
                .onSubmit(of: .search) {
                    searchViewStore.send(.search(query: searchViewStore.searchQuery))
                }
                #if os(iOS)
                .toolbar {
                    ToolbarItem {
                        EditButton()
                    }
                }
                #endif
            } detail: {
                WithViewStore(searchStore) {
                    $0.selectedCity
                } content: { viewStore in
                    if let state = viewStore.state {
                        CityView(store: forecastStore, city: state)
                    } else {
                        Image(systemName: "cloud.sun").font(.largeTitle)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(
            store: .init(
                initialState: .init(),
                reducer: { WeatherReducer() }
            )
        )
    }
}
#endif

struct SearchSection: View {
    let viewStore: ViewStore<SearchReducer.State, SearchReducer.Action>
    
    var body: some View {
        switch (viewStore.status, viewStore.searchQuery.count) {
        case (_, 0): EmptyView()
        case (.loading, _): Text("搜索中...")
        case (.noResult, _): Text("无结果")
        case (.failed(let tips), _):
            Label(tips, systemImage: "exclamationmark.circle")
        case (.normal, _) where viewStore.list.count > 0:
            Section("搜索结果") {
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
    let store: StoreOf<ForecastReducer>
    
    var body: some View {
        WithViewStore(store) { $0 } content: { viewStore in
            Section("关注") {
                ForEach(viewStore.followingList) { city in
                    NavigationLink(value: city) {
                        HStack {
                            Text(city.description)
                                .font(.headline)
                            Spacer()
                            KFImage(city.country.flagURL)
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                viewStore.send(.unfollowCity(city: city))
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .onDelete { (indexSet: IndexSet) in
                    viewStore.send(.unfollowCityAt(indexSet: indexSet))
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
