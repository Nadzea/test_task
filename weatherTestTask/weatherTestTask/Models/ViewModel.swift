//
//  ViewModel.swift
//  weatherTestTask
//
//  Created by Надежда Клименко on 23.11.21.
//

import Foundation

protocol ViewModelProtocol: AnyObject {
    var didUpdateViewData: ((ViewData) -> ())? { get set }
    func getData(city: String?, latitude: Double?, longitude: Double?)
}

class ViewModel: ViewModelProtocol {
    var cityName: String = ""
    var temperature: String = ""
    var weatherIcon: String = ""
    var descriptionLabel: String = ""
    var feelLikesLabel: String = ""
    var windLabel: String = ""
    
    public var didUpdateViewData: ((ViewData) -> ())?
    
    init(cityName: String, temperature: String, weatherIcon: String, descriptionLabel: String, feelLikesLabel: String, windLabel: String) {
        self.cityName = cityName
        self.temperature = temperature
        self.weatherIcon = weatherIcon
        self.descriptionLabel = descriptionLabel
        self.feelLikesLabel = feelLikesLabel
        self.windLabel = windLabel
    }
    
    private var model = WeatherData()
    private var hourlyForecast: [List] = []
    private var dailyForecast: [Daily] = []
    
    init() {
        didUpdateViewData?(.initial)
    }
    
    weak private var viewMyLocation: WeatherViewController?
    
    deinit {
        didUpdateViewData = nil
    }
    
    init(view: WeatherViewController) {
        self.viewMyLocation = view
    }
    
    func getData(city: String?, latitude: Double?, longitude: Double? ) {
        
        let group = DispatchGroup()
        
        group.enter()
        HttpManager.shared.getWeatherData(city, latitude: latitude, longitude: longitude) { weatherData in
            self.model = weatherData
            group.leave()
        }
        
        group.enter()
        HttpManager.shared.getWeatherDataFofFiveDays(latitude, longitude: longitude) { hourlyWeather in
            self.hourlyForecast = hourlyWeather
            group.leave()
        }
        
        group.enter()
        HttpManager.shared.getWeatherDataForSevenDays(latitude, longitude: longitude) { dailyWeather in
            self.dailyForecast = dailyWeather
            group.leave()
        }
        
        group.notify(queue: .main) {

            CoreDataManager.shared.deleteAllData()
            let date = Date()
            let saveWeather = SavedWeather(date: date, weatherData: self.model, hourlyWeather: self.hourlyForecast, dailyForecast: self.dailyForecast)
            CoreDataManager.shared.saveWeather(by: saveWeather)
            
            self.didUpdateViewData?(.success(self.giveData(model: self.model), self.updateForecast(weatherData: self.model, hourlyWeather: self.hourlyForecast), self.updateForecastForSevenDays(dailyWeather: self.dailyForecast)))
        }
    }
    
    func giveData(model: WeatherData) -> ViewModel {
        let viewModel = ViewModel()
        viewModel.cityName = "\(model.city ?? "")" + " \(model.country ?? "")"
        let language = SettingsManager.shared.currentLanguageCode
        if let temp = model.temp {
            viewModel.temperature = temperature(language: language, temperature: temp)
        }
       
        if let feelTemp = model.tempFeelLike {
            viewModel.feelLikesLabel = "feelLikeTemp_label".localized + " \(temperature(language: language, temperature: feelTemp))"
        }
        viewModel.weatherIcon = model.icon ?? ""
        viewModel.descriptionLabel = model.description ?? ""
        
        viewModel.windLabel = model.windDeg?.typeOfWind() ?? ""
        
        if let speedWind = model.windSpeed {
            viewModel.windLabel += "\(speedWind)" + "unit_of_measure".localized
        }
        
        return viewModel
    }
    
