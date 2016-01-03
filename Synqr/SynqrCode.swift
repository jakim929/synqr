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
    
    var arrayForm : [String : String]?{
        if self.fname != nil{
            // OPTIONALS Might get Error
            return ["fn": fname!, "ln": lname!, "ph": phone!, "em": email!, "fb": facebook!, "sc": snapchat!, "ig": instagram!]
        }
        else
        {
            return nil
        }

    }
    
    var fullName : String? {
        if fname != "" && lname != "" {
            return fname! + " " + lname!
        }
        else
        {
            return nil
        }
    }
    
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
    
    init?(dataFromString : String){
        
        super.init()

        if let dataFromString = dataFromString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            
            if let checkField = json["check"].string{
                if (checkField == "Synqr")
                {
                    for(type, content) in json {
                        switch type {
                        case "fn" : self.fname = content.string
                        case "ln" : self.lname = content.string
                        case "ph" : self.phone = content.string
                        case "em" : self.email = content.string
                        case "fb" : self.facebook = content.string
                        case "sc" : self.snapchat = content.string
                        case "ig" : self.instagram = content.string
                        default : break
                            
                        }
                    }
                }
                else
                {
                    return nil
                }
            }
            
        }

    }
    
    // Mark: Generating QR Code
    
    func createQRCode() -> CIImage{
        
        var qrcodeImage: CIImage!
        
        // create string to store in QR code, in format of JSON object
        let jsonString = self.createJSONString()
        
        let data = jsonString.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter!.setValue(data, forKey: "inputMessage")
        filter!.setValue("Q", forKey: "inputCorrectionLevel")
        qrcodeImage = filter!.outputImage
        
        return qrcodeImage
        
    }

    func createQRCode(access : Access) -> CIImage{
        
        var qrcodeImage: CIImage!
        
        // create string to store in QR code, in format of JSON object
        let jsonString = self.createJSONString()
        
        let data = jsonString.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter!.setValue(data, forKey: "inputMessage")
        filter!.setValue("Q", forKey: "inputCorrectionLevel")
        qrcodeImage = filter!.outputImage
        
        return qrcodeImage
        
    }

    
    func createJSONString() -> String{
        
        var jsonString : String = "{"
        jsonString += "\"check\":\"Synqr\","
        
        for (key , value) in self.arrayForm! {
            jsonString += "\""
            jsonString += key
            jsonString += "\""
            jsonString += ":"
            jsonString += "\""
            jsonString += value
            jsonString += "\""
            jsonString += ","
            
        }
        jsonString.removeAtIndex(jsonString.endIndex.predecessor())
        jsonString += "}"
        
        print(jsonString)
        
        return jsonString
    }
    
    func createJSONString(access : Access) -> String{
        
        var jsonString : String = "{"
        jsonString += "\"check\":\"Synqr\","
        
        for (key , value) in self.arrayForm! {
            
            if (access.permission[key]! == true)
            {
                jsonString += "\""
                jsonString += key
                jsonString += "\""
                jsonString += ":"
                jsonString += "\""
                jsonString += value
                jsonString += "\""
                jsonString += ","
            }
            else
            {
                jsonString += "\""
                jsonString += key
                jsonString += "\""
                jsonString += ":"
                jsonString += "\""
                jsonString += ""
                jsonString += "\""
                jsonString += ","
            }

            
        }
        jsonString.removeAtIndex(jsonString.endIndex.predecessor())
        jsonString += "}"
        
        print(jsonString)
        
        return jsonString
    }
    
    
    
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

class Access{
    var accessName : String!
    var permission : [String : Bool] = ["fn" : false, "ln" : false, "ph" : false, "em" : false, "fb" : false, "sc" : false, "ig" : false]
    
    init(accessName : String, fname : Bool, lname : Bool, phone : Bool, email : Bool, facebook : Bool, snapchat : Bool, instagram : Bool)
    {
        self.accessName = accessName
        permission["fn"] = fname
        permission["ln"] = lname
        permission["ph"] = phone
        permission["em"] = email
        permission["fb"] = facebook
        permission["sc"] = snapchat
        permission["ig"] = instagram
    }
}





