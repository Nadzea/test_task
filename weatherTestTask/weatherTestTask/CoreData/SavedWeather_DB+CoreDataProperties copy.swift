//
//  SavedWeather_DB+CoreDataProperties.swift
//  
//
//  Created by Надежда Клименко on 30.11.21.
//
//

import Foundation
import CoreData


extension SavedWeather_DB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedWeather_DB> {
        return NSFetchRequest<SavedWeather_DB>(entityName: "SavedWeather_DB")
    }

    @NSManaged public var dateOfRequest: Date?
    @NSManaged public var weatherData_DB: WeatherData_DB?
    @NSManaged public var list_DB: NSSet?
    @NSManaged public var daily_DB: NSSet?

}

// MARK: Generated accessors for list_DB
extension SavedWeather_DB {

    @objc(addList_DBObject:)
    @NSManaged public func addToList_DB(_ value: List_DB)

    @objc(removeList_DBObject:)
    @NSManaged public func removeFromList_DB(_ value: List_DB)

    @objc(addList_DB:)
    @NSManaged public func addToList_DB(_ values: NSSet)

    @objc(removeList_DB:)
    @NSManaged public func removeFromList_DB(_ values: NSSet)

}

// MARK: Generated accessors for daily_DB
extension SavedWeather_DB {

    @objc(addDaily_DBObject:)
    @NSManaged public func addToDaily_DB(_ value: Daily_DB)

    @objc(removeDaily_DBObject:)
    @NSManaged public func removeFromDaily_DB(_ value: Daily_DB)

    @objc(addDaily_DB:)
    @NSManaged public func addToDaily_DB(_ values: NSSet)

    @objc(removeDaily_DB:)
    @NSManaged public func removeFromDaily_DB(_ values: NSSet)

}
