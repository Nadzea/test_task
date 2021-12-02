//
//  List_DB+CoreDataProperties.swift
//  
//
//  Created by Надежда Клименко on 30.11.21.
//
//

import Foundation
import CoreData


extension List_DB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List_DB> {
        return NSFetchRequest<List_DB>(entityName: "List_DB")
    }

    @NSManaged public var time: Int32
    @NSManaged public var imageName: String?
    @NSManaged public var temp: Double
    @NSManaged public var savedWeather_DB: SavedWeather_DB?
    
    func convert(by list: List) {
        if let time = list.dt {
            self.time = Int32(time)
        }
        self.imageName = list.icon
        if let temp = list.temp {
            self.temp = temp
        }
    }

}
