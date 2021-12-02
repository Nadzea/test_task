//
//  DailyWeatherTableViewCell.swift
//  weatherTestTask
//
//  Created by Надежда Клименко on 25.11.21.
//

import UIKit

class DailyWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempDayLabel: UILabel!
    @IBOutlet weak var tempNightLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(with dayForecast: DailyForecast) {
        dayLabel.text = dayForecast.day
        weatherImage.image = UIImage(named: dayForecast.imageName ?? "")
        tempDayLabel.text = dayForecast.tempDay
        tempNightLabel.text = dayForecast.tempNight
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dayLabel.text = ""
        weatherImage.image = nil
        tempDayLabel.text = ""
        tempNightLabel.text = ""
    }
}
