//
//  WeatherViewController.swift
//  weatherTestTask
//
//  Created by Надежда Клименко on 23.11.21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var weatherView: WeatherView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var buttonLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    lazy var viewModel: ViewModel = {
        return ViewModel.init(view: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.placeholder = "textField_placeholder".localized
        buttonLabel.text = "backScreen_button".localized
        startLocationManager()
        updateView()
    }
    
    func startLocationManager() {
       
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func updateView() {
        
        viewModel.didUpdateViewData = { viewData in
            
            self.weatherView.viewData = viewData
        }
    }
    
    func presentWeatherInfoScreen() {
        guard NetworkManager.shared.isConnectedToNetwork() else {
            presentAlertController(with: nil, message: "erroLlabel_text2".localized)
            return
        }
        guard let cityName = textField.text, !cityName.isEmpty else {
            presentAlertController(with: nil, message: "errorLabel_text".localized)
            return
        }
        
        let storyboard = UIStoryboard(name: "WeatherInTheCityViewController", bundle: nil)
        
        guard let vc = storyboard.instantiateInitialViewController() as? WeatherInTheCityViewController else { return }

        vc.city = cityName
        
        textField.text = ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.first) != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        presentWeatherInfoScreen()
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        guard !string.isEmpty else {return true}
        let newString = string.uppercased()
    
        switch newString {
        case "A" ... "Z":
            return true
        default:
            return false
        }
    }
    
    @IBAction func presentWeatherScreen(_ sender: Any) {
        presentWeatherInfoScreen()
    }
    
    @IBAction func backScreen(_ senser: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        
        if NetworkManager.shared.isConnectedToNetwork() {
            viewModel.getData(city: nil, latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        } else {
            let message = viewModel.giveSavedData()
            presentAlertController(with: nil, message: message)
        }
        manager.stopUpdatingLocation()
        manager.delegate = nil
    }
}

