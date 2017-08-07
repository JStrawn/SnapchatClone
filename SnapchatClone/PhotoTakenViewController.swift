//
//  PhotoTakenViewController.swift
//  SnapchatClone
//
//  Created by Juliana Strawn on 5/1/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class PhotoTakenViewController: UIViewController {
    @IBOutlet weak var deletePhoto: UIView!
    @IBOutlet weak var uploadPhoto: UIView!

    

    @IBOutlet weak var photoTaken: UIImageView!
    
    var photo : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoTaken.image = photo
        
        deletePhoto.layer.cornerRadius = 15
        deletePhoto.isUserInteractionEnabled = true
        let deleteTap = UITapGestureRecognizer(target: self, action: #selector(deleteCurrentPhoto))
        deletePhoto.addGestureRecognizer(deleteTap)

        uploadPhoto.layer.cornerRadius = 15
        uploadPhoto.isUserInteractionEnabled = true
        let uploadTap = UITapGestureRecognizer(target: self, action: #selector(uploadCurrentPhoto))
        uploadPhoto.addGestureRecognizer(uploadTap)
    }
    
    func uploadCurrentPhoto() {
        self.dismiss(animated: false, completion: nil)
        PhotosViewController.postPhoto(myImage: photo)
    }
    
    func deleteCurrentPhoto() {
        self.dismiss(animated: false, completion: nil)
    }


}
