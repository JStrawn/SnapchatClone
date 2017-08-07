//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Juliana Strawn on 4/25/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PhotosViewController.getUserID()
        
        createScrollView()
        
        PhotosViewController.getPhotos()
        
    }
    
    
    func createScrollView() {
        
        // create and add each viewcontroller
        let profileView = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        self.addChildViewController(profileView)
        self.scrollView.addSubview(profileView.view)
        profileView.didMove(toParentViewController: self)
        
        let cameraView = CameraViewController(nibName: "CameraViewController", bundle: nil)
        self.addChildViewController(cameraView)
        self.scrollView.addSubview(cameraView.view)
        cameraView.didMove(toParentViewController: self)
        
        let photosView = TabbedViewController(nibName: "PhotosViewController", bundle: nil)
        self.addChildViewController(photosView)
        self.scrollView.addSubview(photosView.view)
        photosView.didMove(toParentViewController: self)
        
        // set size & location of cameraView and Photosview (profile view is first so already set)
        var cameraViewFrame : CGRect = cameraView.view.frame
        cameraViewFrame.origin.x = self.view.frame.width
        cameraView.view.frame = cameraViewFrame
        
        var photosViewFrame : CGRect = photosView.view.frame
        photosViewFrame.origin.x = 2 * self.view.frame.width // * 2 to include camera
        photosView.view.frame = photosViewFrame
        
        // size of scrollview depends on number of views (3)
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: self.view.frame.size.height)
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            // do nothing, start on the login page
        } else {
            // start on middle page (camera)
            self.scrollView.contentOffset.x = self.view.frame.size.width
        }
        
        
    }
    
    
}

