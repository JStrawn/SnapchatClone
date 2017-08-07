//
//  PhotosViewController.swift
//  SnapchatClone
//
//  Created by Juliana Strawn on 4/25/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import AVFoundation

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loginPrompt: UILabel!
    
    static var userID: String!
    static var media = [UploadedMedia]()
    let reuseIdentifier = "cell"
    static let sharedInstance = PhotosViewController()
    weak var delegate: CollectionViewReloadDelegate?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Photos"
        
        checkUserLoggedIn()
        
        self.collectionView.register(UINib(nibName: "MediaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        // set delegates
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        PhotosViewController.sharedInstance.delegate = self
        
        // collectionView layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.size.width/3, height: self.view.frame.size.width/3)
        collectionView.collectionViewLayout = layout
    }
    
    
    class func getUserID() {
        userID = FIRAuth.auth()?.currentUser?.uid
  
    }
    
    
    func checkUserLoggedIn() {
        
        // if user is not logged in
        if FIRAuth.auth()?.currentUser?.uid == nil {
            loginPrompt.isHidden = false
            
        } else {
            
            //if user is logged in, get the images from their folder
            loginPrompt.isHidden = true
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotosViewController.media.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MediaCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        let currentPhoto =  PhotosViewController.media[indexPath.row]
        
        if (nil == currentPhoto.videoFile) {
            cell.imageView.image = currentPhoto.UIImage!
            cell.mediaTypeImageView.isHidden = true
            
        } else {
            let asset = AVURLAsset(url: currentPhoto.videoFile!)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            
            let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
            
            do {
                let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
                cell.imageView.image = UIImage(cgImage: imageRef)
                cell.mediaTypeImageView.isHidden = false
                
            } catch let error as NSError {
                print("Image thumbnail generation failed with error \(error)")
                
            }
        }
        
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let currentPhoto =  PhotosViewController.media[indexPath.row]
        
        if currentPhoto.type == "photo" {
            let vc = MediaDetailViewController()
            vc.myPhoto = currentPhoto.UIImage
            present(vc, animated: true, completion: nil)
        } else if currentPhoto.type == "video" {
            let vc = MediaDetailViewController()
            vc.filepath = currentPhoto.videoFile
            present(vc, animated: true, completion: nil)
        }

    }
    
    
    class func postPhoto(myImage: UIImage) {
        
        //get references
        let storageRef = FIRStorage.storage().reference()
        
        //name the image
        let uuid = UUID().uuidString
        let imageRef = storageRef.child("images/\(uuid)")
        
        //convert it into a jpeg and compress it a little
        guard let imageData = UIImageJPEGRepresentation(myImage, 0.8) else {
            //show user error
            print("Could not convert image to compressed JPEG")
            return
        }
        
        // Upload the file to the path "images/uuid.jpg"
        imageRef.put(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                print(error?.localizedDescription ?? "There was a problem uploading photo")
                return
            }
            
            let databaseRef = FIRDatabase.database().reference()
            
            let downloadURL = metadata.downloadURL()?.absoluteString
            
            let newTodo: [String: Any] = ["imageURL" : "\(downloadURL!)", "mediaType" : "photo"]
            
            databaseRef.child("users").child(PhotosViewController.userID).child("images").child(uuid).setValue(newTodo)
            PhotosViewController.sharedInstance.delegate?.didGetPhoto()
            PhotosViewController.getPhotos()

        }
        
    }
    
    
    class func uploadVideo(videoFileLocation:URL) {
        
        // name the video
        // I know this says images but i don't feel like changing the folder name in firebase
        let uuid = UUID().uuidString
        
        //get references
        let storageRef = FIRStorage.storage().reference().child("images").child(uuid)
        
        storageRef.putFile(videoFileLocation as URL, metadata: nil, completion: { (metadata, error) in
            if error == nil {
                print("Successful video upload")
            } else {
                print(error?.localizedDescription ?? "there was an error uploading video")
            }
            
            
            //now put a link to the video in the user's database dictionary
            print(metadata ?? "no metadata")
            
            let databaseRef = FIRDatabase.database().reference()
            
            let downloadURL = metadata?.downloadURL()?.absoluteString
            
            let newTodo: [String: Any] = ["imageURL" : "\(downloadURL!)", "mediaType" : "video"]
            
            databaseRef.child("users").child(PhotosViewController.userID!).child("images").child(uuid).setValue(newTodo)
            PhotosViewController.sharedInstance.delegate?.didGetPhoto()
            PhotosViewController.getPhotos()

        })
        
    
    }
    
    
    class func getPhotos() {
        
        //if user is logged in, grab their images
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        if uid != nil {
        PhotosViewController.media.removeAll()
            
            FIRDatabase.database().reference().child("users").child(uid!).child("images").observeSingleEvent(of: .value, andPreviousSiblingKeyWith: { (snapshot, error) in
            
            if let imagesDictionaries = snapshot.value as? [String : [String:Any]] {
                
                print(imagesDictionaries[imagesDictionaries.keys.first!] ?? "NOTHNG HERE")
                
                var count = imagesDictionaries.count
                
                let accumulator = { () -> () in
                    count = count - 1
                    if( count == 0 ){
                        PhotosViewController.sharedInstance.delegate?.didGetPhoto()
                    }
                }
                
                for key in imagesDictionaries.values {
                    let downloadURL = key["imageURL"] as? String
                    let downloadMediaType = key["mediaType"] as? String
                    let downloadedMedia = UploadedMedia(url: downloadURL!, type: downloadMediaType!)
                    print(downloadedMedia.fileURL)
                    
                    guard let url = URL(string: downloadedMedia.fileURL)
                        else { continue }
                    
                    
                    
                    DispatchQueue.global().async {
                        guard let data = try? Data(contentsOf: url)
                            else { return }
                        DispatchQueue.main.async {
                            
                            if downloadedMedia.type == "photo" {
                                downloadedMedia.UIImage = UIImage(data: data)
                            } else {
                                downloadedMedia.videoFile = URL(string: downloadedMedia.fileURL)
                            }
                            
                            PhotosViewController.media.append(downloadedMedia)
                            accumulator()
                            
                        }
                        
                    }
                }
            }
            
        }, withCancel: nil)
        
        
    }
    }
    
    
    
    
    
}

// MARK: Delegate Method

extension PhotosViewController: CollectionViewReloadDelegate {
    func didGetPhoto() {
        self.collectionView.reloadData()
    }
}
