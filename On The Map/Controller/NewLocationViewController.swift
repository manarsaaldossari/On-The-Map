//
//  NewLocationViewController.swift
//  On The Map
//
//  Created by manar Aldossari on 09/05/1440 AH.
//  Copyright © 1440 MacBook Pro. All rights reserved.
//

import UIKit
import MapKit

class NewLocationViewController: UIViewController {
    
    
    //MARK: -Properties
    var userLocation : StudentLocation?
    
    //MARK: -IBOutlets
    @IBOutlet weak var fineshButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: -Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fineshButton.isEnabled = false
        prepareMapView()
    }
    
    //MARK:- IBActions Methods
    @IBAction func Finish(_ sender: Any){
        //        let update = StudentLocation()
        APICalls.postLocation(mapString: (userLocation?.mapString)! , mediaURL: (userLocation?.mediaURL)!, latitude: (userLocation?.latitude)!, longitude: (userLocation?.longitude)!){ (error) in
            DispatchQueue.main.sync {
                if error != nil {
                    self.showElert(title: "can't post your new Location", message: "please try again")
                }else{
                    self.navigationController!.popToRootViewController(animated: true)
                }
            }
        }//end complition handeler
        
    }
    
    //MARK: -prepareMapView method
    func prepareMapView(){
        guard let userLocation = userLocation else{
            self.showElert(title: "Erorr loading locations", message: "There was an error loading locations")
            return
        }
        let long = CLLocationDegrees (userLocation.longitude ?? 0)
        let lat = CLLocationDegrees (userLocation.latitude ?? 0)
        
        let coords = CLLocationCoordinate2D (latitude: lat, longitude: long)
        let first = userLocation.firstName ?? " "
        let last = userLocation.lastName ?? " "
        let mediaURL = userLocation.mediaURL ?? " "
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coords
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        fineshButton.isEnabled = true
        self.mapView.addAnnotation(annotation)
    }
    
    //MARK:- mapViewDelgate Methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin" ) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
}
