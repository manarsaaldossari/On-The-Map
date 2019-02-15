//
//  User.swift
//  On The Map
//
//  Created by manar Aldossari on 07/05/1440 AH.
//  Copyright © 1440 MacBook Pro. All rights reserved.
//

import Foundation
struct User : Codable{
    var account : Account?
}
struct Account : Codable {
    var key : String?
}
