//
//  WeatherInTheCityViewController.swift
//  weatherTestTask
//
//  Created by Надежда Клименко on 25.11.21.
//

import UIKit

class WeatherInTheCityViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var buttonLabel: UILabel!
    
    var city: String = ""
    
    var weatherData = WeatherData() {
        didSet {
            DispatchQueue.main.async {
                self.updateView(self.weatherData)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonLabel.text = "backScreen_button".localized
        
        HttpManager.shared.getWeatherData(city, latitude: nil, longitude: nil) { weatherData in
            self.weatherData = weatherData
        }
    }
    
    func updateView(_ weatherData: WeatherData) {
        
        cityLabel.text = "\(weatherData.city ?? "") " + (weatherData.country ?? "")
        let language = SettingsManager.shared.currentLanguageCode
        
        if let temp = weatherData.temp {
            if language == "ru" {
                tempLabel.text = "\(Int(round(temp - 273.15)))°C"
            } else {
                tempLabel.text = "\(Int(round(1.8 * (temp - 273.15) + 32)))°F"
            }
        }
        weatherIcon.image = UIImage(named: weatherData.icon ?? "")
    }
    
    @IBAction func backScreen(_ senser: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}
