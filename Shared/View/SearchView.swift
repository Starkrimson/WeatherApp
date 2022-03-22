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

    var body: some View {
        NavigationView {
            List(search.list) { city in
                CityRow(city: city)
            }
                .searchable(text: searchBinding.keyword,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "搜索城市")
                .onSubmit(of: .search) {
                    store.dispatch(.find)
                }
                .navigationBarTitleDisplayMode(.large)
                .navigationTitle("Search")
        }
            .navigationViewStyle(.stack)
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
            .lineLimit(1)
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
