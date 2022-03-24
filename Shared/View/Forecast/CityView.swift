import SwiftUI
import Kingfisher

struct CityView: View {
    @EnvironmentObject var store: Store
    let city: CityViewModel
    
    var forecast: OneCall? {
        store.appState.cityList.forecast?[city.id]
    }
    
    @State private var selectedDailyIndex: Int = 0
    
    var current: some View {
        guard let current = forecast?.current, let weather = current.weather.first else {
            return AnyView(EmptyView())
        }
        
        let content = VStack(alignment: .leading) {
            Text(current.dt.toDate.string("HH:mm", "MMM", "dd"))
                .foregroundColor(Color(.systemRed))
                .padding(.top, 10)
                .padding(.bottom, 5)
            Text("Feels like \(current.feels_like.celsius). \(weather.description.capitalized)")
                .font(.headline)
            HStack {
                KFImage(weather.icon.weatherIconURL)
                    .resizable()
                    .frame(width: 100, height: 100)
                Text(current.temp.celsius)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                Divider()
                    .background(Color(.systemRed))
                    .padding(.horizontal, 20)
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
        }
    
        return AnyView(content)
    }
    
    var hourly: some View {
        guard let hourly = forecast?.hourly else {
            return AnyView(EmptyView())
        }
    
        return AnyView(VStack(alignment: .leading) {
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
        })
    }
    
    var daily: some View {
        guard let daily = forecast?.daily, daily.count > 0 else {
            return AnyView(EmptyView())
        }
        return AnyView(VStack(alignment: .leading) {
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
            DailyForecastDetailView(daily: daily[selectedDailyIndex])
        })
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                current
                hourly
                daily
            }
        }
            .padding(.leading, 21)
            .padding(.bottom, 20)
            .onAppear {
                if forecast == nil || (Date().timeIntervalSince1970 - Double(forecast!.current.dt)) > 600 {
                    store.dispatch(.loadCityForecast(city: city))
                }
            }
            .navigationTitle(city.description)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: Button(action: {
                store.dispatch(.follow(city: city))
            }) {
                if store.appState.cityList.isFollowing(city.id) {
                    EmptyView()
                } else {
                    Image(systemName: "star")
                }
            })
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        let city = CityViewModel(city: SearchView_Previews.debugList()[0])
        return CityView(city: city)
            .environmentObject(Store())
            .background(Color.black)
    }
}
