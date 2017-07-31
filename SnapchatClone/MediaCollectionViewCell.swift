//
//  MediaCollectionViewCell.swift
//  SnapchatClone
//
//  Created by Juliana Strawn on 5/8/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var mediaTypeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        mediaTypeImageView = UIImageView(image: #imageLiteral(resourceName: "video-camera"))
//        mediaTypeImageView.backgroundColor = UIColor.blue
//        mediaTypeImageView.frame = CGRect(x: imageView.frame.maxX - mediaTypeImageView.frame.width, y: imageView.frame.maxY, width: imageView.frame.width/6, height: imageView.frame.width/6)
//        imageView.addSubview(mediaTypeImageView)
    }

}
