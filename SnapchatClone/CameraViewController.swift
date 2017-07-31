//
//  CameraViewController.swift
//  SnapchatClone
//
//  Created by Juliana Strawn on 4/25/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

// All icons are from flatIcon.com

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var photosView: UIView!
    
    @IBOutlet weak var captureImageCircle: UIImageView!
    
    // av foundation related properties
    var session: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var imageOutput: AVCapturePhotoOutput!
    var videoOutput: AVCaptureMovieFileOutput!
    
    var capturedImage: UIImage!
    var capturedImageFilePath: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileView.layer.cornerRadius = 15
        self.photosView.layer.cornerRadius = 15
        
        captureImageCircle.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(capturePhoto))
        captureImageCircle.addGestureRecognizer(tap)
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(captureVideo))
        captureImageCircle.addGestureRecognizer(longTap)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        enableCamera()
        self.cameraView.alpha = 1.0
        
    }
    
    func enableCamera() {
        print("Starting the camera...")
        session = AVCaptureSession() // this is your VCR
        session.sessionPreset = AVCaptureSessionPresetHigh
        //set the framerate higher
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) // this is Video Camera
        videoCaptureDevice?.configureDesiredFrameRate(400)
        
        let videoInput: AVCaptureDeviceInput? // this is recording mode on video camera
        
        do {
            
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            
            
        } catch {
            print("Could not get capture device input")
            return
        }
        
        // now we have to connect the camera to the vcr to see video on big screen
        guard session.canAddInput(videoInput)
            else {
                print("Can't add input to capture session")
                return
        }
        session.addInput(videoInput)
        
        imageOutput = AVCapturePhotoOutput()
        videoOutput = AVCaptureMovieFileOutput()
        
        if session.canAddOutput(imageOutput) {
            // add output
            session.addOutput(imageOutput)
            
        } else {
            print("Can't add photo output to the thing")
            return
        }
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        } else {
            print("Can't add video output to the thing")
        }
        
        
        //set up preview layer (show it on the tv)
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraView.layer.addSublayer(previewLayer)
        
        //turn on the vcr and devices
        session.startRunning()
    }
    
    
    
    func capturePhoto() {
        
        imageOutput.capturePhoto(with: AVCapturePhotoSettings.init(format: [AVVideoCodecKey: AVVideoCodecJPEG]), delegate: self)
        
        disableCamera()
    }
    
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        
        if let jpegData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
            capturedImage = UIImage(data: jpegData)
        }
        
        if let error = error {
            print(error.localizedDescription)
        }
        
        let vc = PhotoTakenViewController()
        vc.photo = capturedImage
        present(vc, animated: false, completion: nil)
    }
    
    
    func captureVideo(sender: UILongPressGestureRecognizer) {
        
        //videoFileOutput = AVCaptureMovieFileOutput()
        
        if sender.state == .began {
            self.captureImageCircle.image = #imageLiteral(resourceName: "circumference-2")
            let recordingDelegate:AVCaptureFileOutputRecordingDelegate = self
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let filePath = documentsURL.appendingPathComponent("temp.mp4")
            
            videoOutput.startRecording(toOutputFileURL: filePath, recordingDelegate: recordingDelegate)
            
            
        }
        
        if sender.state == .ended {
            
            self.captureImageCircle.image = #imageLiteral(resourceName: "circumference")
            videoOutput.stopRecording()
        }
        
        
    }
    
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        print("Recording.....")
    }
    
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        
        if error != nil {
            print(error.localizedDescription)
        }
        
        print("capture did finish")
        print(captureOutput);
        print(outputFileURL);
        
        let vc = VideoTakenViewController()
        vc.filepath = outputFileURL
        present(vc, animated: false, completion: nil)
        
    }
    
    
    func disableCamera() {
        //session.stopRunning()
        
        //animation
        UIView.animate(withDuration: 0.5) {
            self.cameraView.alpha = 0.0
        }
    }
    
    
    
}


extension AVCaptureDevice {
    
    /// http://stackoverflow.com/questions/21612191/set-a-custom-avframeraterange-for-an-avcapturesession#27566730
    func configureDesiredFrameRate(_ desiredFrameRate: Int) {
        
        var isFPSSupported = false
        
        do {
            
            if let videoSupportedFrameRateRanges = activeFormat.videoSupportedFrameRateRanges as? [AVFrameRateRange] {
                for range in videoSupportedFrameRateRanges {
                    if (range.maxFrameRate >= Double(desiredFrameRate) && range.minFrameRate <= Double(desiredFrameRate)) {
                        isFPSSupported = true
                        break
                    }
                }
            }
            
            if isFPSSupported {
                try lockForConfiguration()
                activeVideoMaxFrameDuration = CMTimeMake(1, Int32(desiredFrameRate))
                activeVideoMinFrameDuration = CMTimeMake(1, Int32(desiredFrameRate))
                unlockForConfiguration()
            }
            
        } catch {
            print("lockForConfiguration error: \(error.localizedDescription)")
        }
    }
    
}
