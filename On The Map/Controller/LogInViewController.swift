//
//  LogInViewController.swift
//  On The Map
//
//  Created by manar Aldossari on 03/05/1440 AH.
//  Copyright © 1440 MacBook Pro. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    //MARK: -IBOutlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //MARK: -Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailField.text = ""
        passwordField.text = ""
    }
    
    //MARK:- IBActions Methods
    @IBAction func logIn(_ sender: Any) {
        let activityIndicator = showActivityIndicator()
        if (emailField.text?.isEmpty)! || (passwordField.text?.isEmpty)! {
            showElert(title: "Can't log in", message: "Messing email or passwird")
            activityIndicator.stopAnimating()
        }
        else{
            APICalls.logIn(username: emailField.text! , password: passwordField.text!) { (key, error) in
                DispatchQueue.main.sync{
                    activityIndicator.stopAnimating()
                    if (error != nil){
                        self.showElert(title: "Bad Conniction", message: "Please try again")
                    }
                    else if (error == nil && key == ""){
                        self.showElert(title: "incorrect email or passwird", message: "Please try again")
                    }
                    else if key == "No response"{
                        self.showElert(title: "Can't get a response", message: "Please try again")
                    }
                    else{//(key != "" )
                        AppDelegate.userKey = key
                        self.performSegue(withIdentifier: "tab bar", sender: self)
                    }
                }
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        if let link = URL(string: "https://auth.udacity.com/sign-up"){
            UIApplication.shared.open(link, options: [:], completionHandler: nil)
        }
        else{
            showElert(title: "Sorry", message: "Can't disspay the sign Up page ")
        }
    }
}//End LogInViewController class
