import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView(
                store: .init(
                    initialState: .init(),
                    reducer: weatherReducer,
                    environment: WeatherEnvironment(
                        mainQueue: .main,
                        weatherClient: .live,
                        followingClient: .live,
                        date: Date.init
                    )
                )
            )
                .withHostingWindow { window in
                    #if targetEnvironment(macCatalyst)
                    if let titleBar = window?.windowScene?.titlebar {
                        titleBar.titleVisibility = .hidden
                        titleBar.toolbar = nil
                    }
                    #endif
                }
        }
    }
}

/// Hosting Window 回调，隐藏 macCatalyst toolbar
/// https://stackoverflow.com/questions/65238068/hide-title-bar-in-swiftui-app-for-maccatalyst
extension View {
    fileprivate func withHostingWindow(_ callback: @escaping (UIWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

fileprivate struct HostingWindowFinder: UIViewRepresentable {
    var callback: (UIWindow?) -> ()
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async { [weak view] in
            callback(view?.window)
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
