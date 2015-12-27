//
//  MainTableViewController.swift
//  Synqr
//
//  Created by James Kim on 12/23/15.
//  Copyright © 2015 James Kim. All rights reserved.
//

import Foundation


class MainTableViewController: UITableViewController {
    
    var synqrCode : SynqrCode?
    
    @IBAction func saveToMainViewController (segue:UIStoryboardSegue) {
        
        tableView.reloadData()
        
        
    }
    
    
    // Code to be run when the segue is unwinded
    @IBAction func unwindToMainTableVC(segue: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loadCode = loadSynqrCode() {
            synqrCode = loadCode
        }
        else
        {
            synqrCode = SynqrCode()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
        saveSynqrCode()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Handle.allValues.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as! EditDataCell
        
        // Configure the cell...
        
        if let icon = UIImage(named: Handle.allValues[indexPath.row].rawValue){
            cell.iconImage.image = icon
        }
        cell.categoryLabel.text = handleName(rowToHandle(indexPath.row))
        
        if let value = synqrCode?.returnValue(rowToHandle(indexPath.row)){
            cell.contentLabel.text = value
            if (indexPath.row == 4){
                cell.contentLabel.text = "Logged In"
            }
        }else{
            cell.contentLabel.text = ""
            
        }
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 4 {
            self.performSegueWithIdentifier("fbLogin", sender: self)
        }
        else
        {
            self.performSegueWithIdentifier("edit", sender: self)
        }
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "edit" {
            
            let path = tableView.indexPathForSelectedRow
            
            let detailViewController = segue.destinationViewController as! DetailTableViewController
            
            detailViewController.type = Handle.allValues[path!.row]
            detailViewController.currentSynqrCode = synqrCode
            
        }
        else if segue.identifier == "fbLogin"
        {
            let fbLoginViewController = segue.destinationViewController as! FBLoginViewController
            
            fbLoginViewController.currentSynqrCode = synqrCode
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
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
    
}
