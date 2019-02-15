//
//  MyAppViewControllers.swift
//  On The Map
//
//  Created by manar Aldossari on 07/05/1440 AH.
//  Copyright © 1440 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension UIViewController{
    func showElert(title : String ,message : String ){
        var alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction( action )
        self.present(alert, animated: true, completion: nil)
    }
    
    func showActivityIndicator() -> UIActivityIndicatorView {
            let activityIndicator = UIActivityIndicatorView(style: .white)
            self.view.addSubview(activityIndicator)
            self.view.bringSubviewToFront(activityIndicator)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.center = self.view.center
            activityIndicator.startAnimating()
            return activityIndicator
    }
}

    
extension UIViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
