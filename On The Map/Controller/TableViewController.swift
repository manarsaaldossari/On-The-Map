//
//  TableViewController.swift
//  On The Map
//
//  Created by manar Aldossari on 05/05/1440 AH.
//  Copyright © 1440 MacBook Pro. All rights reserved.
//

import UIKit

class TableViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    
    
    //MARK: -Properties
    var tabelViewDidUpdate = false
    var studentList : [StudentLocation]!{
        return AppDelegate.udacityStudent.results
    }
    
    
    //MARK: -IBOutlets
    @IBOutlet weak var studentTable: UITableView!
    
    
    //MARK: -Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocations()
    }
    override func viewWillAppear(_ animated: Bool) { //update the mapview if the user addLocation
        super.viewWillAppear(true)
        if(AppDelegate.userDidAddLocation && !tabelViewDidUpdate){
            getLocations()
            tabelViewDidUpdate = true
        }
    }
    
    
    //MARK:- IBActions Methods
    @IBAction func refresh(_ sender: Any) {
        getLocations()
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
                self.studentTable.reloadData()
                self.studentTable.endUpdates()
            }
        }
    }
    
    
    //MARK: -UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = studentList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "student info")
        cell?.textLabel?.text = "\(student.firstName ?? " " ) \(student.lastName ?? " ")"
        cell?.detailTextLabel?.text = student.mediaURL
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = studentList[indexPath.row]
        
        if let link = URL(string: cell.mediaURL! ) {
            UIApplication.shared.open(link, options: [:], completionHandler: nil)
        }
    }
    
}//End TableViewController class


