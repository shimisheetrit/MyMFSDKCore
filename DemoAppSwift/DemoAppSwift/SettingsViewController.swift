//
//  SettingsViewController.swift
//  DemoAppSwift
//
//  Created by Shimi Sheetrit on 2/16/16.
//  Copyright © 2016 Matomy Media Group Ltd. All rights reserved.
//

import UIKit
import AVFoundation

class SettingsViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    
    private var isScannerReading: Bool!
    private var captureSession: AVCaptureSession!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!

    @IBOutlet weak var hashTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var viewPreview: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isScannerReading = false
        self.captureSession = nil
        
        self.startButton.layer.cornerRadius = 4.0
        self.statusLabel.text = "QR Code Reader is not yet running..."
        
        self.view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "dismissKeyboard"))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        
        self.hashTextField.resignFirstResponder()
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "SettingsToMainSegue") {
            
            if(self.hashTextField.text?.characters.count > 0) {
                
                let vc = segue.destinationViewController as! MainViewController
                vc.invh = self.hashTextField.text!
                
            }
        }
    }
    
    
    @IBAction func startStopReading(sender: AnyObject) {
        
        if(!self.isScannerReading) {
            if(self.startReading()) {
                
                self.startButton.setTitle("Stop", forState:UIControlState.Normal)
                self.statusLabel.text = "Scanning for QR Code..."
                
            }
        } else{
            
            self.stopReading()
            self.startButton.setTitle("Start!", forState:UIControlState.Normal)
            self.statusLabel.text = "QR Code Reader is not running..."
            
        }
        
        self.isScannerReading = !self.isScannerReading
        
    }
    
    func startReading () -> Bool {
        
        var input: AVCaptureDeviceInput
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            
            input = try AVCaptureDeviceInput.init(device: captureDevice!)
            
        }
        catch {
            
            return false
        }
        
        self.captureSession = AVCaptureSession.init()
        self.captureSession.addInput(input)
        
        let captureMetadataOutput = AVCaptureMetadataOutput.init()
        self.captureSession.addOutput(captureMetadataOutput)
        
        var dispatchQueue: dispatch_queue_t
        dispatchQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatchQueue)
        captureMetadataOutput.metadataObjectTypes = NSArray.init(object: AVMetadataObjectTypeQRCode) as [AnyObject]
        
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: self.captureSession)
        self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.videoPreviewLayer.frame = self.viewPreview.layer.bounds
        self.viewPreview.layer.addSublayer(self.videoPreviewLayer)
        
        self.captureSession.startRunning()
        
        return true
    }
    
    func stopReading() {
        
        self.captureSession.stopRunning()
        self.captureSession = nil
        self.videoPreviewLayer.removeFromSuperlayer()
    }
    
    //MARK: AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(captureOutput: AVCaptureOutput!,
        didOutputMetadataObjects metadataObjects: [AnyObject]!,
        fromConnection connection: AVCaptureConnection!) {
            
            if(metadataObjects != nil && metadataObjects.count > 0) {
                
                let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
                
                if(metadataObj.type == AVMetadataObjectTypeQRCode) {
                    
                    self.statusLabel.performSelectorOnMainThread("setText:", withObject: "QR Code Reader is not running...", waitUntilDone: false)
                    self.performSelectorOnMainThread("stopReading", withObject: nil, waitUntilDone: false)
                    
                    dispatch_async(dispatch_get_main_queue(), {
               
                        self.startButton.setTitle("Start!", forState:UIControlState.Normal)
                        self.hashTextField.text = metadataObj.stringValue
                        
                        })
                    
                        self.isScannerReading = false
                    
                }
    
            }
    }
    
    
}