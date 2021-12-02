//
//  WeatherModels.swift
//  weatherTestTask
//
//  Created by Надежда Клименко on 23.11.21.
//

import Foundation

struct WeatherData {
    var city: String? = nil
    var country: String? = nil
    var description: String? = nil
    var temp: Double? = nil
    var tempFeelLike: Double? = nil
    var icon: String? = nil
    var windDeg: Int? = nil
    var windSpeed: Float? = nil
}

struct List  {
    var dt: Int? = nil
    var icon: String? = nil
    var temp: Double? = nil
}

struct Daily {
    var dt: Int? = nil
    var icon: String? = nil
    var dayTemp: Double? = nil
    var nightTemp: Double? = nil
}

struct HourlyWeather {
    let time: String?
    let imageName: String?
    let temp: String?
}

struct DailyForecast {
    var day: String?
    let imageName: String?
    var tempDay: String
    var tempNight: String
}
