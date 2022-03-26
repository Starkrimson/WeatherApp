# WeatherApp

> [《SwiftUI 与 Combine 编程》(喵神)](https://objccn.io/products/swift-ui) 读后实践

一个天气 App，可搜索、关注城市，查看城市详细天气预报。


由 SwiftUI 驱动的跨平台 app，包括 UI 布局、状态管理、网络数据获取和本地数据存储等等。

编译环境：macOS 12.0.1, Xcode 13.3, iOS 15.4

https://user-images.githubusercontent.com/16103570/160243859-863413ce-c1ca-4775-8c56-3a322cef9f30.mp4

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
```

### 状态管理

**类 Redux 的架构**

1. 状态决定用户界面，所有 `State` 储存在 `Store` 对象中。
2. view **不能**直接操作 state， 只能通过发送 `Action`，Store 的 `Reducer` 处理这些 action，生成新的 state。
3. 新的 state 会替换 store 中原有的状态，并驱动页面更新。
4. Reducer 生成新 state 时可能会带副作用，额外返回一个 `Command`。
5. 异步的 command 需要更改 state，也是通过 action。

```swift
class Store: ObservableObject { // 1
    @Published var appState = AppState() // 1
    
    // 2
    static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand?
        
        switch action {
            // case ...   
        }
        
        // 3, 4
        return (appState, appCommand)
    }
}
```
```swift
struct FindAppCommand: AppCommand {

    func execute(in store: Store) {
        // await ...
        store.dispatch(action) // 5
    }
}
```

### 网络请求

```swift
struct FindRequest: AppRequest {
    
    var publisher: AnyPublisher<Find, AppError> {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Find.self, decoder: JSONDecoder())
            .mapError { AppError.networkingFailed($0) }
            .eraseToAnyPublisher()
    }
}
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

源码不含 appid，需要编译看效果可以去官网注册免费的 appid。然后赋值 `FindRequst.swift`：
```swift
extension AppRequest {
    var appid: String { "" }
}
```
