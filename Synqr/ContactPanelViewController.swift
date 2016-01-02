//
//  ContactPanelViewController.swift
//  Synqr
//
//  Created by James Kim on 12/23/15.
//  Copyright © 2015 James Kim. All rights reserved.
//

import Foundation
import UIKit
import Contacts


class ContactPanelViewController: UIViewController
{
    var synqrCode : SynqrCode?
    
    @IBOutlet weak var contactInfo: UILabel!
    @IBOutlet weak var userPicture: UIImageView!
    
    @IBAction func returnButton(sender: UIButton) {
        
    }
    
    // various buttons to add user
    @IBAction func addToContact(sender: UIButton) {
        // request access to contacts
        AppDelegate.getAppDelegate().requestForAccess { (accessGranted) -> Void in
            if accessGranted {
                self.createContact()
                
            }
        }
    }
    @IBAction func addSnapchat(sender: AnyObject) {
        addToSnapchat(synqrCode!.snapchat!)
    }
    
    @IBAction func addFacebook(sender: UIButton) {
        addFBFriend(synqrCode!.facebook!)
    }
    
    @IBAction func addInstagram(sender: UIButton) {
        addToInstagram(synqrCode!.instagram!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //contactDetail = ["check":"Synqr","snapchat":"james_wookim","phone":"8573008238","lname":"Kim","instagram":"","email":"sunwookim@college.harvard.edu","facebook":"10207065588413634","fname":"James"]
        
        self.contactInfo.text = synqrCode!.fullName
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        getProfilePicture(synqrCode!.facebook!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // creates new contact based on name, email, and phone number read from QR code
    func createContact() {
        
        // prepare contact information fields
        let newContact = CNMutableContact()
        newContact.givenName = synqrCode!.fname!
        newContact.familyName = synqrCode!.lname!
        
        newContact.phoneNumbers = [CNLabeledValue(label:CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: synqrCode!.phone!))]
        
        let homeEmail = CNLabeledValue(label: CNLabelHome, value: synqrCode!.email!)
        newContact.emailAddresses = [homeEmail]
        
        // alert user
        AppDelegate.getAppDelegate().showMessage("Create new CNMutableContact Succeeded")
        
        // save contact to phone
        do {
            let saveRequest = CNSaveRequest()
            saveRequest.addContact(newContact, toContainerWithIdentifier: nil)
            try AppDelegate.getAppDelegate().contactStore.executeSaveRequest(saveRequest)
            
            navigationController?.popViewControllerAnimated(true)
        }
            // otherwise alert error
        catch {
            AppDelegate.getAppDelegate().showMessage("Unable to save the new contact.")
        }
        
    }
    
    
    
    // adds user to facebook by opening facebook app
    func addFBFriend(fbID : String){
        
        let fbAccess = "fb://profile/" + fbID
        
        if let fbURL = NSURL(string: fbAccess)
        {
            if UIApplication.sharedApplication().canOpenURL(fbURL)
            {
                UIApplication.sharedApplication().openURL(fbURL)
                
            } else {
                //redirect to safari because the user doesn't have Facebook
                UIApplication.sharedApplication().openURL(NSURL(string: "http://facebook.com/" + fbID)!)
            }
        }
    }
    
    func addToInstagram(instaID : String){
        
        let instaAccess = "instagram://user?username=" + instaID
        
        if let instaURL = NSURL(string: instaAccess)
        {
            if UIApplication.sharedApplication().canOpenURL(instaURL)
            {
                UIApplication.sharedApplication().openURL(instaURL)
                
            } else {
                //redirect to safari because the user doesn't have Instagram
                UIApplication.sharedApplication().openURL(NSURL(string: "http://instagram.com/user?username=" + instaID)!)
            }
        }
        
    }
    
    // adds user to Snapchat by copying handle to clipboard and opening app
    func addToSnapchat(snapchatID : String){
        
        let snapchatAccess = "ha://?u=" + snapchatID
        
        if let snapchatURL = NSURL(string: snapchatAccess)
        {
            if UIApplication.sharedApplication().canOpenURL(snapchatURL)
            {
                // copy handle to clipboard
                UIPasteboard.generalPasteboard().string = snapchatID
                // alert user that handle is copied
                AppDelegate.getAppDelegate().showMessage("Snapchat handle copied to clipboard")
                
                // open Snapchat
                UIApplication.sharedApplication().openURL(snapchatURL)
                
            } else {
                //redirect to safari because the user doesn't have Snapchat
                UIApplication.sharedApplication().openURL(NSURL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")!)
            }
        }
    }
    
    /*
    func getProfilePicture(fbUserID : String) -> String {
        
        let pictureURL = "https://graph.facebook.com/\(fbUserID)/picture?type=large&return_ssl_resources=1"
        
        var URLRequest = NSURL(string: pictureURL)
        var URLRequestNeeded = NSURLRequest(URL: URLRequest!)
        
        NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse,data: NSData, error: NSError) -> Void in
            if error == nil {
                var picture = PFFile(data: data)
                PFUser.currentUser().setObject(picture, forKey: "profilePicture")
                PFUser.currentUser().saveInBackground()
            }
            else {
                print("Error: \(error.localizedDescription)")
            }
        })
        
        let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
        pictureRequest.startWithCompletionHandler({
            (connection, result, error: NSError!) -> Void in
            if error == nil {
                print("\(result)")
            } else {
                print("\(error)")
            }
        })
        
        
    }
*/
    
    func getProfilePicture(fbUserID: String){
        
        // FIX UNSAFE HTTP REQUEST (CHANGED IN INFO.PLIST TEMPORARILY)!
        
        let facebookProfileUrl = NSURL(string: "http://graph.facebook.com/\(fbUserID)/picture?type=large")
        
        if let data = NSData(contentsOfURL: facebookProfileUrl!) {
            userPicture.image = UIImage(data: data)
        }
    }
    
}
