//
//  HourlyWeatherCollectionViewCell.swift
//  weatherTestTask
//
//  Created by Надежда Клименко on 24.11.21.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(with hourlyWeather: HourlyWeather) {
        timeLabel.text = hourlyWeather.time
        weatherIcon.image = UIImage(named: hourlyWeather.imageName ?? "")
        guard let temp = hourlyWeather.temp else { return }
        tempLabel.text = temp
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        timeLabel.text = ""
        weatherIcon.image = nil
        tempLabel.text = ""
    }

}
