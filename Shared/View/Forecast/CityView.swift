import SwiftUI
import Kingfisher
import ComposableArchitecture

struct CityView: View {
    let store: StoreOf<ForecastReducer>
    let city: CityViewModel
        
    @State private var selectedDailyIndex: Int = 0
    
    var body: some View {
        WithViewStore(store) {
            $0
        } content: { viewStore in
            if let error = viewStore.errorDescription {
                Label(error, systemImage: "exclamationmark.circle")
                    .padding()
            }
            ScrollView(.vertical) {
                if let forecast = viewStore.forecast?[city.id] {
                    VStack(alignment: .leading) {
                        CurrentView(current: forecast.current)
                        HourlyView(hourly: forecast.hourly)
                        DailyView(daily: forecast.daily, selectedDailyIndex: $selectedDailyIndex)
                    }
                    .padding(.leading, 21)
                    .padding(.bottom, 20)
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle(city.description)
            .toolbar {
                if !viewStore.followingList.contains(where: { $0.id == city.id }) {
                    ToolbarItem {
                        Button(action: {
                            viewStore.send(.follow(city: city))
                        }) {
                            Image(systemName: "star")
                        }
                        .keyboardShortcut("f")
                    }
                }
            }
        }
    }
}

private struct CurrentView: View {
    let current: Forecast
    
    var weather: Forecast.Condition? {
        current.weather.first
    }
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    #endif
    
    var feelsLike: some View {
        Text("Feels like \(current.feels_like.celsius). \(weather?.description.capitalized ?? "")")
            .font(.headline)
    }
    
    var temp: some View {
        HStack {
            if let url = weather?.icon.weatherIconURL {
                KFImage(url)
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            Text(current.temp.celsius)
                .font(.largeTitle)
                .fontWeight(.medium)
        }
    }
    
    var weatherItems: some View {
        WeatherItems(
            rain: current.rain?.lastHour,
            snow: current.snow?.lastHour,
            windSpeed: current.wind_speed,
            pressure: current.pressure,
            humidity: current.humidity,
            uvi: current.uvi,
            dewPoint: current.dew_point,
            visibility: current.visibility)
    }
    
    var body: some View {
            VStack(alignment: .leading) {
                Text(current.dt.toDate.string("HH:mm", "MMM", "dd"))
                    .foregroundColor(Color(.systemRed))
                    .padding(.top, 10)
                    .padding(.bottom, 5)
    
                #if os(iOS)
                if horizontalSizeClass == .compact {
                    HStack {
                        temp.layoutPriority(1)
                        Divider()
                            .background(Color(.systemRed))
                            .padding(.horizontal, 10)
                        feelsLike
                    }
                    .padding(.trailing, 10)
                } else {
                    feelsLike
                    HStack {
                        temp
                        Divider()
                            .background(Color(.systemRed))
                            .padding(.horizontal, 20)
                        weatherItems
                    }
                }
                #else
                feelsLike
                HStack {
                    temp
                    Divider()
                        .background(Color(.systemRed))
                        .padding(.horizontal, 20)
                    weatherItems
                }
                #endif
            }
    }
}

private struct HourlyView: View {
    let hourly: [Forecast]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hourly forecast")
                .font(.title2)
                .fontWeight(.medium)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(Array(hourly.enumerated()), id: \.offset) { (index, item) in
                        VStack {
                            Group {
                                if index == 0 {
                                    Text("now")
                                } else if Calendar.current.component(.hour, from: item.dt.toDate) == 0 {
                                    Text(item.dt.toDate.string("MMM", "dd"))
                                } else {
                                    Text(item.dt.toDate.string("h").lowercased())
                                }
                            }
                                .font(.headline)
                            if let f = item.weather.first {
                                KFImage(f.icon.weatherIconURL)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                            Text(item.temp.celsius)
                        }
                            .frame(width: 80, height: 150)
                    }
                }
            }
        }
    }
}

private struct DailyView: View {
    let daily: [DailyForecast]
    @Binding var selectedDailyIndex: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("8-Day forecast")
                .font(.title2)
                .fontWeight(.medium)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(daily.enumerated()), id: \.offset) { (index, item) in
                        VStack(spacing: 0) {
                            Text(index == 0 ? "Today" : item.dt.toDate.string("E", "dd"))
                                .font(.headline)
                            HStack(spacing: 0) {
                                if let f = item.weather.first {
                                    KFImage(f.icon.weatherIconURL)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                                Text("\(item.temp.min?.toString(maximumFractionDigits: 0) ?? "") / \(item.temp.max?.celsius ?? "")")
                            }
                            Rectangle()
                                .frame(width: 40, height: 6)
                                .cornerRadius(3)
                                .foregroundColor(selectedDailyIndex == index ? Color(.systemRed) : .clear)
                        }
                            .frame(height: 80)
                            .padding(.trailing, 20)
                            .onTapGesture {
                                withAnimation {
                                    selectedDailyIndex = index
                                }
                            }
                    }
                }
            }
            if daily.count > selectedDailyIndex {
                DailyForecastDetailView(daily: daily[selectedDailyIndex])
            }
        }
    }
}

#if DEBUG
struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        let city = CityViewModel(city: testCities[0])
        let store: StoreOf<ForecastReducer> = .init(
            initialState: ForecastReducer.State(),
            reducer: { ForecastReducer() }
        )
        
        WithViewStore(store, observe: { $0 }) { viewStore in
            CityView(store: store, city: city)
                .task {
                    viewStore.send(.loadCityForecast(city: city))
                }
        }
    }
}
#endif
