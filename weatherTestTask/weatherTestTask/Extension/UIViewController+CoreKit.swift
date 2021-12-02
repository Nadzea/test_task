//
//  UIViewController+CoreKit.swift
//  weatherTestTask
//
//  Created by Надежда Клименко on 27.11.21.
//

import UIKit

extension UIViewController {
    
    @discardableResult
    func presentAlertController(with title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert, actions: UIAlertAction...) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        let cancel = UIAlertAction(title: "alert_cancel_button".localized, style: .cancel)
        
        actions.forEach { alert.addAction($0) }
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
        return alert
    }
}
