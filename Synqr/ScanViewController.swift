//
//  ScanViewController.swift
//  Synqr
//
//  Created by James Kim on 12/23/15.
//  Copyright © 2015 James Kim. All rights reserved.
//


import UIKit
import AVFoundation
import AudioToolbox

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var qrCodeResult: UILabel!
    
    @IBOutlet weak var cameraCardButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var imgQRCode: UIImageView!
    
    @IBAction func unwindToScanVC(segue: UIStoryboardSegue) {
        
    }
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    
    // True: camera, False: card
    var cameraCardToggle : Bool = false
    
    
    var synqrCode : SynqrCode?
    var qrcodeImage: CIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraSelected()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.configureVideoCapture()
        self.addVideoPreviewLayer()
        self.initializeQRView()
        
        
        synqrCode = loadSynqrCode()
            
            
            /*SynqrCode(fname: "James", lname: "Kim", phone: "8573008238", email: "sunwookim@college.harvard.edu", facebook: "12312412312123", snapchat: "james_wookim", instagram: "")*/
        
        displayQRCodeImage()
        
        // Bring labels to front above the video layer
        
        self.view.bringSubviewToFront(blurView)
        self.view.bringSubviewToFront(qrCodeResult)
        self.view.bringSubviewToFront(cameraCardButton)
        self.view.bringSubviewToFront(imgQRCode)
        self.view.bringSubviewToFront(settingsButton)
        

    }
    
    override func viewDidAppear(animated: Bool) {
    
        super.viewDidAppear(animated)
        

        
        
        
    }
    

    @IBAction func cameraCardPressed(sender: AnyObject) {
        if cameraCardToggle == true {
            cardSelected()
        }
        else
        {
            cameraSelected()
        }
    }
    
    
    func cameraSelected(){
        self.cameraCardToggle = true
        self.cameraCardButton.selected = true
        self.blurView.hidden = true
        self.imgQRCode.hidden = true
    }
    
    
    func cardSelected(){
        self.cameraCardToggle = false
        self.cameraCardButton.selected = false
        self.blurView.hidden = false
        self.imgQRCode.hidden = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func configureVideoCapture() {
        
        let objCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error:NSError?
        let objCaptureDeviceInput: AnyObject!
        do {
            objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice) as AVCaptureDeviceInput
            
        } catch let error1 as NSError {
            error = error1
            objCaptureDeviceInput = nil
        }
        if (error != nil) {
            
            let alertController : UIAlertController = UIAlertController(title: "Device Error", message: "Capturing device not supported :P", preferredStyle: UIAlertControllerStyle.Alert)
            
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        captureSession = AVCaptureSession()
        captureSession?.addInput(objCaptureDeviceInput as! AVCaptureInput)
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        
        captureSession?.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }
    
    func addVideoPreviewLayer()
    {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        self.view.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
        
        
    }
    
    func initializeQRView()
    {
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.redColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 5
        self.view.addSubview(qrCodeFrameView!)
        self.view.bringSubviewToFront(qrCodeFrameView!)
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!)
    {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            qrCodeResult.text = "Please Point the Camera at a Card"
            return
        }
        
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == AVMetadataObjectTypeQRCode {
            let objBarCode = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = objBarCode.bounds;
            if objMetadataMachineReadableCodeObject.stringValue != nil {
                let qrString = objMetadataMachineReadableCodeObject.stringValue
                qrCodeResult.text = qrString
                
                if let decoded = SynqrCode(dataFromString: qrString) {
                    
                    self.synqrCode = decoded
                    performSegueWithIdentifier("ContactPanel", sender: nil)
                    
                } else {
                    
                    qrCodeResult.text = "Not a valid Synqr Code"
                }
                
                /*
                if let dataFromString = qrString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    
                    /*
                    let json = JSON(data: dataFromString)
                    
                    if let checkField = json["check"].string{
                        if (checkField == "Synqr")
                        {
                            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                            
                            for(type, content) in json {
                                contactDetail![type] = content.string
                            }

                            performSegueWithIdentifier("ContactPanel", sender: nil)
                        }
                        else
                        {
                            qrCodeResult.text = "Not a valid Synqr Code"
                        }

                    }
                    else
                    {
                        qrCodeResult.text = "Not a valid Synqr Code"
                    }
                    */
                }
                */
            }
        }
    }
    
    // Display the QR Code after scaling it
    func displayQRCodeImage() {
        qrcodeImage = synqrCode!.createQRCode()
        
        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
        
        imgQRCode.image = UIImage(CIImage: transformedImage)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if segue.identifier == "ContactPanel"{
            let vc = segue.destinationViewController as! ContactPanelViewController
            vc.synqrCode = self.synqrCode
        }
    }
    
    func loadSynqrCode() -> SynqrCode? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(SynqrCode.ArchiveURL.path!) as? SynqrCode
    }
    
    
}
