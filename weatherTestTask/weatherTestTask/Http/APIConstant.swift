//
//  APIConstant.swift
//  weatherTestTask
//
//  Created by Надежда Клименко on 26.11.21.
//

import Foundation
enum APIConstant: String {
    case hourlyWeatherWithCoordinate = "https://api.openweathermap.org/data/2.5/forecast?lat=%@&lon=%@&appid=bb3af6a661e716dc3b3bfab4c1c87d6c"
    case weatherDataForSevenDays = "https://api.openweathermap.org/data/2.5/onecall?lat=%@&lon=%@&exclude=current,minutely,hourly,alerts&appid=bb3af6a661e716dc3b3bfab4c1c87d6c"
    
    static func getURLWeatherData(city: String) -> String {
        return String(format: "URL_weatherData_by_city".localized, city)
    }
    
    static func getURLWeatherDataWithCoordinate(latitude: Double, longitude: Double) -> String {
        return String(format: "URL_weatherData_with_coordinate".localized, String(latitude), String(longitude))
    }
    
    static func getURLhourlyWeatherWithCoordinate(latitude: Double, longitude: Double) -> String {
        return String(format: APIConstant.hourlyWeatherWithCoordinate.rawValue, String(latitude), String(longitude))
    }
    
    static func getURLWeatherDataForSevenDays(latitude: Double, longitude: Double) -> String {
        return String(format: APIConstant.weatherDataForSevenDays.rawValue, String(latitude), String(longitude))
    }
}
