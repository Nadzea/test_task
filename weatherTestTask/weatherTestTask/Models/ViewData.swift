//
//  ViewData.swift
//  weatherTestTask
//
//  Created by Надежда Клименко on 26.11.21.
//

import Foundation

enum ViewData {
    case initial
    case success(ViewModel, [HourlyWeather], [DailyForecast])
    case failure(ViewModel, [HourlyWeather], [DailyForecast])
}
