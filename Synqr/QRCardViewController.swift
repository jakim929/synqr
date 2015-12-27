//
//  QRCardViewController.swift
//  Synqr
//
//  Created by James Kim on 12/23/15.
//  Copyright © 2015 James Kim. All rights reserved.
//

import UIKit

class QRCardViewController : UIViewController
{
    
    var category = ["fname", "lname", "phone", "email", "facebook", "snapchat", "instagram"]
    var content: [String]?
    
    var synqrCode : SynqrCode?
    
    var qrcodeImage: CIImage!
    
    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func unwindToQRCodeVC(segue: UIStoryboardSegue) {
        let sourceVC = segue.sourceViewController as! MainTableViewController
        
        self.synqrCode = sourceVC.synqrCode
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synqrCode = loadSynqrCode()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        if (synqrCode?.fname == nil) || (synqrCode?.lname == nil)
        {
            statusLabel.text = "Please enter your personal data"
        }
        else
        {
            
            content = synqrCode?.returnArray()
            statusLabel.text = "Your Synqr Code"
            createQRCode()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createQRCode(){
        
        // create string to store in QR code, in format of JSON object
        var jsonString : String = "{"
        
        jsonString += "\"check\":\"Synqr\","
        
        // concatonate based on string
        for (var i = 0; i < content!.count; i++)
        {
            jsonString += "\""
            jsonString += category[i]
            jsonString += "\""
            jsonString += ":"
            jsonString += "\""
            jsonString += content![i]
            jsonString += "\""
            if (i < content!.count - 1){
                jsonString += ","
            }
        }
        jsonString += "}"
        print(jsonString)
        
        let data = jsonString.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter!.setValue(data, forKey: "inputMessage")
        filter!.setValue("Q", forKey: "inputCorrectionLevel")
        qrcodeImage = filter!.outputImage
        
        displayQRCodeImage()
        
    }
    
    
    // Display the QR Code after scaling it
    func displayQRCodeImage() {
        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))

        imgQRCode.image = UIImage(CIImage: transformedImage)
    }
    
    // Load the synqr code from the phone to the app
    
    func loadSynqrCode() -> SynqrCode? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(SynqrCode.ArchiveURL.path!) as? SynqrCode
    }
    
}




