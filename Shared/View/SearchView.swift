import SwiftUI
import Kingfisher

struct SearchView: View {
    @EnvironmentObject var store: Store
    
    var search: AppState.Search {
        store.appState.search
    }
    
    var searchBinding: Binding<AppState.Search> {
        $store.appState.search
    }
    
    var followingList: [CityViewModel] {
        store.appState.cityList.followingList ?? []
    }
    
    @ViewBuilder
    var searchSection: some View {
        switch (search.state, search.keyword.count) {
        case (_, 0): EmptyView()
        case (.loading, _): Text("搜索中...")
        case (.noResult, _): Text("无结果")
        case (.failed(let tips), _): Text(tips)
        case (.normal, _) where search.list.count > 0:
            Section(header: Text("搜索结果").headerText()) {
                ForEach(search.list) { city in
                    NavigationLink(destination: CityView(city: CityViewModel(city: city))) {
                        CityRow(city: city)
                    }
                }
            }
        default: EmptyView()
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                searchSection
                Section(header: Text("关注").headerText()) {
                    ForEach(followingList) { city in
                        NavigationLink(destination: CityView(city: city)) {
                            HStack {
                                Text(city.description)
                                    .font(.headline)
                                Spacer()
                                KFImage(city.country.flagURL)
                            }
                        }
                    }
                        .onDelete { (indexSet: IndexSet) in
                            store.dispatch(.unfollowCity(indexSet: indexSet))
                        }
                        .onMove { set, i in
                            store.dispatch(.moveCity(indexSet: set, toIndex: i))
                        }
                }
            }
                .listStyle(.sidebar)
                .searchable(text: searchBinding.keyword,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "搜索城市")
                .onSubmit(of: .search) {
                    store.dispatch(.find)
                }
                #if os(iOS) && !targetEnvironment(macCatalyst)
                .toolbar {
                    ToolbarItem {
                        EditButton()
                    }
                }
                #endif
                .navigationBarTitleDisplayMode(.large)
                .navigationTitle("天气")
    
            Image(systemName: "cloud.sun").font(.largeTitle)
        }
            .navigationViewStyle(.columns)
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

private extension Text {
    func headerText() -> some View {
        font(.footnote)
            .foregroundColor(Color(.systemGray2))
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
        let store = Store()
        store.appState.search.list = Self.debugList()
        
        return SearchView().environmentObject(store)
    }
}
