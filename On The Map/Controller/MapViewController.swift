//
//  MapViewController.swift
//  On The Map
//
//  Created by manar Aldossari on 05/05/1440 AH.
//  Copyright © 1440 MacBook Pro. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController ,MKMapViewDelegate {
    
    
    //MARK: -Properties
    var mapViewDidUpdate = false
    var studentList : [StudentLocation]!{
        return AppDelegate.udacityStudent.results
    }
    
    
    //MARK: -IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    //MARK: -Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if AppDelegate.userDidAddLocation && !mapViewDidUpdate { //update the mapview if the user addLocation
            updateLocations()
            mapViewDidUpdate = true
        }
    }
    
    //MARK:- IBActions Methods
    @IBAction func refresh(_ sender: Any) {
        updateLocations()
    }
    @IBAction func addLocation(_ sender: Any) {
        let addLocationVC = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        navigationController!.pushViewController(addLocationVC, animated: true)
    }
    
    @IBAction func logOut(_ sender: Any) {
        APICalls.logOut { (error) in
            DispatchQueue.main.async {
                if error != nil {
                    self.showElert(title: "can't log out", message: "try again please")
                }
                else{
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    
    //MARK:- getLocations Method
    func getLocations(){
        APICalls.getLocations { (loaded, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self.showElert(title: "Erorr performing request", message: "There was an error performing your request")
                    return
                }
                guard let locations = self.studentList else{
                    self.showElert(title: "Erorr loading locations", message: "There was an error loading locations")
                    return
                }
                var annotations = [MKPointAnnotation] ()
                for location in self.studentList {
                    let long = CLLocationDegrees (location.longitude ?? 0)
                    let lat = CLLocationDegrees (location.latitude ?? 0)
                    
                    let coords = CLLocationCoordinate2D (latitude: lat, longitude: long)
                    let first = location.firstName ?? " "
                    let last = location.lastName ?? " "
                    let mediaURL = location.mediaURL ?? " "
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coords
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    annotations.append (annotation)
                }
                self.mapView.addAnnotations (annotations)
            }
        }
    }
    
    //MARK:- updateLocations Methods
    func updateLocations(){
        self.mapView.removeAnnotations(self.mapView.annotations)
        getLocations()
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}//End MapViewController method
