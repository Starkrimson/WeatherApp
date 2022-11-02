import Foundation

let testCities = try! JSONDecoder().decode([Find.City].self, from: testCitiesData)
let testCitiesData = """
[
  {
    "id": 1809858,
    "name": "Guangzhou",
    "coord": {
      "lat": 23.1167,
      "lon": 113.25
    },
    "main": {
      "temp": 300.12,
      "feels_like": 301.34
    },
    "sys": {
      "country": "CN"
    },
    "weather": [
      {
        "id": 803,
        "main": "Clouds",
        "description": "broken clouds",
        "icon": "04d"
      }
    ]
  },
  {
    "id": 6077243,
    "name": "Montréal",
    "coord": {
      "lat": 45.5088,
      "lon": -73.5878
    },
    "main": {
      "temp": 273.13,
      "feels_like": 270.39
    },
    "sys": {
      "country": "CA"
    },
    "weather": [
      {
        "id": 802,
        "main": "Clouds",
        "description": "scattered clouds",
        "icon": "03n"
      }
    ]
  },
  {
    "id": 1796236,
    "name": "Shanghai",
    "coord": {
      "lat": 31.2222,
      "lon": 121.4581
    },
    "main": {
      "temp": 283.67,
      "feels_like": 282.34
    },
    "sys": {
      "country": "CN"
    },
    "weather": [
      {
        "id": 500,
        "main": "Rain",
        "description": "light rain",
        "icon": "10d"
      }
    ]
  }
]
""".data(using: .utf8)!
