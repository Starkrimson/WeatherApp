# WeatherApp

> [《SwiftUI 与 Combine 编程》(喵神)](https://objccn.io/products/swift-ui) 读后实践

一个天气 App，可搜索、关注城市，查看城市详细天气预报。


由 SwiftUI 驱动的跨平台 app，包括 UI 布局、状态管理、网络数据获取和本地数据存储等等。

编译环境：macOS 12.4, Xcode 14.0 beta, iOS 16.0 beta

https://user-images.githubusercontent.com/16103570/160243859-863413ce-c1ca-4775-8c56-3a322cef9f30.mp4

### [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) 可组装架构

> [TCA 中文 readme](https://gist.github.com/sh3l6orrr/10c8f7c634a892a9c37214f3211242ad)

* State：即状态，是一个用于描述某个功能的执行逻辑，和渲染界面所需的数据的类。

```swift
struct SearchState: Equatable {
    @BindableState var searchQuery = ""
    var list: [Find.City] = []
}
```

* Action：一个代表在功能中所有可能的动作的类，如用户的行为、提醒，和事件源等。

```swift
enum SearchAction: Equatable, BindableAction {
    case binding(BindingAction<SearchState>)
    case search(query: String)
    case citiesResponse(Result<[Find.City], AppError>)
}
```

* Environment：一个包含功能的依赖的类，如API客户端，分析客户端等。

```swift
struct SearchEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var weatherClient: WeatherClient
}
```

* Reducer：一个用于描述触发「Action」时，如何从当前状态（state）变化到下一个状态的函数，它同时负责返回任何需要被执行的「Effect」，如API请求（通过返回一个「Effect」实例来完成）。

```swift

let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment> {
    state, action, environment in
    
    switch action {
    case .binding:
        return .none
    case .search(let query):
        struct SearchCityId: Hashable { }
        
        return environment.weatherClient
            .searchCity(query)
            .receive(on: environment.mainQueue)
            .catchToEffect(SearchAction.citiesResponse)
            .cancellable(id: SearchCityId(), cancelInFlight: true)
        
    case .citiesResponse(let result):
        switch result {
        case .success(let list):
            state.list = list
        case .failure(let error):
            state.list = []
        }
        return .none
    }
}
    .binding()
    .debug()
```

* Store：用于驱动某个功能的运行时（runtime）。将所有用户行为发送到「Store」中，令它运行「Reducer」和「Effects」。同时从「Store」中观测「State」，以更新UI。

```swift
SearchView(
    store: .init(
        initialState: .init(),
        reducer: weatherReducer,
        environment: WeatherEnvironment(mainQueue: .main, weatherClient: .live)
    )
)
```

```swift
struct SearchView: View {
    let store: Store<WeatherState, WeatherAction>
    
    var body: some View {
        WithViewStore(searchStore) { viewStore in
            List(viewStore.list) { item in
                Cell(...)
            }
            .searchable(text: viewStore.binding(\.$searchQuery))
            .onSubmit(of: .search) {
                viewStore.send(.search(query: viewStore.searchQuery))
            }
        }
    }
}
```

### 分栏和导航

```swift
NavigationView {
    // 第一个 view 为左侧 sidebar
    List {
        // 点击 link 会 push 到 destination；如果是分屏下，destination 会显示在 detailView。
        NavigationLink(destination: CityView(city: city)) {
            Text(city.description)
        }
    }
    // 第二个 view 为右侧 detail view
    Image(systemName: "cloud.sun").font(.largeTitle)
}

// iOS16.0+ macOS13.0+
NavigationSplitView { // sidebar
    List(selection: searchViewStore.binding(\.$selectedCity)) {
        SearchSection(viewStore: searchViewStore)
        FollowingSection(store: forecastStore)
    }
} detail: { // detail
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
```

### 网络请求

```swift
struct WeatherClient {
    var searchCity: (String) -> Effect<[Find.City], AppError>
}

extension WeatherClient {
    static let live = WeatherClient(
        searchCity: { query in
            guard let q = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: "https://openweathermap.org/data/2.5/find?q=\(q)&appid=\(appid)&units=metric")
                else {
                return Effect(error: .badURL)
            }
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: Find.self, decoder: JSONDecoder())
                .map { $0.list }
                .mapError { AppError.networkingFailed($0) }
                .eraseToEffect()
        }
    )
```

### 屏幕适配

通过 `@Environment` 获取 `horizontalSizeClass` 环境变量。

当 `horizontalSizeClass == .compact`，可能是竖屏的 iPhone 或者分屏下的 iPad。

```swift
@Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?

var body: some View {
    if horizontalSizeClass == .compact {
        VStack {
            // ...
        }
    } else {
        HStack {
            // ...
        }
    }
}
```

同样还有 `verticalSizeClass`

### 数据来源

[<img alt="openweathermap" src="https://openweathermap.org/themes/openweathermap/assets/img/logo_white_cropped.png" width="120"/>](https://openweathermap.org/) [openweathermap.org](https://openweathermap.org/)

源码不含 appid，需要编译看效果可以去官网注册免费的 appid。然后赋值 `WeatherClient.swift`：
```swift
private let appid = "xxx"
```
