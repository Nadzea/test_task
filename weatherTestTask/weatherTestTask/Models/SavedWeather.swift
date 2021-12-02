//
//  SavedWeather.swift
//  weatherTestTask
//
//  Created by Надежда Клименко on 29.11.21.
//

import Foundation

class SavedWeather {
    var date: Date?
    var weatherData: WeatherData
    var hourlyWeather: [List]?
    var dailyForecast: [Daily]?
    
    init(date: Date, weatherData: WeatherData, hourlyWeather: [List], dailyForecast: [Daily]) {
        self.date = date
        self.weatherData = weatherData
        self.hourlyWeather = hourlyWeather
        self.dailyForecast = dailyForecast
    }
    
    init(from saveWeather: SavedWeather_DB) {
        self.date = saveWeather.dateOfRequest
        let save = saveWeather.weatherData_DB
        let weatherData = WeatherData(city: save?.city ?? "", country: save?.country ?? "", description: save?.descriptionWeather ?? "", temp: save?.temp ?? nil, tempFeelLike: save?.tempFeelLike ?? nil, icon: save?.icon ?? "", windDeg: Int(save?.windDeg ?? Int16()), windSpeed: save?.windSpeed ?? nil)
        self.weatherData = weatherData

        self.hourlyWeather = saveWeather.list_DB?.allObjects.compactMap({ value -> List in
            let value = value as! List_DB
            let hourlyWeather = List(dt: Int(value.time), icon: value.imageName, temp: value.temp)
            return hourlyWeather
        })
        self.dailyForecast = saveWeather.daily_DB?.allObjects.compactMap({ value -> Daily in
            let value = value as! Daily_DB
            let dailyforecast = Daily(dt: Int(value.day), icon: value.imageName, dayTemp: value.tempDay, nightTemp: value.tempNight)
            return dailyforecast
        })
    }
}
