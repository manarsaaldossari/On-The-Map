//
//  APICalls.swift
//  On The Map
//
//  Created by manar Aldossari on 07/05/1440 AH.
//  Copyright © 1440 MacBook Pro. All rights reserved.
//

import Foundation
class APICalls{

        //MARK: -logIn METHOD
        //return(userKey , the error)
        //userKey != ""
        //error != nil (Bad Conniction)
        //userKey == "" && error==nil (incorrect email or passwird)
       static func logIn(username:String , password:String , completion: @escaping ( String,Error?)->()){
            var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody  = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
            //print (String(data: request.httpBody!, encoding: .utf8))
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                   completion("",error)
                }
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                if let statusCode = statusCode{
                    if statusCode < 200  || statusCode > 300 {
                        completion("",nil)
                    }
                    else{
                        let range = Range(5..<data!.count)
                        let newData = data?.subdata(in: range)
                        let decoder = JSONDecoder()
                        do{
                            let studentArray = try decoder.decode(User.self, from: newData!)
                            let studentKey = studentArray.account?.key  as! String
                            completion(studentKey,nil)
                        }catch let error{
                            print (error)
                        }
                    }
                }
                else{
                   completion("No response",nil)
                }
                
                    
                
                    
            }
            task.resume()
          
            
        }
    
    //MARK: -getLocations
    static func getLocations (completion: @escaping (Bool, Error?) -> ()) {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
              completion(false,error)
            }
            do{
                let decoder = JSONDecoder()
                let studentArray = try decoder.decode(StudentsLocations.self, from: data!)
                DispatchQueue.main.async {
                    AppDelegate.udacityStudent = studentArray
                    completion(true,error)
                }
            }catch let error {
                print (error)
            }
        }
        task.resume()
    
}
    //MARK: -logOut method
    static func logOut(completion: @escaping (Error?) -> ()){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(error)
            }
//            let range = Range(5..<data!.count)
//            let newData = data?.subdata(in: range) /* subset response data! */
//            print(String(data: newData!, encoding: .utf8)!)
            completion(nil)
        }
        task.resume()
    }
    
    //MARK: -postLocation Method
    static func postLocation(mapString : String ,mediaURL : String ,latitude : Double ,longitude: Double,completion: @escaping (Error?) -> ()){
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"uniqueKey\": \"\(AppDelegate.userKey)\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(error)
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            completion(nil)
        }
        task.resume()
    }

}

