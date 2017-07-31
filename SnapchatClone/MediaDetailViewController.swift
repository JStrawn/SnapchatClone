//
//  MediaDetailViewController.swift
//  SnapchatClone
//
//  Created by Juliana Strawn on 5/10/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import AVFoundation

class MediaDetailViewController: UIViewController {
    
    @IBOutlet weak var slowmotion: UIView!
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var myPhoto:UIImage!
    
    var filepath: URL!
    var player: AVPlayer!
    var isPaused: Bool!
    var isSlowMotion: Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        back.isUserInteractionEnabled = true
        let backTap = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        back.addGestureRecognizer(backTap)
        back.layer.cornerRadius = 15

        
        if myPhoto != nil {
            imageView.image = myPhoto
            slowmotion.isHidden = true
        } else {
            
            imageView.isHidden = true
            
            slowmotion.isUserInteractionEnabled = true
            let slowMotionTap = UITapGestureRecognizer(target: self, action: #selector(slowMotion))
            slowmotion.addGestureRecognizer(slowMotionTap)
            slowmotion.layer.cornerRadius = 15
            
            // create the player
            let videoURL = filepath
            player = AVPlayer(url: videoURL!)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.videoPlayerView.bounds
            self.videoPlayerView.layer.addSublayer(playerLayer)
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
        }
        
        let pauseTap = UITapGestureRecognizer(target: self, action: #selector(pauseVideo))
        videoPlayerView.isUserInteractionEnabled = true
        videoPlayerView.addGestureRecognizer(pauseTap)
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissViewController))
        swipeDownGesture.direction = .down
        self.view.addGestureRecognizer(swipeDownGesture)
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
    
    
    func dismissViewController() {
        self.dismiss(animated: false, completion: nil)
    }
    
}
