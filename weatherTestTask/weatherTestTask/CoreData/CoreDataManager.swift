//
//  CoreDataManager.swift
//  weatherTestTask
//
//  Created by Надежда Клименко on 29.11.21.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SavedWeather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("SAVED")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveWeather(by savedWeather: SavedWeather) {
        let savedWeatherDB = SavedWeather_DB(context: persistentContainer.viewContext)
        savedWeatherDB.dateOfRequest = savedWeather.date
        let weatherData = WeatherData_DB(context: persistentContainer.viewContext)
        weatherData.convert(by: savedWeather.weatherData)
        savedWeatherDB.weatherData_DB = weatherData
        savedWeather.hourlyWeather?.forEach { hourlyWeather in
            let hourlyWeatherDB = List_DB(context: persistentContainer.viewContext)
            hourlyWeatherDB.convert(by: hourlyWeather)
            savedWeatherDB.addToList_DB(hourlyWeatherDB)
        }
        savedWeather.dailyForecast?.forEach { dailyForecast in
            let dailyForecastDB = Daily_DB(context: persistentContainer.viewContext)
            dailyForecastDB.convert(by: dailyForecast)
            savedWeatherDB.addToDaily_DB(dailyForecastDB)
        }
        persistentContainer.viewContext.insert(savedWeatherDB)
        
        saveContext()
    }
    
    func getWeather() -> [SavedWeather] {
        var array: [SavedWeather] = []
        do {
            let weather = try persistentContainer.viewContext.fetch(SavedWeather_DB.fetchRequest())
            
            weather.forEach { value in
                guard let saveWeather = value as? SavedWeather_DB else { return }
                array.append(SavedWeather(from: saveWeather))
            }
        } catch (let e) {
            print(e)
        }
        return array
    }
    
    func deleteAllData() {

        do {
            let savedWeather = try persistentContainer.viewContext.fetch(SavedWeather_DB.fetchRequest())
            savedWeather.forEach { weather in
                persistentContainer.viewContext.delete(weather as! NSManagedObject)
                saveContext()
            }
        } catch (let e) {
            print(e)
        }
    }
}
