//
//  Constants.swift
//  Synqr
//
//  Created by James Kim on 12/26/15.
//  Copyright © 2015 James Kim. All rights reserved.
//

import Foundation

enum Handle : String {
    
    case firstName = "fname"
    case lastName = "lname"
    case phone = "phone"
    case email = "email"
    case facebook = "facebook"
    case snapchat = "snapchat"
    case instagram = "instagram"
    
    static let allValues = [firstName, lastName, phone, email, facebook, snapchat, instagram]
    static let contact = [firstName, lastName, phone, email, facebook]
    static let socialMedia = [facebook, snapchat, instagram]
    
}

func handleName (type : Handle)->String{
    switch type {
    case .firstName : return "First Name"
    case .lastName : return "Last Name"
    case .phone : return "Phone"
    case .email : return "Email"
    case .facebook : return "Facebook"
    case .snapchat : return "Snapchat"
    case .instagram : return "Instagram"

        
    }
}

func rowToHandle (row : Int)->Handle{
    return Handle.allValues[row]
}
