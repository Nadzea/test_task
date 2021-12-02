//
//  HttpManager.swift
//  weatherTestTask
//
//  Created by Надежда Клименко on 23.11.21.
//

import Foundation
import Alamofire

class HttpManager {
    static let shared = HttpManager()
    
    func getWeatherData(_ city: String?, latitude: Double?, longitude: Double?, onCompletion: @escaping (WeatherData) -> Void) {
        
        var url: String = ""
        if let city = city {
            url = APIConstant.getURLWeatherData(city: city)
        }
        if let latitude = latitude, let longitude = longitude {
            url = APIConstant.getURLWeatherDataWithCoordinate(latitude: latitude, longitude: longitude)
        }
        
        AF.request(url, method: .get).response(queue: DispatchQueue.global(qos: .userInteractive)) { response in
            
            guard let data = response.data else { return }
            onCompletion(ParseManager.shared.parseWeatherData(data))
        }
    }
    
    func getWeatherDataFofFiveDays(_ latitude: Double?, longitude: Double?, onCompletion: @escaping ([List]) -> Void) {
        
        var url: String = ""
        if let latitude = latitude, let longitude = longitude {
            url = APIConstant.getURLhourlyWeatherWithCoordinate(latitude: latitude, longitude: longitude)
        }
        
        AF.request(url, method: .get).response(queue: DispatchQueue.global(qos: .userInteractive)) { response in
            
            guard let data = response.data else { return }
            onCompletion(ParseManager.shared.parseHourlyWeatherData(data))
        }
    }
    
    func getWeatherDataForSevenDays(_ latitude: Double?, longitude: Double?, onCompletion: @escaping ([Daily]) -> Void) {
        guard let latitude = latitude, let longitude = longitude else { return }
        let urlForSevenDays = APIConstant.getURLWeatherDataForSevenDays(latitude: latitude, longitude: longitude)
        
        AF.request(urlForSevenDays, method: .get).response(queue: DispatchQueue.global(qos: .userInteractive)) { response in
            
            guard let data = response.data else { return }
            onCompletion(ParseManager.shared.parseDailyWeatherData(data))
        }
    }
}
