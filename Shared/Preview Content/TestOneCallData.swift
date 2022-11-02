import Foundation

let testOneCall = try! JSONDecoder().decode(OneCall.self, from: testOneCallData)
let testOneCallData = """
{
  "daily": [
    {
      "rain": 1.02,
      "dt": 1648699200,
      "humidity": 57,
      "temp": {
        "night": 22.960000000000001,
        "eve": 25.68,
        "min": 21.91,
        "day": 26.670000000000002,
        "morn": 21.91,
        "max": 26.670000000000002
      },
      "sunrise": 1648678641,
      "sunset": 1648723078,
      "uvi": 10.49,
      "moon_phase": 0.95999999999999996,
      "wind_deg": 125,
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "icon": "10d",
          "description": "light rain"
        }
      ],
      "feels_like": {
        "night": 23.32,
        "eve": 25.870000000000001,
        "day": 27.5,
        "morn": 22.27
      },
      "moonset": 1648720140,
      "clouds": 25,
      "wind_speed": 3.5,
      "pressure": 1016,
      "moonrise": 1648676700,
      "dew_point": 17.449999999999999,
      "pop": 0.60999999999999999
    },
    {
      "rain": 0.35999999999999999,
      "dt": 1648785600,
      "humidity": 69,
      "temp": {
        "night": 15.109999999999999,
        "eve": 17.239999999999998,
        "min": 15.109999999999999,
        "day": 18.210000000000001,
        "morn": 20.149999999999999,
        "max": 22.48
      },
      "sunrise": 1648764983,
      "sunset": 1648809498,
      "uvi": 1.8,
      "moon_phase": 0,
      "wind_deg": 28,
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "icon": "10d",
          "description": "light rain"
        }
      ],
      "feels_like": {
        "night": 14.369999999999999,
        "eve": 16.690000000000001,
        "day": 17.890000000000001,
        "morn": 20.34
      },
      "moonset": 1648809840,
      "clouds": 100,
      "wind_speed": 6.1500000000000004,
      "pressure": 1022,
      "moonrise": 1648765200,
      "dew_point": 12.4,
      "pop": 0.48999999999999999
    },
    {
      "rain": 5.0300000000000002,
      "dt": 1648872000,
      "humidity": 73,
      "temp": {
        "night": 13.67,
        "eve": 13.550000000000001,
        "min": 12.41,
        "day": 12.6,
        "morn": 12.779999999999999,
        "max": 14.91
      },
      "sunrise": 1648851326,
      "sunset": 1648895919,
      "uvi": 1.5800000000000001,
      "moon_phase": 0.029999999999999999,
      "wind_deg": 20,
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "icon": "10d",
          "description": "light rain"
        }
      ],
      "feels_like": {
        "night": 12.82,
        "eve": 12.529999999999999,
        "day": 11.82,
        "morn": 12.1
      },
      "moonset": 1648899480,
      "clouds": 100,
      "wind_speed": 6.0300000000000002,
      "pressure": 1024,
      "moonrise": 1648853640,
      "dew_point": 7.8600000000000003,
      "pop": 1
    },
    {
      "dt": 1648958400,
      "humidity": 43,
      "temp": {
        "night": 18.190000000000001,
        "eve": 21.920000000000002,
        "min": 14.029999999999999,
        "day": 18.609999999999999,
        "morn": 14.380000000000001,
        "max": 21.920000000000002
      },
      "sunrise": 1648937669,
      "sunset": 1648982339,
      "uvi": 10.83,
      "moon_phase": 0.059999999999999998,
      "wind_deg": 44,
      "weather": [
        {
          "id": 802,
          "main": "Clouds",
          "icon": "03d",
          "description": "scattered clouds"
        }
      ],
      "feels_like": {
        "night": 17.739999999999998,
        "eve": 21.210000000000001,
        "day": 17.649999999999999,
        "morn": 13.44
      },
      "moonset": 1648989120,
      "clouds": 46,
      "wind_speed": 4.5099999999999998,
      "pressure": 1023,
      "moonrise": 1648942080,
      "dew_point": 5.9100000000000001,
      "pop": 0.70999999999999996
    },
    {
      "dt": 1649044800,
      "humidity": 44,
      "temp": {
        "night": 19.129999999999999,
        "eve": 23.350000000000001,
        "min": 16.27,
        "day": 21.050000000000001,
        "morn": 16.27,
        "max": 23.489999999999998
      },
      "sunrise": 1649024012,
      "sunset": 1649068760,
      "uvi": 11.06,
      "moon_phase": 0.089999999999999997,
      "wind_deg": 105,
      "weather": [
        {
          "id": 800,
          "main": "Clear",
          "icon": "01d",
          "description": "clear sky"
        }
      ],
      "feels_like": {
        "night": 18.850000000000001,
        "eve": 22.789999999999999,
        "day": 20.359999999999999,
        "morn": 15.75
      },
      "moonset": 1649078820,
      "clouds": 0,
      "wind_speed": 3.9100000000000001,
      "pressure": 1023,
      "moonrise": 1649030580,
      "dew_point": 8.1799999999999997,
      "pop": 0
    },
    {
      "dt": 1649131200,
      "humidity": 45,
      "temp": {
        "night": 22.149999999999999,
        "eve": 25.75,
        "min": 17.670000000000002,
        "day": 23.359999999999999,
        "morn": 17.670000000000002,
        "max": 26.050000000000001
      },
      "sunrise": 1649110355,
      "sunset": 1649155181,
      "uvi": 12,
      "moon_phase": 0.13,
      "wind_deg": 89,
      "weather": [
        {
          "id": 800,
          "main": "Clear",
          "icon": "01d",
          "description": "clear sky"
        }
      ],
      "feels_like": {
        "night": 21.989999999999998,
        "eve": 25.5,
        "day": 22.93,
        "morn": 17.5
      },
      "moonset": 1649168460,
      "clouds": 0,
      "wind_speed": 2.6499999999999999,
      "pressure": 1022,
      "moonrise": 1649119260,
      "dew_point": 10.68,
      "pop": 0
    },
    {
      "dt": 1649217600,
      "humidity": 46,
      "temp": {
        "night": 21.91,
        "eve": 25.960000000000001,
        "min": 20.329999999999998,
        "day": 25.48,
        "morn": 20.329999999999998,
        "max": 26.989999999999998
      },
      "sunrise": 1649196699,
      "sunset": 1649241602,
      "uvi": 12,
      "moon_phase": 0.16,
      "wind_deg": 141,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04d",
          "description": "overcast clouds"
        }
      ],
      "feels_like": {
        "night": 22.039999999999999,
        "eve": 25.960000000000001,
        "day": 25.280000000000001,
        "morn": 20.219999999999999
      },
      "moonset": 1649258100,
      "clouds": 88,
      "wind_speed": 2.6699999999999999,
      "pressure": 1019,
      "moonrise": 1649208120,
      "dew_point": 12.65,
      "pop": 0
    },
    {
      "dt": 1649304000,
      "humidity": 47,
      "temp": {
        "night": 22.82,
        "eve": 27.02,
        "min": 20.539999999999999,
        "day": 26.120000000000001,
        "morn": 20.539999999999999,
        "max": 27.940000000000001
      },
      "sunrise": 1649283043,
      "sunset": 1649328023,
      "uvi": 12,
      "moon_phase": 0.19,
      "wind_deg": 86,
      "weather": [
        {
          "id": 800,
          "main": "Clear",
          "icon": "01d",
          "description": "clear sky"
        }
      ],
      "feels_like": {
        "night": 22.829999999999998,
        "eve": 27.09,
        "day": 26.120000000000001,
        "morn": 20.609999999999999
      },
      "moonset": 0,
      "clouds": 5,
      "wind_speed": 2.4399999999999999,
      "pressure": 1017,
      "moonrise": 1649297160,
      "dew_point": 13.859999999999999,
      "pop": 0
    }
  ],
  "lat": 22.617699999999999,
  "current": {
    "dt": 1648711619,
    "humidity": 56,
    "temp": 24.789999999999999,
    "sunrise": 1648678641,
    "sunset": 1648723078,
    "uvi": 4.8300000000000001,
    "wind_deg": 143,
    "wind_gust": 3.1600000000000001,
    "feels_like": 24.789999999999999,
    "clouds": 55,
    "visibility": 10000,
    "wind_speed": 2.8100000000000001,
    "pressure": 1014,
    "dew_point": 15.42,
    "weather": [
      {
        "id": 803,
        "main": "Clouds",
        "icon": "04d",
        "description": "broken clouds"
      }
    ]
  },
  "lon": 114.1259,
  "hourly": [
    {
      "dt": 1648710000,
      "humidity": 56,
      "temp": 24.789999999999999,
      "uvi": 4.8300000000000001,
      "wind_deg": 143,
      "wind_gust": 3.1600000000000001,
      "feels_like": 24.789999999999999,
      "clouds": 55,
      "visibility": 10000,
      "wind_speed": 2.8100000000000001,
      "dew_point": 15.42,
      "pressure": 1014,
      "weather": [
        {
          "id": 803,
          "main": "Clouds",
          "icon": "04d",
          "description": "broken clouds"
        }
      ],
      "pop": 0.13
    },
    {
      "dt": 1648713600,
      "humidity": 57,
      "temp": 25.379999999999999,
      "uvi": 2.48,
      "wind_deg": 139,
      "wind_gust": 3.48,
      "feels_like": 25.460000000000001,
      "clouds": 53,
      "visibility": 10000,
      "wind_speed": 2.9100000000000001,
      "dew_point": 16.25,
      "pressure": 1014,
      "weather": [
        {
          "id": 803,
          "main": "Clouds",
          "icon": "04d",
          "description": "broken clouds"
        }
      ],
      "pop": 0.20999999999999999
    },
    {
      "dt": 1648717200,
      "humidity": 58,
      "temp": 25.800000000000001,
      "uvi": 0.83999999999999997,
      "wind_deg": 131,
      "wind_gust": 3.9900000000000002,
      "feels_like": 25.949999999999999,
      "clouds": 49,
      "visibility": 10000,
      "wind_speed": 3.21,
      "dew_point": 16.920000000000002,
      "pressure": 1014,
      "weather": [
        {
          "id": 802,
          "main": "Clouds",
          "icon": "03d",
          "description": "scattered clouds"
        }
      ],
      "pop": 0.27000000000000002
    },
    {
      "dt": 1648720800,
      "humidity": 60,
      "temp": 25.68,
      "uvi": 0.070000000000000034,
      "wind_deg": 125,
      "wind_gust": 4.6299999999999999,
      "feels_like": 25.870000000000001,
      "clouds": 45,
      "visibility": 10000,
      "wind_speed": 3.5,
      "dew_point": 17.34,
      "pressure": 1014,
      "weather": [
        {
          "id": 802,
          "main": "Clouds",
          "icon": "03d",
          "description": "scattered clouds"
        }
      ],
      "pop": 0.26000000000000001
    },
    {
      "dt": 1648724400,
      "humidity": 65,
      "temp": 25,
      "uvi": 0,
      "wind_deg": 120,
      "wind_gust": 5.0099999999999998,
      "feels_like": 25.25,
      "clouds": 38,
      "visibility": 10000,
      "wind_speed": 3.3700000000000001,
      "dew_point": 17.969999999999999,
      "pressure": 1015,
      "weather": [
        {
          "id": 802,
          "main": "Clouds",
          "icon": "03n",
          "description": "scattered clouds"
        }
      ],
      "pop": 0.22
    },
    {
      "dt": 1648728000,
      "humidity": 70,
      "temp": 24.370000000000001,
      "uvi": 0,
      "wind_deg": 116,
      "wind_gust": 4.8300000000000001,
      "feels_like": 24.690000000000001,
      "clouds": 29,
      "visibility": 10000,
      "wind_speed": 3.1000000000000001,
      "dew_point": 18.359999999999999,
      "pressure": 1016,
      "weather": [
        {
          "id": 802,
          "main": "Clouds",
          "icon": "03n",
          "description": "scattered clouds"
        }
      ],
      "pop": 0.22
    },
    {
      "dt": 1648731600,
      "humidity": 73,
      "temp": 23.82,
      "uvi": 0,
      "wind_deg": 105,
      "wind_gust": 4.6600000000000001,
      "feels_like": 24.16,
      "clouds": 8,
      "visibility": 10000,
      "wind_speed": 2.8799999999999999,
      "dew_point": 18.440000000000001,
      "pressure": 1017,
      "weather": [
        {
          "id": 800,
          "main": "Clear",
          "icon": "01n",
          "description": "clear sky"
        }
      ],
      "pop": 0.19
    },
    {
      "dt": 1648735200,
      "humidity": 75,
      "temp": 23.43,
      "uvi": 0,
      "wind_deg": 103,
      "wind_gust": 4.4299999999999997,
      "feels_like": 23.789999999999999,
      "clouds": 10,
      "visibility": 10000,
      "wind_speed": 2.6699999999999999,
      "dew_point": 18.5,
      "pressure": 1018,
      "weather": [
        {
          "id": 800,
          "main": "Clear",
          "icon": "01n",
          "description": "clear sky"
        }
      ],
      "pop": 0.19
    },
    {
      "dt": 1648738800,
      "humidity": 77,
      "temp": 22.960000000000001,
      "uvi": 0,
      "wind_deg": 102,
      "wind_gust": 4.6900000000000004,
      "feels_like": 23.32,
      "clouds": 10,
      "visibility": 10000,
      "wind_speed": 2.8199999999999998,
      "dew_point": 18.530000000000001,
      "pressure": 1018,
      "weather": [
        {
          "id": 800,
          "main": "Clear",
          "icon": "01n",
          "description": "clear sky"
        }
      ],
      "pop": 0.28999999999999998
    },
    {
      "dt": 1648742400,
      "humidity": 79,
      "temp": 22.48,
      "uvi": 0,
      "wind_deg": 94,
      "wind_gust": 4.5999999999999996,
      "feels_like": 22.850000000000001,
      "clouds": 14,
      "visibility": 10000,
      "wind_speed": 2.7599999999999998,
      "dew_point": 18.530000000000001,
      "pressure": 1018,
      "weather": [
        {
          "id": 801,
          "main": "Clouds",
          "icon": "02n",
          "description": "few clouds"
        }
      ],
      "pop": 0.28999999999999998
    },
    {
      "dt": 1648746000,
      "humidity": 80,
      "temp": 22.18,
      "uvi": 0,
      "wind_deg": 82,
      "wind_gust": 5.2199999999999998,
      "feels_like": 22.539999999999999,
      "clouds": 25,
      "visibility": 10000,
      "wind_speed": 3.2200000000000002,
      "dew_point": 18.52,
      "pressure": 1018,
      "weather": [
        {
          "id": 802,
          "main": "Clouds",
          "icon": "03n",
          "description": "scattered clouds"
        }
      ],
      "pop": 0.28999999999999998
    },
    {
      "dt": 1648749600,
      "humidity": 81,
      "temp": 21.870000000000001,
      "uvi": 0,
      "wind_deg": 82,
      "wind_gust": 4.7699999999999996,
      "feels_like": 22.23,
      "clouds": 36,
      "visibility": 10000,
      "wind_speed": 3.0899999999999999,
      "dew_point": 18.469999999999999,
      "pressure": 1018,
      "weather": [
        {
          "id": 802,
          "main": "Clouds",
          "icon": "03n",
          "description": "scattered clouds"
        }
      ],
      "pop": 0.28999999999999998
    },
    {
      "rain": {
        "1h": 0.10000000000000001
      },
      "dt": 1648753200,
      "humidity": 82,
      "temp": 21.460000000000001,
      "uvi": 0,
      "wind_deg": 77,
      "wind_gust": 4.6900000000000004,
      "feels_like": 21.800000000000001,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 3.0499999999999998,
      "dew_point": 18.289999999999999,
      "pressure": 1017,
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "icon": "10n",
          "description": "light rain"
        }
      ],
      "pop": 0.45000000000000001
    },
    {
      "rain": {
        "1h": 0.14999999999999999
      },
      "dt": 1648756800,
      "humidity": 82,
      "temp": 21.010000000000002,
      "uvi": 0,
      "wind_deg": 71,
      "wind_gust": 5.29,
      "feels_like": 21.309999999999999,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 3.5600000000000001,
      "dew_point": 17.879999999999999,
      "pressure": 1017,
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "icon": "10n",
          "description": "light rain"
        }
      ],
      "pop": 0.48999999999999999
    },
    {
      "dt": 1648760400,
      "humidity": 82,
      "temp": 20.59,
      "uvi": 0,
      "wind_deg": 68,
      "wind_gust": 5.1600000000000001,
      "feels_like": 20.850000000000001,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 3.4900000000000002,
      "dew_point": 17.34,
      "pressure": 1018,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04n",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.48999999999999999
    },
    {
      "rain": {
        "1h": 0.11
      },
      "dt": 1648764000,
      "humidity": 81,
      "temp": 20.149999999999999,
      "uvi": 0,
      "wind_deg": 61,
      "wind_gust": 5.6299999999999999,
      "feels_like": 20.34,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 3.7400000000000002,
      "dew_point": 16.66,
      "pressure": 1019,
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "icon": "10n",
          "description": "light rain"
        }
      ],
      "pop": 0.41999999999999998
    },
    {
      "dt": 1648767600,
      "humidity": 78,
      "temp": 19.73,
      "uvi": 0.040000000000000001,
      "wind_deg": 53,
      "wind_gust": 6.3099999999999996,
      "feels_like": 19.800000000000001,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 4.1500000000000004,
      "dew_point": 15.710000000000001,
      "pressure": 1020,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04d",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.44
    },
    {
      "dt": 1648771200,
      "humidity": 76,
      "temp": 19.260000000000002,
      "uvi": 0.23999999999999999,
      "wind_deg": 46,
      "wind_gust": 6.5700000000000003,
      "feels_like": 19.23,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 4.3300000000000001,
      "dew_point": 14.779999999999999,
      "pressure": 1021,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04d",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.46000000000000002
    },
    {
      "dt": 1648774800,
      "humidity": 73,
      "temp": 18.84,
      "uvi": 0.55000000000000004,
      "wind_deg": 43,
      "wind_gust": 6.5999999999999996,
      "feels_like": 18.690000000000001,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 4.4100000000000001,
      "dew_point": 13.91,
      "pressure": 1022,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04d",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.47999999999999998
    },
    {
      "dt": 1648778400,
      "humidity": 71,
      "temp": 18.539999999999999,
      "uvi": 1,
      "wind_deg": 39,
      "wind_gust": 6.2999999999999998,
      "feels_like": 18.300000000000001,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 4.2800000000000002,
      "dew_point": 13.18,
      "pressure": 1022,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04d",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.44
    },
    {
      "dt": 1648782000,
      "humidity": 70,
      "temp": 18.359999999999999,
      "uvi": 1.4199999999999999,
      "wind_deg": 32,
      "wind_gust": 5.5099999999999998,
      "feels_like": 18.079999999999998,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 3.9700000000000002,
      "dew_point": 12.73,
      "pressure": 1022,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04d",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.44
    },
    {
      "dt": 1648785600,
      "humidity": 69,
      "temp": 18.210000000000001,
      "uvi": 1.2,
      "wind_deg": 24,
      "wind_gust": 5.8899999999999997,
      "feels_like": 17.890000000000001,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 4.25,
      "dew_point": 12.4,
      "pressure": 1022,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04d",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.40000000000000002
    },
    {
      "dt": 1648789200,
      "humidity": 68,
      "temp": 18.059999999999999,
      "uvi": 1.1799999999999999,
      "wind_deg": 24,
      "wind_gust": 6.6299999999999999,
      "feels_like": 17.699999999999999,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 4.75,
      "dew_point": 12.07,
      "pressure": 1021,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04d",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.35999999999999999
    },
    {
      "dt": 1648792800,
      "humidity": 66,
      "temp": 18.149999999999999,
      "uvi": 0.97999999999999998,
      "wind_deg": 22,
      "wind_gust": 7.3499999999999996,
      "feels_like": 17.739999999999998,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.4299999999999997,
      "dew_point": 11.779999999999999,
      "pressure": 1020,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04d",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.29999999999999999
    },
    {
      "dt": 1648796400,
      "humidity": 63,
      "temp": 18.66,
      "uvi": 1.8,
      "wind_deg": 23,
      "wind_gust": 7.54,
      "feels_like": 18.23,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.7199999999999998,
      "dew_point": 11.529999999999999,
      "pressure": 1020,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04d",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.10000000000000001
    },
    {
      "dt": 1648800000,
      "humidity": 62,
      "temp": 18.800000000000001,
      "uvi": 0.92000000000000004,
      "wind_deg": 25,
      "wind_gust": 7.8799999999999999,
      "feels_like": 18.350000000000001,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 6.1200000000000001,
      "dew_point": 11.289999999999999,
      "pressure": 1019,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04d",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.059999999999999998
    },
    {
      "dt": 1648803600,
      "humidity": 62,
      "temp": 18.190000000000001,
      "uvi": 0.32000000000000001,
      "wind_deg": 25,
      "wind_gust": 8.1699999999999999,
      "feels_like": 17.68,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 6.1200000000000001,
      "dew_point": 10.800000000000001,
      "pressure": 1020,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04d",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.070000000000000034
    },
    {
      "dt": 1648807200,
      "humidity": 64,
      "temp": 17.239999999999998,
      "uvi": 0.070000000000000034,
      "wind_deg": 29,
      "wind_gust": 8.5999999999999996,
      "feels_like": 16.690000000000001,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 6.04,
      "dew_point": 10.24,
      "pressure": 1021,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04d",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.070000000000000034
    },
    {
      "dt": 1648810800,
      "humidity": 64,
      "temp": 16.52,
      "uvi": 0,
      "wind_deg": 28,
      "wind_gust": 9.4000000000000004,
      "feels_like": 15.9,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 6.1500000000000004,
      "dew_point": 9.7100000000000009,
      "pressure": 1022,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04n",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.089999999999999997
    },
    {
      "dt": 1648814400,
      "humidity": 64,
      "temp": 16.09,
      "uvi": 0,
      "wind_deg": 29,
      "wind_gust": 9.8100000000000005,
      "feels_like": 15.43,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 6.04,
      "dew_point": 9.1799999999999997,
      "pressure": 1023,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04n",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.14999999999999999
    },
    {
      "dt": 1648818000,
      "humidity": 64,
      "temp": 15.710000000000001,
      "uvi": 0,
      "wind_deg": 30,
      "wind_gust": 10.16,
      "feels_like": 15.01,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 6.0499999999999998,
      "dew_point": 8.8300000000000001,
      "pressure": 1023,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04n",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.23000000000000001
    },
    {
      "dt": 1648821600,
      "humidity": 64,
      "temp": 15.369999999999999,
      "uvi": 0,
      "wind_deg": 29,
      "wind_gust": 10.119999999999999,
      "feels_like": 14.630000000000001,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.9699999999999998,
      "dew_point": 8.6400000000000006,
      "pressure": 1024,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04n",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.23000000000000001
    },
    {
      "dt": 1648825200,
      "humidity": 65,
      "temp": 15.109999999999999,
      "uvi": 0,
      "wind_deg": 30,
      "wind_gust": 9.8200000000000003,
      "feels_like": 14.369999999999999,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.6699999999999999,
      "dew_point": 8.4900000000000002,
      "pressure": 1024,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04n",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.37
    },
    {
      "dt": 1648828800,
      "humidity": 65,
      "temp": 14.91,
      "uvi": 0,
      "wind_deg": 27,
      "wind_gust": 9.4399999999999995,
      "feels_like": 14.15,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.4299999999999997,
      "dew_point": 8.3699999999999992,
      "pressure": 1024,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04n",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.37
    },
    {
      "dt": 1648832400,
      "humidity": 65,
      "temp": 14.640000000000001,
      "uvi": 0,
      "wind_deg": 26,
      "wind_gust": 9.3300000000000001,
      "feels_like": 13.859999999999999,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.3200000000000003,
      "dew_point": 8.2300000000000004,
      "pressure": 1023,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04n",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.40999999999999998
    },
    {
      "dt": 1648836000,
      "humidity": 66,
      "temp": 14.449999999999999,
      "uvi": 0,
      "wind_deg": 23,
      "wind_gust": 9.1500000000000004,
      "feels_like": 13.67,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.2800000000000002,
      "dew_point": 8.1799999999999997,
      "pressure": 1022,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04n",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.45000000000000001
    },
    {
      "rain": {
        "1h": 0.14999999999999999
      },
      "dt": 1648839600,
      "humidity": 69,
      "temp": 13.94,
      "uvi": 0,
      "wind_deg": 20,
      "wind_gust": 9.2799999999999994,
      "feels_like": 13.19,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.3799999999999999,
      "dew_point": 8.3699999999999992,
      "pressure": 1022,
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "icon": "10n",
          "description": "light rain"
        }
      ],
      "pop": 0.60999999999999999
    },
    {
      "rain": {
        "1h": 0.28999999999999998
      },
      "dt": 1648843200,
      "humidity": 71,
      "temp": 13.529999999999999,
      "uvi": 0,
      "wind_deg": 18,
      "wind_gust": 9.7699999999999996,
      "feels_like": 12.789999999999999,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.5499999999999998,
      "dew_point": 8.4800000000000004,
      "pressure": 1022,
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "icon": "10n",
          "description": "light rain"
        }
      ],
      "pop": 0.96999999999999997
    },
    {
      "rain": {
        "1h": 0.45000000000000001
      },
      "dt": 1648846800,
      "humidity": 73,
      "temp": 13.18,
      "uvi": 0,
      "wind_deg": 20,
      "wind_gust": 10.140000000000001,
      "feels_like": 12.460000000000001,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.6100000000000003,
      "dew_point": 8.5299999999999994,
      "pressure": 1022,
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "icon": "10n",
          "description": "light rain"
        }
      ],
      "pop": 1
    },
    {
      "rain": {
        "1h": 0.71999999999999997
      },
      "dt": 1648850400,
      "humidity": 76,
      "temp": 12.779999999999999,
      "uvi": 0,
      "wind_deg": 22,
      "wind_gust": 10.99,
      "feels_like": 12.1,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.7000000000000002,
      "dew_point": 8.7200000000000006,
      "pressure": 1023,
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "icon": "10n",
          "description": "light rain"
        }
      ],
      "pop": 1
    },
    {
      "rain": {
        "1h": 0.42999999999999999
      },
      "dt": 1648854000,
      "humidity": 77,
      "temp": 12.539999999999999,
      "uvi": 0.059999999999999998,
      "wind_deg": 26,
      "wind_gust": 11.289999999999999,
      "feels_like": 11.859999999999999,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.7199999999999998,
      "dew_point": 8.6500000000000004,
      "pressure": 1023,
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "icon": "10d",
          "description": "light rain"
        }
      ],
      "pop": 1
    },
    {
      "rain": {
        "1h": 0.35999999999999999
      },
      "dt": 1648857600,
      "humidity": 77,
      "temp": 12.52,
      "uvi": 0.31,
      "wind_deg": 28,
      "wind_gust": 11.390000000000001,
      "feels_like": 11.84,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.7599999999999998,
      "dew_point": 8.5800000000000001,
      "pressure": 1024,
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "icon": "10d",
          "description": "light rain"
        }
      ],
      "pop": 1
    },
    {
      "rain": {
        "1h": 0.52000000000000002
      },
      "dt": 1648861200,
      "humidity": 77,
      "temp": 12.44,
      "uvi": 0.53000000000000003,
      "wind_deg": 25,
      "wind_gust": 10.75,
      "feels_like": 11.75,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.4699999999999998,
      "dew_point": 8.5500000000000007,
      "pressure": 1025,
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "icon": "10d",
          "description": "light rain"
        }
      ],
      "pop": 0.94999999999999996
    },
    {
      "rain": {
        "1h": 0.58999999999999997
      },
      "dt": 1648864800,
      "humidity": 77,
      "temp": 12.41,
      "uvi": 0.95999999999999996,
      "wind_deg": 21,
      "wind_gust": 10.23,
      "feels_like": 11.720000000000001,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.1900000000000004,
      "dew_point": 8.4299999999999997,
      "pressure": 1025,
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "icon": "10d",
          "description": "light rain"
        }
      ],
      "pop": 0.94999999999999996
    },
    {
      "rain": {
        "1h": 0.39000000000000001
      },
      "dt": 1648868400,
      "humidity": 75,
      "temp": 12.52,
      "uvi": 1.3600000000000001,
      "wind_deg": 21,
      "wind_gust": 10.19,
      "feels_like": 11.789999999999999,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.3200000000000003,
      "dew_point": 8.2100000000000009,
      "pressure": 1025,
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "icon": "10d",
          "description": "light rain"
        }
      ],
      "pop": 0.94999999999999996
    },
    {
      "rain": {
        "1h": 0.17000000000000001
      },
      "dt": 1648872000,
      "humidity": 73,
      "temp": 12.6,
      "uvi": 1.5800000000000001,
      "wind_deg": 18,
      "wind_gust": 9.8699999999999992,
      "feels_like": 11.82,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.0199999999999996,
      "dew_point": 7.8600000000000003,
      "pressure": 1024,
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "icon": "10d",
          "description": "light rain"
        }
      ],
      "pop": 0.94999999999999996
    },
    {
      "dt": 1648875600,
      "humidity": 69,
      "temp": 13.01,
      "uvi": 1.5600000000000001,
      "wind_deg": 14,
      "wind_gust": 9.5399999999999991,
      "feels_like": 12.17,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.0199999999999996,
      "dew_point": 7.3399999999999999,
      "pressure": 1023,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04d",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.75
    },
    {
      "dt": 1648879200,
      "humidity": 66,
      "temp": 13.27,
      "uvi": 1.29,
      "wind_deg": 14,
      "wind_gust": 10.16,
      "feels_like": 12.380000000000001,
      "clouds": 100,
      "visibility": 10000,
      "wind_speed": 5.1900000000000004,
      "dew_point": 6.9299999999999997,
      "pressure": 1022,
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "icon": "04d",
          "description": "overcast clouds"
        }
      ],
      "pop": 0.89000000000000001
    }
  ]
}
""".data(using: .utf8)!
