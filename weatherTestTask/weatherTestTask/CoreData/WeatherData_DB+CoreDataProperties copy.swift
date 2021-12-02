//
//  WeatherData_DB+CoreDataProperties.swift
//  
//
//  Created by Надежда Клименко on 30.11.21.
//
//

import Foundation
import CoreData


extension WeatherData_DB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherData_DB> {
        return NSFetchRequest<WeatherData_DB>(entityName: "WeatherData_DB")
    }

    @NSManaged public var city: String?
    @NSManaged public var descriptionWeather: String?
    @NSManaged public var temp: Double
    @NSManaged public var tempFeelLike: Double
    @NSManaged public var icon: String?
    @NSManaged public var windDeg: Int16
    @NSManaged public var country: String?
    @NSManaged public var windSpeed: Float
    @NSManaged public var savedWeather_DB: SavedWeather_DB?
    
    func convert(by weatherData: WeatherData) {
        self.city = weatherData.city
        self.country = weatherData.country
        self.descriptionWeather = weatherData.description
        if let temp = weatherData.temp {
            self.temp = temp
        }
        if let tempFeelLike = weatherData.tempFeelLike {
            self.tempFeelLike = tempFeelLike
        }
        self.icon = weatherData.icon
        if let windDeg = weatherData.windDeg {
            self.windDeg = Int16(windDeg)
        }
        if let windSpeed = weatherData.windSpeed {
            self.windSpeed = windSpeed
        }
    }

}
