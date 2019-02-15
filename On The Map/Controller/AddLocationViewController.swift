//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by manar Aldossari on 08/05/1440 AH.
//  Copyright © 1440 MacBook Pro. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    
    //MARK: -IBOutlets
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var link: UITextField!
    
    
    //MARK: -Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- IBActions Methods
    @IBAction func findLocation(_ sender: Any) {
        if location.text == "" {
            showElert(title: "you did not Write a locstion", message: "Please enter your location")
        }
        else if link.text == "" {
            showElert(title: "you did not enter an email", message: "Please enter your link ")
        }
        else {
            geocode()
        }
    }
    
    //MARK: -geocode method
    func geocode() {
        let activityIndicator = showActivityIndicator()
        var userLocation = StudentLocation(mapString: location.text!,  mediaURL: link.text!, uniqueKey: AppDelegate.userKey)
        CLGeocoder().geocodeAddressString(userLocation.mapString!) { (placeMark, error) in
            activityIndicator.stopAnimating()
            guard let firstUserLocation = placeMark?.first?.location else {
                self.showElert(title: "can't find location ", message: "Plese enter a real location")
                return
            }
            
            userLocation.latitude = firstUserLocation.coordinate.latitude
            userLocation.longitude = firstUserLocation.coordinate.longitude
            
            
            let newLocationVC = self.storyboard!.instantiateViewController(withIdentifier: "NewLocationViewController") as! NewLocationViewController
            newLocationVC.userLocation = userLocation
            self.navigationController!.pushViewController(newLocationVC , animated: true)
        }
        
    }
}
