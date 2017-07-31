//
//  CameraRollSelectViewController.swift
//  SnapchatClone
//
//  Created by Juliana Strawn on 4/25/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class CameraRollSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UINavigationBarDelegate {
    
    var picker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Camera Roll"

        picker = UIImagePickerController()
        picker.delegate = self

        let uploadPhotoButton = UIButton(frame: CGRect(x: view.frame.width/4, y: view.center.y, width: view.frame.width/2, height: 20))
        uploadPhotoButton.setTitle("Upload a photo", for: .normal)
        uploadPhotoButton.backgroundColor = UIColor.green
        uploadPhotoButton.addTarget(self, action: #selector(openPickerView), for: .touchUpInside)
        self.view.addSubview(uploadPhotoButton)
    }
    
    
    func openPickerView() {

        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        var selectedImage:UIImage?
        
        if let croppedImage = info["UIImagePickerControllerEditedImage"] {
            selectedImage = croppedImage as? UIImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImage = originalImage as? UIImage
        }
        
        if let myImage = selectedImage {

            PhotosViewController.postPhoto(myImage: myImage)
        }
        
        picker.dismiss(animated: true, completion: nil)

    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)

    }
    
    

    
    
}
