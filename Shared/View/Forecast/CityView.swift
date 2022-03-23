import SwiftUI
import Kingfisher

struct CityView: View {
    @EnvironmentObject var store: Store
    let city: CityViewModel
    
    var forecast: OneCall? {
        store.appState.cityList.forecast?[city.id]
    }
    
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
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(Array(hourly.enumerated()), id: \.offset) { (index, item) in
                        VStack {
                            if index == 0 {
                                Text("now")
                            }
                            else if Calendar.current.component(.hour, from: item.dt.toDate) == 0 {
                                Text(item.dt.toDate.string("MMM", "dd"))
                            }
                            else {
                                Text(item.dt.toDate.string("h").lowercased())
                            }
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
        guard let daily = forecast?.daily else {
            return AnyView(EmptyView())
        }
        return AnyView(VStack(alignment: .leading) {
            Text("8-Day forecast")
                .font(.title2)
                .fontWeight(.medium)
            
            ForEach(Array(daily.enumerated()), id: \.offset) { (index, item: DailyForecast) in
                let weather = item.weather.first
                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        Group {
                            if index == 0 {
                                Text("today")
                            } else {
                                Text(item.dt.toDate.string("E"))
                            }
                        }
                            .frame(width: 120, alignment: .leading)
        
                        HStack {
                            if let f = item.weather.first {
                                KFImage(f.icon.weatherIconURL)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                            }
                            Text("\(item.temp.min?.toString(maximumFractionDigits: 0) ?? "") / \(item.temp.max?.celsius ?? "")")
                        }
                            .frame(width: 180, alignment: .leading)
        
                        Text(weather?.description ?? "")
                            .frame(width: 200, alignment: .trailing)
        
                        Image(systemName: "chevron.down")
                            .padding(.leading, 40)
                    }
                        .lineLimit(1)
                        .frame(height: 60)
                    if index == 0 {
                        DailyForecastDetailView(daily: item)
                    }
                }
            }
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
            .onAppear {
                if forecast == nil {
                    store.dispatch(.loadCityForecast(city: city))
                }
            }
            .navigationTitle(city.description)
            .navigationBarTitleDisplayMode(.large)
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
