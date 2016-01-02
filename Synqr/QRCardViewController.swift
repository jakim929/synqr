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
    var synqrCode : SynqrCode?
    var qrcodeImage: CIImage!
    
    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func unwindToQRCodeVC(segue: UIStoryboardSegue) {
        let sourceVC = segue.sourceViewController as! InfoPanelViewController
        self.synqrCode = sourceVC.synqrCode
        
    }

    @IBAction func cancelToQRCodeVC(segue: UIStoryboardSegue) {
        
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
            
            statusLabel.text = "Your Synqr Code"
            displayQRCodeImage()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Display the QR Code after scaling it
    func displayQRCodeImage() {
        qrcodeImage = synqrCode!.createQRCode()
        
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




