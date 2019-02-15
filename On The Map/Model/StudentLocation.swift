//
//  StudentLocation.swift
//  On The Map
//
//  Created by manar Aldossari on 05/05/1440 AH.
//  Copyright © 1440 MacBook Pro. All rights reserved.
//

import Foundation
struct StudentLocation : Codable{
    var createdAt :String?
    var firstName :String?
    var lastName :String?
    var latitude :Double?
    var longitude :Double?
    var mapString :String?
    var mediaURL :String?
    var objectId :String?
    var uniqueKey :String?
    var updatedAt :String?
    
    init(mapString :String ,  mediaURL :String , uniqueKey :String ) {
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.uniqueKey = uniqueKey
    }
    
}

