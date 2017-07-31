//
//  TabbedViewController.swift
//  SnapchatClone
//
//  Created by Juliana Strawn on 4/25/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class TabbedViewController:  UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Tab one
        let tabOne = PhotosViewController()
        let tabOneBarItem = UITabBarItem(title: "Photos", image:#imageLiteral(resourceName: "photo-camera-4") , selectedImage: #imageLiteral(resourceName: "photo-camera-4"))
        tabOne.tabBarItem = tabOneBarItem
        
        
        // Create Tab two
        let tabTwo = CameraRollSelectViewController()
        let tabTwoBarItem2 = UITabBarItem(title: "Camera Roll", image:#imageLiteral(resourceName: "picture"), selectedImage: #imageLiteral(resourceName: "picture"))
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
        
        self.viewControllers = [tabOne, tabTwo]
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title!)")
    }
}
