//
//  SynqrCode.swift
//  Synqr
//
//  Created by James Kim on 12/23/15.
//  Copyright © 2015 James Kim. All rights reserved.
//

import Foundation

struct PropertyKey {
    static let firstNameKey = "fname"
    static let lastNameKey = "lname"
    static let phoneKey = "phone"
    static let emailKey = "email"
    static let fbKey = "facebook"
    static let snapchatKey = "snapchat"
    static let instagramKey = "instagram"
}

class SynqrCode : NSObject, NSCoding {
    
    var fname : String?
    var lname : String?
    var phone : String?
    var email : String?
    var facebook : String?
    var snapchat : String?
    var instagram : String?
    
    override init(){
        
    }
    
    init?(fname: String?, lname: String?, phone: String?, email: String?, facebook: String?, snapchat: String?, instagram : String?){
        self.fname = fname
        self.lname = lname
        self.phone = phone
        self.email = email
        self.facebook = facebook
        self.snapchat = snapchat
        self.instagram = instagram
        
        super.init()
    }
    
    // Mark: Generating QR Code
    
    
    
    // Mark: Convenient Accessors/Setters Using Handle Enum
    
    func returnValue(type : Handle)->String?{
        
        switch type{
            
        case .firstName: return self.fname
        case .lastName: return self.lname
        case .phone: return self.phone
        case .email: return self.email
        case .facebook: return self.facebook
        case .snapchat: return self.snapchat
        case .instagram: return self.instagram
            
        }
    }
    
    func addValue(type : Handle, value : String){
        switch type{
        case .firstName:  self.fname = value; break
        case .lastName:  self.lname = value; break
        case .phone:  self.phone = value; break
        case .email:  self.email = value; break
        case .facebook:  self.facebook = value; break
        case .snapchat:  self.snapchat = value; break
        case .instagram:  self.instagram = value; break
        }
    }
    
    func returnArray()->[String]{
        return [unwrap(fname), unwrap(lname), unwrap(phone), unwrap(email), unwrap(facebook), unwrap(snapchat), unwrap(instagram)]
    }
    
    // Mark: Convenient functions
    
    func unwrap(s: String?) -> String{
        if let value = s {
            return value
        }
        else
        {
            return ""
        }
    }
    
    // Mark: NSCoding
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(fname, forKey: PropertyKey.firstNameKey)
        aCoder.encodeObject(lname, forKey: PropertyKey.lastNameKey)
        aCoder.encodeObject(phone, forKey: PropertyKey.phoneKey)
        aCoder.encodeObject(email, forKey: PropertyKey.emailKey)
        aCoder.encodeObject(facebook, forKey: PropertyKey.fbKey)
        aCoder.encodeObject(snapchat, forKey: PropertyKey.snapchatKey)
        aCoder.encodeObject(instagram, forKey: PropertyKey.instagramKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        let fname = aDecoder.decodeObjectForKey(PropertyKey.firstNameKey) as? String
        let lname = aDecoder.decodeObjectForKey(PropertyKey.lastNameKey) as? String
        let phone = aDecoder.decodeObjectForKey(PropertyKey.phoneKey) as? String
        let email = aDecoder.decodeObjectForKey(PropertyKey.emailKey) as? String
        let facebook = aDecoder.decodeObjectForKey(PropertyKey.fbKey) as? String
        let snapchat = aDecoder.decodeObjectForKey(PropertyKey.snapchatKey) as? String
        let instagram = aDecoder.decodeObjectForKey(PropertyKey.instagramKey) as? String
        
        self.init(fname: fname, lname: lname, phone: phone, email: email, facebook: facebook, snapchat: snapchat, instagram: instagram)
        
    }
    
    
    // Mark: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("synqrCode")
    
    
    
    
    
    
}