    func giveSavedData() -> String {
        let savedData = CoreDataManager.shared.getWeather()
        let nowDate = Date()
        let saveDate = savedData[0].date
        var warningText: String = "warningText".localized
        if let saveData = saveDate {
            let difference = Int(nowDate.timeIntervalSince1970 - saveData.timeIntervalSince1970)
            let hours = difference / 3600
            
            if hours < 1 {
                warningText += "\(difference / 60) "
                warningText += difference / 60 == 1 ? "warningText_minute".localized : "warningText_minutes".localized
            }
            if hours >= 1, hours < 24 {
                warningText += "\(hours) "
                warningText += hours == 1 ? "warningText_hour".localized : "warningText_hours".localized
            }
            if hours >= 24 {
                warningText += "\(difference / 86400) "
                warningText += difference / 86400 == 1 ? "warningText_day".localized : "warningText_days".localized
            }
        }
        didUpdateViewData?(.failure(giveData(model: savedData[0].weatherData), updateForecast(weatherData: savedData[0].weatherData, hourlyWeather: savedData[0].hourlyWeather ?? []), updateForecastForSevenDays(dailyWeather: savedData[0].dailyForecast ?? [])))
        return warningText
    }
    
    func updateForecast(weatherData: WeatherData, hourlyWeather: [List]) -> [HourlyWeather] {
    
        let dateFormater = DateFormatter()
        var dataSource: [HourlyWeather] = []
        let language = SettingsManager.shared.currentLanguageCode
        if let temp = weatherData.temp {
            let tempC = temperature(language: language, temperature: temp)
            let icon = weatherData.icon ?? ""
            let hourlyWeather = HourlyWeather(time: "now_time".localized, imageName: icon, temp: tempC)
            dataSource.append(hourlyWeather)
        }
        
        for i in 0..<hourlyWeather.count {
            
            guard let currentTime = hourlyWeather[i].dt else { return dataSource}
            
            if i > 0, i % 2 != 0 {
                let nextTime = Date(timeIntervalSince1970: TimeInterval(currentTime))
                dateFormater.dateFormat = "HH:mm"
                let time = dateFormater.string(from: nextTime)
                
                var tempC: String = ""
                
                if let temp = hourlyWeather[i].temp {
                    tempC = temperature(language: language, temperature: temp)
                }
                let icon = hourlyWeather[i].icon ?? ""

                let hourlyWeather = HourlyWeather(time: time, imageName: icon, temp: tempC)
                dataSource.append(hourlyWeather)
            }
        }
        
        return dataSource
    }
    
    func updateForecastForSevenDays(dailyWeather: [Daily]) -> [DailyForecast] {
        var dataSource: [DailyForecast] = []
        let language = SettingsManager.shared.currentLanguageCode
        for i in 0..<dailyWeather.count {
            
            guard i > 0, let day = dailyWeather[i].dt, let tempD = dailyWeather[i].dayTemp, let tempN = dailyWeather[i].nightTemp else { continue }
            
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "EEEE"
            if language == "ru" {
                dateFormater.locale = NSLocale(localeIdentifier: "ru") as Locale
            }
            
            let date = Date(timeIntervalSince1970: TimeInterval(day))
            let dayOfWeek = dateFormater.string(from: date).capitalized
            
            let icon = dailyWeather[i].icon ?? ""

            let tempDay = temperature(language: language, temperature: tempD)
            let tempNight = temperature(language: language, temperature: tempN)
            
            let oneDayForecast = DailyForecast(day: dayOfWeek, imageName: icon, tempDay: tempDay, tempNight: tempNight)
            dataSource.append(oneDayForecast)
            
        }
        return dataSource
    }
    
    func temperature(language: String, temperature: Double) -> String {
        var tempC: String = ""
        if language == "ru" {
            tempC = "\(Int(round(temperature - 273.15)))°C"
        } else {
            tempC = "\(Int(round(1.8 * (temperature - 273.15) + 32)))°F"
        }
        return tempC
    }
}

