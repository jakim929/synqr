//
//  InfoPanelViewController.swift
//  Synqr
//
//  Created by James Kim on 12/23/15.
//  Copyright © 2015 James Kim. All rights reserved.
//

import Foundation


class InfoPanelViewController: UIViewController{
    
    var synqrCode : SynqrCode?

    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBAction func saveToInfoPanelVC (segue:UIStoryboardSegue) {
        
        //tableView.reloadData()
        
    }
    
    
    // Code to be run when the segue is unwinded
    @IBAction func unwindToMainTableVC(segue: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        */
        if let loadCode = loadSynqrCode() {
            synqrCode = loadCode
        }
        else
        {
            synqrCode = SynqrCode()
        }
        
        // Masking the image
        
        //userPicture.image = getProfilePicture((synqrCode?.facebook)!)
        userPicture.layer.cornerRadius = userPicture.frame.size.height / 2
        userPicture.layer.masksToBounds = true
        userPicture.layer.borderWidth = 0

        
        
        loadUpperHalf()
        
        saveSynqrCode()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        //tableView.reloadData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
    func loadUpperHalf(){
        nameLabel.text = synqrCode?.fullName
        phoneLabel.text = synqrCode?.phone
        emailLabel.text = synqrCode?.email
        
    }
    
    // Saves the code details to the phone
    func saveSynqrCode(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(synqrCode!, toFile: SynqrCode.ArchiveURL.path!)
        
        if !isSuccessfulSave {
            print("Failed to save")
        }
    }
    
    func loadSynqrCode() -> SynqrCode? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(SynqrCode.ArchiveURL.path!) as? SynqrCode
    }
    
    func getProfilePicture(fbUserID: String) -> UIImage?{
        
        // FIX UNSAFE HTTP REQUEST (CHANGED IN INFO.PLIST TEMPORARILY)!
        
        let facebookProfileUrl = NSURL(string: "http://graph.facebook.com/\(fbUserID)/picture?type=large")
        
        if let data = NSData(contentsOfURL: facebookProfileUrl!) {
            return UIImage(data: data)
        }
        else
        {
            return nil

        }
    }
    
    
    func maskImage(image:UIImage, mask:(UIImage))->UIImage{
        
        let imageReference = image.CGImage
        let maskReference = mask.CGImage
        
        let imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
            CGImageGetHeight(maskReference),
            CGImageGetBitsPerComponent(maskReference),
            CGImageGetBitsPerPixel(maskReference),
            CGImageGetBytesPerRow(maskReference),
            CGImageGetDataProvider(maskReference), nil, true)
        
        let maskedReference = CGImageCreateWithMask(imageReference, imageMask)
        
        let maskedImage = UIImage(CGImage:maskedReference!)
        
        return maskedImage
    }
    
}

extension InfoPanelViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

            return Handle.socialMedia.count

        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Social Media"
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("socialMediaCell", forIndexPath: indexPath) as! EditDataCell
        
        // Configure the cell...

            //let row = Handle.contact.count + indexPath.row
            let row = indexPath.row + 4
            if let icon = UIImage(named: Handle.allValues[row].rawValue){
                cell.iconImage.image = icon
            }
            
            cell.categoryLabel.text = handleName(rowToHandle(row))
            
            if let value = synqrCode?.returnValue(rowToHandle(row)){
                cell.contentLabel.text = value
                if (row == 4){
                    cell.contentLabel.text = "Logged In"
                }
            }else{
                cell.contentLabel.text = ""
                
            }
        
        
        return cell
    }

}

extension InfoPanelViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 4 {
            self.performSegueWithIdentifier("fbLogin", sender: self)
        }
        else
        {
            self.performSegueWithIdentifier("edit", sender: self)
        }
    }
    
}
