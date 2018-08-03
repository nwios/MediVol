//
//  BarCodeScanner.swift
//  MediVol
//
//  Created by Nawaf Aldosari on 02/08/2018.
//  Copyright © 2018 Nawaf Aldosari. All rights reserved.
//

import UIKit
import AVFoundation
import Lottie

enum GradientDirection {
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
}

class BarCodeScanner: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var continueBTN: UIButton!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var animationView: LOTAnimationView!
    var animationViewe: LOTAnimationView!


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        continueBTN.layer.cornerRadius = 15.0
        cameraView.layer.cornerRadius = 100.0

        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.cameraView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.cameraView.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animationView = LOTAnimationView(name: "animation");
        animationView.frame = CGRect(x:87.0, y: 200.0, width: 200.0, height: 200.0)
        animationView.loopAnimation = false
        self.view.addSubview(animationView)
        self.animationView.play{ (finished) in
            self.animationView.removeFromSuperview()
        }
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.isStatusBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated:false);
        createGradientLayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.animationView.removeFromSuperview()
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        self.continueBTN.isHidden = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        animationView.removeFromSuperview()
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            self.animationViewe = LOTAnimationView(name: "success");
            animationViewe.frame = CGRect(x:87.0, y: 220.0, width: 200.0, height: 200.0)
            animationViewe.loopAnimation = false
            self.view.addSubview(animationViewe)
            self.animationViewe.play{ (finished) in
                self.animationViewe.removeFromSuperview()
                self.continueBTN.isHidden = false
            }
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)

        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        print(code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func createGradientLayer() {

        let color1 = UIColor(named: "Blue")!
        
        let color2 = UIColor(named: "Sky")!
        
        let gradient = CAGradientLayer()
        
        gradient.colors = [ color1.cgColor, color2.cgColor]
        
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        gradient.frame = CGRect(x:0, y:-50, width:view.frame.width, height:95)
        
        self.navigationController?.navigationBar.layer.sublayers?.insert(gradient, at: Int(1))
    }
    
    
}
