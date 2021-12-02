//
//  MainViewController.swift
//  weatherTestTask
//
//  Created by Надежда Клименко on 24.11.21.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var goButton: UIButton!
    
    let lCode: [String] = ["en", "ru"]

    let locationManager = CLLocationManager()
    var currentLanguage: Language = .english {
        didSet {
            switch self.currentLanguage {
            case .english: SettingsManager.shared.currentLanguageCode = "en"
            case .russian: SettingsManager.shared.currentLanguageCode = "ru"
            }
            localized()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let indexCode = lCode.firstIndex(of: SettingsManager.shared.currentLanguageCode) {
            segmentedControl.selectedSegmentIndex = indexCode
            currentLanguage = Language(rawValue: indexCode) ?? .english
        }

        locationManager.requestWhenInUseAuthorization()
    }
    
    func presentViewController() {
        let storyboard = UIStoryboard(name: "WeatherViewController", bundle: nil)
        
        guard let vc = storyboard.instantiateInitialViewController() as? WeatherViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showSettingsAlert() {
        presentAlertController(with: nil,
                               message: "alert_message".localized,
                               actions: UIAlertAction(title: "title_alert_action".localized, style: .default,
                                                      handler: { _ in
                                                        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                                                        if UIApplication.shared.canOpenURL(url) {
                                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)}}))
    }
    
    func localized() {
        goButton.setTitle("go_button_text".localized, for: .normal)
    }
    
    @IBAction func nextScreen(_ sender: Any) {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            presentViewController()
        case .denied, .restricted:
            showSettingsAlert()
        default: break
        }
    }
    
    @IBAction func selectedLanguage(_ sender: UISegmentedControl) {
        guard let selectedLanguade = Language(rawValue: sender.selectedSegmentIndex), selectedLanguade != currentLanguage else { return }
        currentLanguage = selectedLanguade
    }
}
