//
//  FBLoginViewController.swift
//  Synqr
//
//  Created by James Kim on 11/27/15.
//  Copyright © 2015 James Kim. All rights reserved.
//

import UIKit

class FBLoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var currentSynqrCode : SynqrCode?
    
    var infodict : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            self.getSaveFBUserID()
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                self.getSaveFBUserID()
                
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    
    
    // http://ashishkakkad.com/2015/05/facebook-login-swift-language-ios-8/
    
    
    // Sends a request to get the user id
    func getSaveFBUserID(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    
                    let fbid = result.valueForKey("id") as! String
                    print(fbid)
                    
                    self.currentSynqrCode?.facebook = fbid
                    
                    /*self.infodict = result as! NSDictionary
                    print(result)
                    print(self.infodict)
                    NSLog(self.infodict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String)
                    */
                }
            })
        }
    }
    
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

