//
//  VideoTakenViewController.swift
//  SnapchatClone
//
//  Created by Juliana Strawn on 5/1/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase
import Alamofire

class VideoTakenViewController: UIViewController {
    
    @IBOutlet weak var previewLayer: UIView!
    @IBOutlet weak var uploadButton: UIView!
    @IBOutlet weak var discardButton: UIView!
    @IBOutlet weak var slowMotionButton: UIView!
    
    var filepath: URL!
    var player: AVPlayer!
    var isPaused: Bool!
    var isSlowMotion: Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create the player
        let videoURL = filepath
        player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.previewLayer.bounds
        self.previewLayer.layer.addSublayer(playerLayer)
        player.play()
        isPaused = false
        isSlowMotion = false
        
        // loop the video
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil)
        { notification in
            
            if self.isSlowMotion == false {
                
                let t1 = CMTimeMake(5, 100);
                self.player.seek(to: t1)
                self.player.play()
                
            } else {
                
                let t1 = CMTimeMake(5, 300);
                self.player.seek(to: t1)
                self.player.play()
                self.player.rate = 0.2
                
            }
        }
        
        // button setup
        uploadButton.layer.cornerRadius = 15
        uploadButton.isUserInteractionEnabled = true
        let uploadTap = UITapGestureRecognizer(target: self, action: #selector(uploadVideo))
        uploadButton.addGestureRecognizer(uploadTap)
        
        discardButton.layer.cornerRadius = 15
        discardButton.isUserInteractionEnabled = true
        let discardTap = UITapGestureRecognizer(target: self, action: #selector(discardVideo))
        discardButton.addGestureRecognizer(discardTap)
        
        slowMotionButton.layer.cornerRadius = 15
        slowMotionButton.isUserInteractionEnabled = true
        let slowMotionTap = UITapGestureRecognizer(target: self, action: #selector(slowMotion))
        slowMotionButton.addGestureRecognizer(slowMotionTap)
        
        let pauseTap = UITapGestureRecognizer(target: self, action: #selector(pauseVideo))
        previewLayer.isUserInteractionEnabled = true
        previewLayer.addGestureRecognizer(pauseTap)
        
    }
    
    
    func uploadVideo() {
        PhotosViewController.uploadVideo(videoFileLocation: filepath)
        self.dismiss(animated: false, completion: nil)

    }
    
    
    func slowMotion() {
        
        if isSlowMotion == true {
            player.rate = 1.0
            isSlowMotion = false
        } else {
            player.rate = 0.2
            isSlowMotion = true
        }
    }
    
    
    func pauseVideo() {
        
        if isPaused == true {
            player.play()
            isPaused = false
        } else {
            player.pause()
            isPaused = true
        }
    }
    
    
    func discardVideo() {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    
}
