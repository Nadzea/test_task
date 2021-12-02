//
//  ParseManager.swift
//  weatherTestTask
//
//  Created by Надежда Клименко on 23.11.21.
//

import Foundation
import SwiftyJSON

class ParseManager {
    static let shared = ParseManager()
    
    func parseWeatherData(_ data: Data) -> WeatherData {
        var weatherData = WeatherData()
        
        guard let json = try? JSON(data: data), json["cod"].intValue == 200 else {
            weatherData.city = "City not found"
            return weatherData}
        
        let weather = json["weather"]
        
        weatherData.city = json["name"].string ?? nil
        weatherData.country = json["sys"]["country"].string ?? nil
        
        for i in weather {
            let j = i.1
            weatherData.description = j["description"].string ?? nil
            weatherData.icon = j["icon"].string ?? nil
        }
        weatherData.temp = json["main"]["temp"].double ?? nil
        weatherData.tempFeelLike = json["main"]["feels_like"].double ?? nil
        weatherData.windDeg = json["wind"]["deg"].int ?? nil
        weatherData.windSpeed = json["wind"]["speed"].float ?? nil
        
        return weatherData
    }
    
    func parseHourlyWeatherData(_ data: Data) -> [List] {
        var hourlyWeatherData: [List] = []
        
        guard let json = try? JSON(data: data), json["cod"].intValue == 200 else { return hourlyWeatherData}
        
        let massList = json["list"]
        
        for i in 0..<massList.count {
            var list = List()
            
            let weather = massList[i]["weather"]
            
            list.dt = massList[i]["dt"].int ?? nil
            
            for i in weather {
                let j = i.1
                list.icon = j["icon"].string ?? nil
            }
            list.temp = massList[i]["main"]["temp"].double ?? nil
            
            hourlyWeatherData.append(list)
        }
        
        return hourlyWeatherData
    }
    
    func parseDailyWeatherData(_ data: Data) -> [Daily] {
        var dayliWeatherData: [Daily] = []
        
        guard let json = try? JSON(data: data) else { return dayliWeatherData}
        
        let massDaily = json["daily"]
      
        for i in 0..<massDaily.count {
            var daily = Daily()
            let weather = massDaily[i]["weather"]
        
            for i in weather {
                let j = i.1
                daily.icon = j["icon"].string ?? nil
            }
            
            daily.dt = massDaily[i]["dt"].int ?? nil
            daily.dayTemp = massDaily[i]["temp"]["day"].double ?? nil
            daily.nightTemp = massDaily[i]["temp"]["night"].double ?? nil
            dayliWeatherData.append(daily)
        }
        
        return dayliWeatherData
    }
}
