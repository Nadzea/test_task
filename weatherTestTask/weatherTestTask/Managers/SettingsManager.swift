//
//  SettingsManager.swift
//  weatherTestTask
//
//  Created by Надежда Клименко on 27.11.21.
//

import Foundation

class SettingsManager {
    static let shared = SettingsManager()
    
    var currentLanguageCode: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: KeysUserDefaults.languageCode.rawValue)
        }
        get {
            return UserDefaults.standard.string(forKey: KeysUserDefaults.languageCode.rawValue) ?? "en"
        }
    }
}
