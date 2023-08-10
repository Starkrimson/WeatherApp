import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView(
                store: .init(
                    initialState: .init(),
                    reducer: { WeatherReducer() }
                )
            )
        }
    }
}
