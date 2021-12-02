//
//  Daily_DB+CoreDataProperties.swift
//  
//
//  Created by Надежда Клименко on 30.11.21.
//
//

import Foundation
import CoreData


extension Daily_DB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Daily_DB> {
        return NSFetchRequest<Daily_DB>(entityName: "Daily_DB")
    }

    @NSManaged public var day: Int32
    @NSManaged public var imageName: String?
    @NSManaged public var tempDay: Double
    @NSManaged public var tempNight: Double
    @NSManaged public var savedWeather_DB: SavedWeather_DB?
    
    func convert(by daily: Daily) {
        if let time = daily.dt {
            self.day = Int32(time)
        }
        self.imageName = daily.icon
        if let tempDay = daily.dayTemp {
            self.tempDay = tempDay
        }
        if let tempNight = daily.nightTemp {
            self.tempNight = tempNight
        }
    }

}
