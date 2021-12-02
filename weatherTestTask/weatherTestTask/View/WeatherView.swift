//
//  WeatherView.swift
//  weatherTestTask
//
//  Created by Надежда Клименко on 23.11.21.
//

import UIKit
import NVActivityIndicatorView

class WeatherView: UIView {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feelLikesAndWindLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var conteinerView: UIView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewData: ViewData = .initial {
        didSet {
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    var dataSource: [HourlyWeather] = []
    var dataSourseForTable: [DailyForecast] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        Bundle(for: WeatherView.self).loadNibNamed("WeatherView", owner: self, options: nil)
        conteinerView.frame = self.bounds
        self.addSubview(conteinerView)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func updateView() {
        
        switch viewData {
        case .initial:
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        case .success(let viewModel, let dataSourse, let dataSourseForTable):
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            update(viewModel: viewModel)
            self.dataSource = dataSourse
            self.dataSourseForTable = dataSourseForTable
            setupCollectionView()
            setupTableView()
        case .failure(let viewModel, let dataSourse, let dataSourseForTable):
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            update(viewModel: viewModel)
            self.dataSource = dataSourse
            self.dataSourseForTable = dataSourseForTable
            setupCollectionView()
            setupTableView()
        }
    }
    
    private func update(viewModel: ViewModel) {
        cityName.text = viewModel.cityName
        descriptionLabel.text = viewModel.descriptionLabel
        temperature.text = viewModel.temperature
        feelLikesAndWindLabel.text = "\(viewModel.feelLikesLabel), " + viewModel.windLabel
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "HourlyWeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HourlyWeatherCollectionViewCell")
        if !dataSource.isEmpty {
            collectionView.layer.cornerRadius = 30
            collectionView.backgroundColor = .placeholderText
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "DailyWeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "DailyWeatherTableViewCell")
        tableView.tableFooterView = UIView()
    }
}

extension WeatherView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherCollectionViewCell", for: indexPath) as? HourlyWeatherCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setData(with: dataSource[indexPath.item])
        
        return cell
    }
}

extension WeatherView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 100)
    }
}

extension WeatherView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSourseForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyWeatherTableViewCell") as? DailyWeatherTableViewCell else { return UITableViewCell()}
    
        cell.setData(with: dataSourseForTable[indexPath.row])
        
        return cell
    }
}

extension WeatherView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}




